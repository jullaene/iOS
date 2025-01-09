//
//  SignupDetailViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/1/25.
//

import UIKit
import SnapKit

final class SignupDetailViewController: UIViewController {
    
    let signupDetailView = SignupDetailView()
    private var isNicknamechecked = false
    private var keyboardManager: KeyboardEventManager?
    private var containerBottomConstraint: Constraint?
    private let service = AuthService()
    private var signupData: SignupRequest!
    
    init(signupData: SignupRequest){
        super.init(nibName: nil, bundle: nil)
        self.signupData = signupData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setConstraints()
        addCustomNavigationBar(titleText: "가입하기", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        addProgressBar(currentStep: 4, totalSteps: 7)
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
    func didTapPlaceSelectButton(_ view: SignupDetailView) {
        let nextVC = MatchingApplyPlaceSearchViewController(isSignUp: true)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func shouldCheckNickname(_ textfield: UITextField) {
        if let nickname = textfield.text, nickname.count <= 6 {
            Task {
                try await checkNickname(nickname: nickname)
            }
        }
    }
    
    func didTapNextButton(_ view: SignupDetailView) {
        if isNicknamechecked {
            let detailData = view.getSignupDetailData()
            signupData.name = detailData.name
            signupData.nickname = detailData.nickname
            signupData.phone = detailData.phone
            signupData.birthDate = detailData.birthDate
            signupData.gender = detailData.gender
            let nextVC = SignupProfileImageViewController(signupData: signupData)
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
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

extension SignupDetailViewController {
    private func checkNickname(nickname: String) async throws {
        showLoading()
        defer { hideLoading() }
        do {
            try await service.checkNickname(nickname: nickname)
            signupDetailView.updateNicknameState(isVaild: true, nickname: nickname)
        }catch {
            signupDetailView.updateNicknameState(isVaild: false, nickname: nickname)
            return
        }
    }
}
