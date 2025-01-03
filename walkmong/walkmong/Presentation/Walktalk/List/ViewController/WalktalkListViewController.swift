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
    private var chatRoomData: ChatroomResponseData?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(walktalkListView)
        walktalkListView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(52)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        addCustomNavigationBar(titleText: "워크톡", showLeftBackButton: false, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
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
    
    func getChatroom(record: Record, status: Status) {
        Task {
            do {
                let response = try await service.getChatroom(record: record, status: status)
            } catch {
                print("채팅방 조회 실패: \(error)")
            }
        }
    }
}
