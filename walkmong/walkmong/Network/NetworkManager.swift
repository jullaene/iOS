//
//  NetworkManager.swift
//  walkmong
//
//  Created by 신호연 on 11/15/24.
//

import Foundation
import Moya

class NetworkManager {
    private let provider = MoyaProvider<BoardAPI>()
    private let dogProvider = MoyaProvider<DogAPI>()
    
    func fetchBoardList(date: String?, addressId: Int?, distance: String?, dogSize: String?, matchingYn: String?, completion: @escaping (Result<[MatchingData], Error>) -> Void) {
        provider.request(.getBoardList(date: date, addressId: addressId, distance: distance, dogSize: dogSize, matchingYn: matchingYn)) { result in
            self.handleResponse(result: result, completion: completion)
        }
    }
    
    func fetchAddressList(completion: @escaping (Result<[BoardAddress], Error>) -> Void) {
        provider.request(.getAddressList) { result in
            self.handleResponse(result: result, completion: completion)
        }
    }
    
    func fetchBoardDetail(boardId: Int, completion: @escaping (Result<BoardDetail, Error>) -> Void) {
        provider.request(.getBoardDetail(boardId: boardId)) { result in
            self.handleResponse(result: result, completion: completion)
        }
    }

    // Updated Method with renamed struct
    func fetchDogProfile(dogId: Int, completion: @escaping (Result<DogProfileResponse, Error>) -> Void) {
        dogProvider.request(.getDogProfile(dogId: dogId)) { result in
            self.handleResponse(result: result, completion: completion)
        }
    }
    
    private func handleResponse<T: Decodable>(result: Result<Response, MoyaError>, completion: @escaping (Result<T, Error>) -> Void) {
        switch result {
        case .success(let response):
            do {
                let responseData = try JSONDecoder().decode(APIResponse<T>.self, from: response.data)
                if responseData.statusCode == 200 {
                    completion(.success(responseData.data))
                } else {
                    completion(.failure(NSError(domain: "APIError", code: responseData.statusCode, userInfo: [NSLocalizedDescriptionKey: responseData.message])))
                }
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
