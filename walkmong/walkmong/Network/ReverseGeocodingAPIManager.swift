//
//  ReverseGeocodingAPIManager.swift
//  walkmong
//
//  Created by 황채웅 on 11/11/24.
//

import Foundation

func callRequest(coords: String, completion: @escaping (Data) -> Void) {
    
    guard var urlComponents = URLComponents(string: "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc") else {
        print("URL Components Error")
        return
    }
    
    let queryItemArray = [
        URLQueryItem(name: "coords", value: coords),
        URLQueryItem(name: "orders", value: "roadaddr"),
        URLQueryItem(name: "output", value: "json")
    ]
    urlComponents.queryItems = queryItemArray
    
    guard let url = urlComponents.url else {
        print("URL Error")
        return
    }
    
    var urlRequest = URLRequest(url: url)
    
    if let clientID = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String,
       let secretKey = Bundle.main.object(forInfoDictionaryKey: "SECRET_KEY") as? String {
        urlRequest.addValue(clientID, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        urlRequest.addValue(secretKey, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
    }
    
    URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        
        guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("status code error")
            return
        }
        completion(data)
    }.resume()
}
