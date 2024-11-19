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
    private let useMockData: Bool

    init(useMockData: Bool = true) {
        self.provider = MoyaProvider<MultiTarget>()
        self.useMockData = useMockData
    }
    
    func fetchBoardList(date: String?, addressId: Int?, distance: String?, dogSize: String?, matchingYn: String?, completion: @escaping (Result<[MatchingData], Error>) -> Void) {
        if useMockData {
            let mockData = mockBoardList()
            completion(.success(mockData))
        } else {
            request(target: BoardAPI.getBoardList(date: date, addressId: addressId, distance: distance, dogSize: dogSize, matchingYn: matchingYn), completion: completion)
        }
    }

    func fetchAddressList(completion: @escaping (Result<[BoardAddress], Error>) -> Void) {
        if useMockData {
            completion(.success(mockAddressList()))
        } else {
            request(target: BoardAPI.getAddressList, completion: completion)
        }
    }
    
    func fetchBoardDetail(boardId: Int, completion: @escaping (Result<BoardDetail, Error>) -> Void) {
        if useMockData {
            completion(.success(mockBoardDetail()))
        } else {
            request(target: BoardAPI.getBoardDetail(boardId: boardId), completion: completion)
        }
    }

    func fetchDogProfile(dogId: Int, completion: @escaping (Result<DogProfile, Error>) -> Void) {
        if useMockData {
            completion(.success(mockDogProfile()))
        } else {
            request(target: DogAPI.getDogProfile(dogId: dogId), completion: completion)
        }
    }
    
    // 실제 네트워크 요청 처리
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
    
    // JSON 디코더 설정
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    // Mock 데이터
    private func mockBoardList() -> [MatchingData] {
        return [
            MatchingData(boardId: 1, startTime: "12:34", endTime: "12:50", matchingYn: "Y", dogName: "Dog1", dogProfile: "puppyImage01", dogGender: "FEMALE", breed: "말티즈", weight: 2, dogSize: "SMALL", content: "테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.", dongAddress: "노원구 공릉동", distance: 1, createdAt: "2024-11-11 14:30:00.000000"),
            MatchingData(boardId: 1, startTime: "12:34", endTime: "12:50", matchingYn: "N", dogName: "Dog1", dogProfile: "puppyImage01", dogGender: "FEMALE", breed: "말티즈", weight: 2, dogSize: "SMALL", content: "테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.", dongAddress: "노원구 공릉동", distance: 1, createdAt: "2024-11-11 14:30:00.000000"),
            MatchingData(boardId: 1, startTime: "12:34", endTime: "12:50", matchingYn: "Y", dogName: "Dog1", dogProfile: "puppyImage01", dogGender: "FEMALE", breed: "말티즈", weight: 2, dogSize: "SMALL", content: "테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.", dongAddress: "노원구 공릉동", distance: 1, createdAt: "2024-11-11 14:30:00.000000"),
            MatchingData(boardId: 1, startTime: "12:34", endTime: "12:50", matchingYn: "N", dogName: "Dog1", dogProfile: "puppyImage01", dogGender: "FEMALE", breed: "말티즈", weight: 2, dogSize: "SMALL", content: "테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.", dongAddress: "노원구 공릉동", distance: 1, createdAt: "2024-11-11 14:30:00.000000"),
            MatchingData(boardId: 1, startTime: "12:34", endTime: "12:50", matchingYn: "Y", dogName: "Dog1", dogProfile: "puppyImage01", dogGender: "FEMALE", breed: "말티즈", weight: 2, dogSize: "SMALL", content: "테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.", dongAddress: "노원구 공릉동", distance: 1, createdAt: "2024-11-11 14:30:00.000000"),
            MatchingData(boardId: 1, startTime: "12:34", endTime: "12:50", matchingYn: "N", dogName: "Dog1", dogProfile: "puppyImage01", dogGender: "FEMALE", breed: "말티즈", weight: 2, dogSize: "SMALL", content: "테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.테스트메시지가 두 줄은 넘어야 확인할수 있죠.", dongAddress: "노원구 공릉동", distance: 1, createdAt: "2024-11-11 14:30:00.000000")
        ]
    }

    private func mockAddressList() -> [BoardAddress] {
        let mockData = [
            BoardAddress(addressId: 1, dongAddress: "노원구 공릉동"),
            BoardAddress(addressId: 2, dongAddress: "마포구 공덕동")
        ]
        return mockData
    }

    private func mockBoardDetail() -> BoardDetail {
        return BoardDetail(dogId: 1, dogName: "봄별이", dogProfile: "puppyImage01", dogGender: "FEMALE", dogAge: 4, breed: "말티즈", weight: 4, dogSize: "SMALL", dongAddress: "동네 1", distance: 1, date: "2024-10-25", startTime: "12:34", endTime: "56:78", locationNegotiationYn: "Y", suppliesProvidedYn: "Y", preMeetAvailableYn: "Y", walkNote: "이건 세 줄 넘어야 될 거 같아요. 복붙을 많이 해볼게요.이건 세 줄 넘어야 될 거 같아요. 복붙을 많이 해볼게요.이건 세 줄 넘어야 될 거 같아요. 복붙을 많이 해볼게요.이건 세 줄 넘어야 될 거 같아요. 복붙을 많이 해볼게요.이건 세 줄 넘어야 될 거 같아요. 복붙을 많이 해볼게요.", walkRequest: "이건 세 줄 넘어야 될 거 같아요. 복붙을 많이 해볼게요.이건 세 줄 넘어야 될 거 같아요. 복붙을 많이 해볼게요.이건 세 줄 넘어야 될 거 같아요. 복붙을 많이 해볼게요.이건 세 줄 넘어야 될 거 같아요. 복붙을 많이 해볼게요.이건 세 줄 넘어야 될 거 같아요. 복붙을 많이 해볼게요.", additionalRequest: "이건 세 줄 넘어야 될 거 같아요. 복붙을 많이 해볼게요.이건 세 줄 넘어야 될 거 같아요. 복붙을 많이 해볼게요.이건 세 줄 넘어야 될 거 같아요. 복붙을 많이 해볼게요.이건 세 줄 넘어야 될 거 같아요. 복붙을 많이 해볼게요.이건 세 줄 넘어야 될 거 같아요. 복붙을 많이 해볼게요.", ownerName: "김철수", ownerAge: 27, ownerGender: "MALE", ownerProfile: "profileExample", ownerRate: 4.0)
    }

    private func mockDogProfile() -> DogProfile {
        return DogProfile(dogId: 1, dogName: "봄별이", dogProfile: "puppyImage01", dogGender: "FEMALE", dogAge: 4, breed: "말티즈", weight: 4, neuteringYn: "N", bite: "가끔물수도 안 물수도 이것도 두 줄로 테스트 하는 게 좋을수도.가끔물수도 안 물수도 이것도 두 줄로 테스트 하는 게 좋을수도.가끔물수도 안 물수도 이것도 두 줄로 테스트 하는 게 좋을수도.", friendly: "가끔물수도 안 물수도 이것도 두 줄로 테스트 하는 게 좋을수도.가끔물수도 안 물수도 이것도 두 줄로 테스트 하는 게 좋을수도.가끔물수도 안 물수도 이것도 두 줄로 테스트 하는 게 좋을수도.", barking: "가끔물수도 안 물수도 이것도 두 줄로 테스트 하는 게 좋을수도.가끔물수도 안 물수도 이것도 두 줄로 테스트 하는 게 좋을수도.가끔물수도 안 물수도 이것도 두 줄로 테스트 하는 게 좋을수도.", rabiesYn: "N")
    }
}

// API 에러 정의
enum APIError: Error {
    case serverError(message: String, code: Int)
    case decodingError
    case networkError(description: String)
}
