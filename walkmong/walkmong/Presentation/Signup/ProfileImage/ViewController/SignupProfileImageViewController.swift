//
//  SignupProfileImageViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/8/25.
//

import UIKit

final class SignupProfileImageViewController: UIViewController {
    
    private let signupProfileImageView = SignupProfileImageView()
    private let service = AuthService()
    private var signupData: SignupRequest!
    
    init(signupData: SignupRequest) {
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
        addProgressBar(currentStep: 5, totalSteps: 7)
        signupProfileImageView.delegate = self
    }
    
    private func addSubview() {
        view.addSubview(signupProfileImageView)
    }
    
    private func setConstraints() {
        signupProfileImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(156)
            make.bottom.equalToSuperview()
        }
    }

}

extension SignupProfileImageViewController: SignupProfileImageViewDelegate {
    func didTapNextButton(with image: UIImage) {
        signupData.profile = image
        showLoading()
        defer { hideLoading() }
        Task {
            do {
                try await service.signup(request: signupData)
            } catch {
                hideLoading()
                CustomAlertViewController.CustomAlertBuilder(viewController: self)
                    .setButtonState(.singleButton)
                    .setTitleState(.useTitleAndSubTitle)
                    .setSingleButtonTitle("돌아가기")
                    .setTitleText("회원가입 실패")
                    .setSubTitleText("다시 시도해주세요.")
                    .showAlertView()
            }
        }
    }
}
