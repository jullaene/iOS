//
//  RegisterPetSocialityViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/14/25.
//

import UIKit

final class RegisterPetSocialityViewController: UIViewController {

    private let mainView = RegisterPetMessageView()
    private var keyboardManager: KeyboardEventManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setConstraints()
        addCustomNavigationBar(titleText: "반려견 등록하기", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        addProgressBar(currentStep: 2, totalSteps: 3)
        dismissKeyboardOnTap()
        mainView.delegate = self
        keyboardManager = KeyboardEventManager(delegate: self)
    }
    
    private func addSubview() {
        view.addSubview(mainView)
    }
    
    private func setConstraints() {
        mainView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(156)
        }
    }
}

extension RegisterPetSocialityViewController: KeyboardObserverDelegate {
    func keyboardWillShow(keyboardHeight: CGFloat) {
        
    }
    
    func keyboardWillHide() {
        
    }
}

extension RegisterPetSocialityViewController: RegisterPetMessageViewDelegate {
    func didTapNextButton() {
        
    }
}
