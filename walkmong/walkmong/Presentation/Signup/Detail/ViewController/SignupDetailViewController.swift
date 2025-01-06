//
//  SignupDetailViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/1/25.
//

import UIKit
import SnapKit

final class SignupDetailViewController: UIViewController {
    
    private let signupDetailView = SignupDetailView()
    private var isNicknamechecked = false
    private var keyboardManager: KeyboardEventManager?
    private var containerBottomConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setConstraints()
        addCustomNavigationBar(titleText: "가입하기", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        addProgressBar(currentStep: 1, totalSteps: 7)
        keyboardManager = KeyboardEventManager(delegate: self)
        dismissKeyboardOnTap()
        signupDetailView.delegate = self
    }
    
    private func addSubview() {
        view.addSubview(signupDetailView)
    }
    
    private func setConstraints() {
        signupDetailView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(156)
            containerBottomConstraint = make.bottom.equalToSuperview().constraint
        }
    }
}

extension SignupDetailViewController: SignupDetailViewDelegate {
    func shouldCheckNickname(_ textfield: UITextField) {
        if let nickname = textfield.text, nickname.count <= 6 {
            //TODO: 닉네임 중복 검사
            signupDetailView.updateNicknameState(isVaild: true, nickname: nickname)
        }
    }
    
    func didTapNextButton(_ view: SignupDetailView) {
        if isNicknamechecked {
            let nextVC = UIViewController() //FIXME: 프로필 사진 등록 화면
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

extension SignupEmailViewController {
    //TODO: 닉네임 중복 검사 API 호출
}

extension SignupDetailViewController: KeyboardObserverDelegate {
    func keyboardWillShow(keyboardHeight: CGFloat) {
        containerBottomConstraint?.update(offset: -keyboardHeight)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func keyboardWillHide() {
        containerBottomConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
