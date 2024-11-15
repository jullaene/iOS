//
//  NetworkManager.swift
//  walkmong
//
//  Created by 신호연 on 11/15/24.
//

import Foundation
import Moya

class NetworkManager {
    private let provider: MoyaProvider<MultiTarget>

    init() {
        provider = MoyaProvider<MultiTarget>()
    }
    
    func fetchBoardList(date: String?, addressId: Int?, distance: String?, dogSize: String?, matchingYn: String?, completion: @escaping (Result<[MatchingData], Error>) -> Void) {
        request(target: BoardAPI.getBoardList(date: date, addressId: addressId, distance: distance, dogSize: dogSize, matchingYn: matchingYn), completion: completion)
    }

    func fetchAddressList(completion: @escaping (Result<[BoardAddress], Error>) -> Void) {
        request(target: BoardAPI.getAddressList, completion: completion)
    }
    
    func fetchBoardDetail(boardId: Int, completion: @escaping (Result<BoardDetail, Error>) -> Void) {
        request(target: BoardAPI.getBoardDetail(boardId: boardId), completion: completion)
    }

    func fetchDogProfile(dogId: Int, completion: @escaping (Result<DogProfileResponse, Error>) -> Void) {
        request(target: DogAPI.getDogProfile(dogId: dogId), completion: completion)
    }
    
    private func request<T: Decodable>(target: TargetType, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(MultiTarget(target)) { result in
            switch result {
            case .success(let response):
                do {
                    let responseData = try Self.decoder.decode(APIResponse<T>.self, from: response.data)
                    if responseData.statusCode == 200 {
                        completion(.success(responseData.data))
                    } else {
                        completion(.failure(APIError.serverError(message: responseData.message, code: responseData.statusCode)))
                    }
                } catch {
                    completion(.failure(APIError.decodingError))
                }
            case .failure(let error):
                completion(.failure(APIError.networkError(description: error.localizedDescription)))
            }
        }
    }
    
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

enum APIError: Error {
    case serverError(message: String, code: Int)
    case decodingError
    case networkError(description: String)
}
