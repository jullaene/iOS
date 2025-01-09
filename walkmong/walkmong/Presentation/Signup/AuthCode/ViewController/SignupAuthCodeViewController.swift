//
//  SignupAuthCodeViewController.swift
//  walkmong
//
//  Created by 황채웅 on 12/31/24.
//

import UIKit

final class SignupAuthCodeViewController: UIViewController {
    
    private lazy var signupAuthCodeView = SignupAuthCodeView(email: signupData.email)
    
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
        addProgressBar(currentStep: 2, totalSteps: 7)
        dismissKeyboardOnTap()
        signupAuthCodeView.delegate = self
        Task {
            await verifyEmail(email: signupData.email)
        }
    }
    
    private func addSubview() {
        view.addSubview(signupAuthCodeView)
    }
    
    private func setConstraints() {
        signupAuthCodeView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(156)
        }
    }
    
}

extension SignupAuthCodeViewController: SignupAuthCodeViewDelegate {
    func didEnterCode(_ code: String) async {
        await checkEmailAuthCode(email: signupData.email, code: code)
    }
    private func checkEmailAuthCode(email: String, code: String) async {
        showLoading()
        defer { hideLoading() }
        do {
            try await service.checkEmailAuthCode(email: email, code: code)
            print(code)
            let nextVC = SignupPasswordViewController(signupData: signupData)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }catch {
            hideLoading()
            CustomAlertViewController.CustomAlertBuilder(viewController: self)
                .setButtonState(.singleButton)
                .setTitleState(.useTitleAndSubTitle)
                .setSingleButtonTitle("돌아가기")
                .setTitleText("인증 실패")
                .setSubTitleText("인증 코드를 확인해주세요.")
                .showAlertView()
            return
        }
    }
    
    private func verifyEmail(email: String) async {
        showLoading()
        defer { hideLoading() }
        do {
            try await service.verifyEmail(email: email)
        }catch {
            hideLoading()
            CustomAlertViewController.CustomAlertBuilder(viewController: self)
                .setButtonState(.singleButton)
                .setTitleState(.useTitleAndSubTitle)
                .setSingleButtonTitle("돌아가기")
                .setTitleText("인증코드 발송 실패")
                .setSubTitleText("인증코드 발송에 실패했습니다.")
                .setSingleButtonAction({
                    self.navigationController?.popViewController(animated: true)
                })
                .showAlertView()
        }
    }
}
