//
//  WalktalkChatViewController.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit
import SnapKit

class WalktalkChatViewController: UIViewController {
    
    private let walktalkChatView = WalktalkChatView()
    private let walktalkChatUpperView = WalktalkChatUpperView()
    private let walktalkChatContainerView = UIView()
    private let currentMatchingState: Status!

    private var containerBottomConstraint: Constraint?
    private var keyboardEventManager: KeyboardEventManager?
    
    private let service = WalktalkService()
    private let roomId: Int!

    required init(roomId: Int, currentMatchingState: Status) {
        self.roomId = roomId
        self.currentMatchingState = currentMatchingState
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
        // TODO: 소켓 통신 활성화
    }
    
    private func setUI() {
        view.addSubviews(walktalkChatContainerView, walktalkChatUpperView)
        walktalkChatContainerView.addSubview(walktalkChatView)
        walktalkChatUpperView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(52)
            make.horizontalEdges.equalToSuperview()
        }

        walktalkChatContainerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(walktalkChatUpperView.snp.top).offset(currentMatchingState == .COMPLETED || currentMatchingState == .REJECTED ? 88 - 30 : 149 - 30)
            containerBottomConstraint = make.bottom.equalToSuperview().offset(-38).constraint
        }

        walktalkChatView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        walktalkChatView.setupTextViewDelegate(delegate: self)
        addCustomNavigationBar(titleText: "유저 이름", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
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
        Task {
            do {
                let response = try await service.getHistory(roomId: roomId)
                
            } catch {
                print("채팅 히스토리 조회 실패: \(error)")
            }
        }
    }
}
