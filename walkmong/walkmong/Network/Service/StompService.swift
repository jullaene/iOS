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
        guard let urlString = SecretManager.shared.BASE_URL,
              let url = URL(string: urlString) else {
            fatalError("Initialization failed: Missing URL")
        }
        if let token = AuthManager.shared.token {
            self.connectionHeaders = ["Authorization": "Bearer \(token)"]
        }else {
            let testToken = "testToken"
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
    
    func sendMessage(body: String, to destination: String, with receipt: String) {
        stompClient.sendMessage(message: body, toDestination: destination, withHeaders: connectionHeaders, withReceipt: receipt)
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
        print("[STOMP] Sent Error: \(description)")
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
