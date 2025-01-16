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

    /// 비동기 API 호출 메서드
    func request<ResponseType: Decodable>(
        target: T,
        responseType: ResponseType.Type
    ) async throws -> ResponseType {
        do {
            /// 최초 API 요청
            print("Request URL: \(target.baseURL.appendingPathComponent(target.path))")
            let response = try await provider.requestAsync(target)
            if let errorMessage = String(data: response.data, encoding: .utf8) {
                print(errorMessage)
            }
            // 상태 코드 처리
            switch response.statusCode {
            case 200...299:
                // 성공: 데이터 디코딩 후 반환
                return try JSONDecoder().decode(ResponseType.self, from: response.data)
            case 401:
                // 401: 토큰 만료 처리
                try await refreshAccessToken()

                // 갱신된 토큰으로 재요청
                let retryResponse = try await provider.requestAsync(target)
                if (200...299).contains(retryResponse.statusCode) {
                    return try JSONDecoder().decode(ResponseType.self, from: retryResponse.data)
                } else {
                    throw NetworkError.unauthorized
                }
            default:
                if let jsonObject = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any],
                   let message = jsonObject["message"] as? String {
                    print(message) // 메시지만 출력
                    throw NetworkError.errorWithMessage(message: message)
                } else {
                    throw NetworkError.unknown
                }
            }
        } catch let error as MoyaError {
            /// 기타 네트워크 관련 에러 처리
            throw error
        }
    }



    /// AccessToken 갱신 메서드
    private func refreshAccessToken() async throws {
        guard let refreshToken = AuthManager.shared.refreshToken else {
            /// RefreshToken이 없으면 로그아웃 처리할 수 있도록 설정
            throw NetworkError.unauthorized
        }

        do {
            let service = AuthService()
            let response = try await service.refreshAccessToken(refreshToken: refreshToken)
            
            /// 갱신된 토큰 저장
            AuthManager.shared.accessToken = response.data.accessToken
            AuthManager.shared.refreshToken = response.data.refreshToken
        } catch {
            /// 갱신 실패 처리
            throw NetworkError.tokenRefreshFailed
        }
    }

}

extension MoyaProvider {
    func requestAsync(_ target: Target) async throws -> Response {
        return try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
