//
//  GeocodingAPIManager.swift
//  walkmong
//
//  Created by 황채웅 on 11/11/24.
//

import Foundation

func callRequest(query: String, completion: @escaping (Data) -> Void) {
    
    guard var urlComponents = URLComponents(string: "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode") else {
        print("URL Components Error")
        return
    }
    
    let queryItemArray = [
        URLQueryItem(name: "query", value: query)
    ]
    urlComponents.queryItems = queryItemArray
    
    guard let url = urlComponents.url else {
        print("URL Error")
        return
    }
    
    var urlRequest = URLRequest(url: url)
    
    urlRequest.addValue("클라이언트Id", forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
    urlRequest.addValue("secret 키", forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
    
    URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        
        guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("status code error")
            return
        }
        completion(data)
    }.resume()
}
