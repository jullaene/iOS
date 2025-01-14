//
//  BoardService.swift
//  walkmong
//
//  Created by 신호연 on 1/11/25.
//

import Foundation

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
            let response = try await provider.request(
                target: .getBoardDetail(boardId: boardId),
                responseType: BoardDetail.self
            )
            return response
        } catch {
            throw error
        }
    }
}
