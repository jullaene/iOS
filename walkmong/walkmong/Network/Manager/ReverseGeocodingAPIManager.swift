//
//  ReverseGeocodingAPIManager.swift
//  walkmong
//
//  Created by 황채웅 on 11/11/24.
//

import Foundation

func callRequest(coords: String) async throws -> Data {
    guard var urlComponents = URLComponents(string: "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc") else {
        throw NSError(domain: "URLComponentsError", code: 100, userInfo: nil)
    }
    
    let queryItemArray = [
        URLQueryItem(name: "coords", value: coords),
        URLQueryItem(name: "orders", value: "roadaddr"),
        URLQueryItem(name: "output", value: "json")
    ]
    urlComponents.queryItems = queryItemArray
    
    guard let url = urlComponents.url else {
        throw NSError(domain: "URLCreationError", code: 101, userInfo: nil)
    }
    
    var urlRequest = URLRequest(url: url)
    
    if let clientID = SecretManager.shared.NAVER_CLI_ID,
       let secretKey = SecretManager.shared.NAVER_KEY {
        urlRequest.addValue(clientID, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        urlRequest.addValue(secretKey, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
    }
    
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw NSError(domain: "HTTPError", code: 102, userInfo: nil)
    }
    
    return data
}
