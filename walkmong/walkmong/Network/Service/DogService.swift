//
//  DogService.swift
//  walkmong
//
//  Created by 황채웅 on 12/28/24.
//

import Foundation

struct DogService {
    private let provider = NetworkProvider<DogAPI>()
    
    func getDogList() async throws -> DogListResponse {
        return try await provider.request(
            target: .getDogList,
            responseType: DogListResponse.self
        )
    }
    
    func getDogProfile(dogId: Int) async throws -> DogInfoResponse {
        return try await provider.request(
            target: .getDogProfile(dogId: dogId),
            responseType: DogInfoResponse.self
        )
    }
    
}
