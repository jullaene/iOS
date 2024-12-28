//
//  GeocodingAPIManager.swift
//  walkmong
//
//  Created by 황채웅 on 11/11/24.
//

import Foundation

func callRequest(query: String) async throws -> Data {
    
    guard var urlComponents = URLComponents(string: "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode") else {
        throw URLError(.badURL)
    }
    
    let queryItemArray = [
        URLQueryItem(name: "query", value: query)
    ]
    urlComponents.queryItems = queryItemArray
    
    guard let url = urlComponents.url else {
        throw URLError(.badURL)
    }
    
    var urlRequest = URLRequest(url: url)
    
    guard let id = SecretManager.shared["NAVER_CLI_ID"],
          let key = SecretManager.shared["NAVER_KEY"] else {
        throw NSError(domain: "GeocodingAPIManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing API keys"])
    }
        
    urlRequest.addValue(id, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
    urlRequest.addValue(key, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
    
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw NSError(domain: "GeocodingAPIManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response or status code"])
    }
    
    return data
}
