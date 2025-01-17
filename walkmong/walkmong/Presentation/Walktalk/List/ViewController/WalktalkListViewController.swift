//
//  WalktalkListViewController.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit

final class WalktalkListViewController: UIViewController {
    
    private let walktalkListView = WalktalkListView()
    private let service = WalktalkService()
    private let stompService = StompService()
    private var chatRoomData: [ChatroomResponseData]?
    private var selectedTabbarIndex: Int = 0
    private var selectedMatchingStatusIndex = 0
    
    private var subscribedRooms = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        setUI()
        setupStompService()
        stompService.connect()
    }
    
    private func setupStompService() {
        stompService.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stompService.disconnect()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(walktalkListView)
        walktalkListView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(52)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-86)
        }
        addCustomNavigationBar(titleText: "워크톡", showLeftBackButton: false, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        walktalkListView.delegate = self
    }
}
extension WalktalkListViewController {
    func getChatroom(record: Record, status: Status){
        showLoading()
        defer { hideLoading() }
        Task {
            do {
                let response = try await service.getChatroom(record: record, status: status)
                chatRoomData = response.data
                walktalkListView.setContent(with: response.data)
                subscribeToChatrooms()
            } catch let error as NetworkError {
                print("채팅방 조회 실패: \(error.message)")
                walktalkListView.setContent(with: [])
            }
        }
    }
    
    private func subscribeToChatrooms() {
        guard let data = chatRoomData else { return }
        for chatRoom in data {
            let target = "/sub/chat/room/\(chatRoom.roomId)"
            if !subscribedRooms.contains(target) {
                print("여기로 구독: " + target)
                stompService.subscribe(to: target)
                subscribedRooms.insert(target)
                stompService.sendMessage(message: "ㅋㅋㅋ테스트에요 ㅠㅠ", to: chatRoom.roomId)
            }
        }

    }
}

extension WalktalkListViewController: StompServiceDelegate {
    func stompServiceDidConnect(_ service: StompService) {
        guard let data = chatRoomData else { return }
        for chatRoom in data {
            let target = "/sub/chat/room/\(chatRoom.roomId)"
            if !subscribedRooms.contains(target) {
                stompService.subscribe(to: target)
                subscribedRooms.insert(target)
            }
        }
    }
    
    func stompService(_ service: StompService, didReceiveMessage message: String, from destination: String) {
        guard let newMessage = decodeMessage(message) else {
            print("메시지 디코딩 실패")
            return
        }
        updateChatroomData(roomId: extractRoomId(from: destination), lastChat: newMessage.msg, lastChatTime: newMessage.sendTime)
    }
    
    func stompService(_ service: StompService, didReceiveError error: String) {
        CustomAlertViewController.CustomAlertBuilder(viewController: self)
            .setTitleState(.useTitleOnly)
            .setButtonState(.singleButton)
            .setTitleText("에러")
            .setSingleButtonTitle("돌아가기")
            .setSingleButtonAction({
                if let tabBarController = self.tabBarController {
                    tabBarController.selectedIndex = 0
                }
            })
            .showAlertView()
    }
    
}

extension WalktalkListViewController: WalktalkListViewDelegate {
    func didSelectTabBarIndex(record: Record, status: Status){
        getChatroom(record: record, status: status)
    }
}

extension WalktalkListViewController {
    func updateChatroomData(roomId: Int, lastChat: String, lastChatTime: String) {
        guard var data = chatRoomData else { return }
        
        if let index = data.firstIndex(where: { $0.roomId == roomId }) {
            var updatedChatroom = data[index]
            updatedChatroom.lastChat = lastChat
            updatedChatroom.lastChatTime = lastChatTime
            updatedChatroom.notRead += 1
            
            data.remove(at: index)
            data.insert(updatedChatroom, at: 0)
            
            chatRoomData = data
            
            walktalkListView.setContent(with: data)
        }
    }
    
    private func extractRoomId(from destination: String) -> Int {
        let components = destination.split(separator: "/")
        guard let lastComponent = components.last, let roomId = Int(lastComponent) else {
            return -1
        }
        return roomId
    }
    private func decodeMessage(_ message: String) -> MessageReceivedModel? {
        let decoder = JSONDecoder()
        guard let data = message.data(using: .utf8) else { return nil }
        do {
            return try decoder.decode(MessageReceivedModel.self, from: data)
        } catch {
            print("디코딩 오류: \(error)")
            return nil
        }
    }
}
