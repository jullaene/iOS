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
    private let currentMatchingState: MatchingState = .matching

    private var containerBottomConstraint: Constraint?

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
            make.top.equalTo(walktalkChatUpperView.snp.top).offset(currentMatchingState == .ended || currentMatchingState == .cancelled ? 88 - 30 : 149 - 30)
            containerBottomConstraint = make.bottom.equalToSuperview().offset(-38).constraint
        }

        walktalkChatView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        walktalkChatView.setupTextViewDelegate(delegate: self)
        addCustomNavigationBar(titleText: "유저 이름", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
    }
    
    private func setUpKeyboardEvent() {
        dismissKeyboardOnTap(for: view)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(chatKeyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(chatKeyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc private func chatKeyboardWillShow(_ sender: Notification) {
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height

        containerBottomConstraint?.update(offset: -keyboardHeight)

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.walktalkChatView.scrollToBottom()
        }
    }


    @objc private func chatKeyboardWillHide(_ sender: Notification) {
        
        containerBottomConstraint?.update(offset: -38)

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
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
        // 텍스트뷰가 변경될 때 View에 알림
        walktalkChatView.updateTextViewHeight()
    }
}
