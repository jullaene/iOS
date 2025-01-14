//
//  BoardService.swift
//  walkmong
//
//  Created by 신호연 on 1/11/25.
//

import Foundation
import Moya

struct BoardService {
    private let provider = NetworkProvider<BoardAPI>()
    
    func getBoardList(parameters: [String: String]) async throws -> BoardListResponse {
        do {
            let response = try await provider.request(
                target: .getBoardList(parameters: parameters),
                responseType: BoardListResponse.self
            )
            return response
        } catch {
            throw error
        }
    }
    
    func getAddressList() async throws -> AddressListResponse {
        do {
            let response = try await provider.request(
                target: .getAddressList,
                responseType: AddressListResponse.self
            )
            return response
        } catch {
            throw error
        }
    }
    
    func registerBoard(parameters: [String: Any]) async throws -> BoardRegisterResponse {
        do {
            let response = try await provider.request(
                target: .registerBoard(parameters: parameters),
                responseType: BoardRegisterResponse.self
            )
            return response
        } catch {
            throw error
        }
    }
    
    func getBoardDetail(boardId: Int) async throws -> BoardDetail {
        do {
            print("📤 Sending request for boardId: \(boardId)")
            let response = try await provider.request(
                target: .getBoardDetail(boardId: boardId),
                responseType: BoardDetail.self
            )
            print("✅ Response: \(response)")
            return response
        } catch {
            print("❌ Error during getBoardDetail: \(error.localizedDescription)")
            if let moyaError = error as? MoyaError {
                switch moyaError {
                case .statusCode(let response):
                    print("❌ Status Code: \(response.statusCode)")
                    print("❌ Response Data: \(String(data: response.data, encoding: .utf8) ?? "No data")")
                case .underlying(let nsError, _):
                    print("❌ Underlying Error: \(nsError.localizedDescription)")
                default:
                    print("❌ Moya Error: \(moyaError)")
                }
            }
            throw error
        }
    }
}
