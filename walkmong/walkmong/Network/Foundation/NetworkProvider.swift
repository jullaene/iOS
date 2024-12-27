//
//  NetworkProvider.swift
//  walkmong
//
//  Created by 황채웅 on 12/27/24.
//

import Foundation
import Moya

/// APIEndpoint 프로토콜(중복되는 토큰 및 baseURL을 미리 처리)을 준수하는 모든 타입에 대해 공통적으로 사용 가능한 범용 NetworkProvider 클래스입니다.
final class NetworkProvider<T: APIEndpoint> {
    private let provider: MoyaProvider<T>

    init(provider: MoyaProvider<T> = MoyaProvider<T>()) {
        self.provider = provider
    }

    func request<ResponseType: Decodable>(
        target: T,
        responseType: ResponseType.Type,
        completion: @escaping (Result<ResponseType, Error>) -> Void
    ) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let decodedData = try JSONDecoder().decode(ResponseType.self, from: filteredResponse.data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
