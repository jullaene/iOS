//
//  WalktalkChatViewController.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit
import SnapKit

class WalktalkChatViewController: UIViewController {
    
    private lazy var walktalkChatView = WalktalkChatView()
    private lazy var walktalkChatUpperView = WalktalkChatUpperView(matchingState: self.dataModel.matchingState)
    private let walktalkChatContainerView = UIView()
    private let currentMatchingState: Status!

    private var containerBottomConstraint: Constraint?
    private var keyboardEventManager: KeyboardEventManager?
    
    private let service = WalktalkService()
    private let stompService = StompService()
    private let roomId: Int!
    private let targetName: String!
    
    private var dataModel: WalkTalkChatLogModel!

    required init(datamodel: WalkTalkChatLogModel, targetName: String) {
        self.targetName = targetName
        self.dataModel = datamodel
        self.currentMatchingState = datamodel.matchingState
        self.roomId = datamodel.roomId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        setUpKeyboardEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupStompService()
        getHistory(roomId: roomId)
    }
    
    private func setUI() {
        view.addSubviews(walktalkChatContainerView, walktalkChatUpperView)
        walktalkChatContainerView.addSubview(walktalkChatView)
        walktalkChatUpperView.setMatchingState(currentMatchingState)
        walktalkChatUpperView.setContent(dogName: dataModel.dogName, date: dataModel.date, profileImageURL: dataModel.profileImageUrl)
        walktalkChatUpperView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(52)
            make.horizontalEdges.equalToSuperview()
        }

        walktalkChatContainerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(walktalkChatUpperView.snp.top).offset(currentMatchingState == .AFTER || currentMatchingState == .REJECT ? 88 - 30 : 149 - 30)
            containerBottomConstraint = make.bottom.equalToSuperview().offset(-38).constraint
        }

        walktalkChatView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        walktalkChatView.setupTextViewDelegate(delegate: self)
        addCustomNavigationBar(titleText: targetName, showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        walktalkChatView.delegate = self
        walktalkChatUpperView.delegate = self
    }
    
    private func setupStompService() {
        stompService.delegate = self
    }
    
    private func setUpKeyboardEvent() {
        walktalkChatView.setupTextViewDelegate(delegate: self)
        keyboardEventManager = KeyboardEventManager(delegate: self)
        dismissKeyboardOnTap()
    }

}

extension WalktalkChatViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "메시지 보내기" {
            textView.text = ""
            textView.textColor = .mainBlack
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메시지 보내기"
            textView.textColor = UIColor(hexCode: "#D8DDE4")
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        walktalkChatView.updateTextViewHeight()
    }
}


extension WalktalkChatViewController: KeyboardObserverDelegate {
    func keyboardWillShow(keyboardHeight: CGFloat) {
        containerBottomConstraint?.update(offset: -keyboardHeight)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.walktalkChatView.scrollToBottom()
        }
    }

    func keyboardWillHide() {
        containerBottomConstraint?.update(offset: -38)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension WalktalkChatViewController {
    func getHistory(roomId: Int) {
        showLoading()
        Task {
            do {
                let response = try await service.getHistory(roomId: roomId)
                print("채팅 히스토리 조회 성공: \(response)")
                walktalkChatView.updateChatLog(response.data)
            } catch {
                print("채팅 히스토리 조회 실패: \(error)")
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
            hideLoading()
        }
    }

    private func decodeMessage(_ message: String) -> HistoryItem? {
        let decoder = JSONDecoder()
        guard let data = message.data(using: .utf8) else { return nil }
        do {
            return try decoder.decode(HistoryItem.self, from: data)
        } catch {
            print("디코딩 오류: \(error)")
            return nil
        }
    }
}

extension WalktalkChatViewController: StompServiceDelegate {
    func stompServiceDidConnect(_ service: StompService) {
        
    }
    
    func stompService(_ service: StompService, didReceiveMessage message: String, from destination: String) {
        guard let newMessage = decodeMessage(message) else {
            print("메시지 디코딩 실패")
            return
        }
        walktalkChatView.appendMessage(newMessage)
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

extension WalktalkChatViewController: WalktalkChatViewDelegate {
    func didSendMessage(_ message: String) {
        stompService.sendMessage(body: message, to: "/sub/chat/room/\(String(describing: roomId))", with: "no receipt")
    }
}

extension WalktalkChatViewController: WalktalkChatUpperViewDelegate {
    func didTapProfileImageView() {
        //TODO: 상대방 프로필 UI 구현 이후 연결
    }
    
    func didTapChangePlaceButton() {
        let nextVC = MatchingApplyMapViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func updatePlace(with data: MatchingApplyMapModel){
        //TODO: 만남 장소 변경 API 호출
    }
}
