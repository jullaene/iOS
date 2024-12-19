//
//  WalktalkChatViewController.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit

class WalktalkChatViewController: UIViewController {
    
    private let walktalkChatView = WalktalkChatView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(walktalkChatView)
        dismissKeyboardOnTap()
        walktalkChatView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(156)
            make.bottom.equalToSuperview().offset(-34)
            make.horizontalEdges.equalToSuperview()
        }
        walktalkChatView.setupTextViewDelegate(delegate: self)
        addCustomNavigationBar(titleText: "유저 이름", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        //TODO: 소켓 통신 활성화
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
