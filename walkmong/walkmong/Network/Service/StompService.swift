//
//  StompService.swift
//  walkmong
//
//  Created by 황채웅 on 1/2/25.
//

import StompClientLib

class StompService {
    private let stompClient = StompClientLib()
    private let socketURL: URL
    private let connectionHeaders: [String: String]
    
    weak var delegate: StompServiceDelegate?
    
    init() {
        guard let urlString = SecretManager.shared.SOCKET_URL,
              let url = URL(string: urlString) else {
            fatalError("Initialization failed: Missing URL")
        }
        if let token = AuthManager.shared.accessToken {
            self.connectionHeaders = ["Authorization": "Bearer \(token)"]
        }else {
            guard let testToken = SecretManager.shared.TEST_TOKEN else {
                fatalError("Initialization failed: Missing TEST_TOKEN")
            }
            self.connectionHeaders = ["Authorization": "Bearer \(testToken)"]
        }
        self.socketURL = url
    }
    
    func connect() {
        let request = NSURLRequest(url: socketURL)
        stompClient.openSocketWithURLRequest(
            request: request,
            delegate: self,
            connectionHeaders: connectionHeaders
        )
    }
    
    func disconnect() {
        stompClient.disconnect()
    }
    
    func subscribe(to destination: String) {
        stompClient.subscribe(destination: destination)
    }
    
    func unsubscribe(from destination: String) {
        stompClient.unsubscribe(destination: destination)
    }
    
    func sendMessage(message: String, to roomId: Int) {
        let payloadObject: [String: Any] = [
            "roomId": roomId,
            "type": "TALK",
            "message": message
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payloadObject, options: [])
            
            // JSON 문자열로 변환
            if let jsonText = String(data: jsonData, encoding: .utf8) {
                // 헤더 설정
                let headers = ["Authorization": "Bearer \(AuthManager.shared.accessToken)"]
                
                // STOMP 메시지 전송
                stompClient.sendMessage(
                    message: jsonText,
                    toDestination: "/pub/message/send",
                    withHeaders: headers,
                    withReceipt: nil
                )
            } else {
                print("JSON 문자열 변환 실패")
            }
        } catch {
            print("메시지 데이터 직렬화 실패: \(error.localizedDescription)")
        }
    }
}

extension StompService: StompClientLibDelegate {
    
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("[STOMP] Received Message: \(String(describing: jsonBody?.value(forKey: "msg")))")
        delegate?.stompService(self, didReceiveMessage: (String(describing: jsonBody?.value(forKey: "msg"))), from: destination)
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("[STOMP] Sent receipt: \(receiptId)")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("[STOMP] Sent Error: \(description)\n\(message ?? "")")
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("[STOMP] Connected")
        delegate?.stompServiceDidConnect(self)
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("[STOMP] Disconnected")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String) {
        print("[STOMP] Server error: \(description)")
        delegate?.stompService(self, didReceiveError: description)
    }
    
    func serverDidSendPing() {
        print("[STOMP] Ping received")
    }
}

protocol StompServiceDelegate: AnyObject {
    func stompServiceDidConnect(_ service: StompService)
    func stompService(_ service: StompService, didReceiveMessage message: String, from destination: String)
    func stompService(_ service: StompService, didReceiveError error: String)
}
