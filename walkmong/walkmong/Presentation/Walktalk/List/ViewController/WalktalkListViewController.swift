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
        setUI()
        setupStompService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
            make.horizontalEdges.bottom.equalToSuperview()
        }
        addCustomNavigationBar(titleText: "워크톡", showLeftBackButton: false, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        walktalkListView.delegate = self
    }
}
extension WalktalkListViewController {
    func createChatroom(boardId: Int) {
        Task {
            do {
                let response = try await service.createChatroom(boardId: boardId)
            } catch {
                print("채팅방 생성 실패: \(error)")
            }
        }
    }
    
    func getChatroom(record: Record, status: Status){
        Task {
            do {
                let response = try await service.getChatroom(record: record, status: status)
                chatRoomData = response.data
                stompService.connect()
                walktalkListView.setContent(with: response.data)
            } catch {
                print("채팅방 조회 실패: \(error)")
                walktalkListView.setContent(with: [])
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
        didSelectTabBarIndex(record: Record.from(index: selectedTabbarIndex), status: Status.from(index: selectedMatchingStatusIndex))
        if let data = chatRoomData {
            walktalkListView.setContent(with: data)
        }
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
