//
//  SignupEmailViewController.swift
//  walkmong
//
//  Created by 황채웅 on 12/31/24.
//

import UIKit

final class SignupEmailViewController: UIViewController {
    
    private let signupEmailView = SignupEmailView()
    
    private let service = AuthService()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setConstraints()
        addCustomNavigationBar(titleText: "가입하기", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        addProgressBar(currentStep: 1, totalSteps: 7)
        dismissKeyboardOnTap()
        signupEmailView.delegate = self
    }
    
    private func addSubview() {
        view.addSubview(signupEmailView)
    }
    
    private func setConstraints() {
        signupEmailView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(156)
        }
    }

}

extension SignupEmailViewController: SignupEmailViewDelegate {
    func didTapEmailCheckButton(with email: String) async -> Bool {
        showLoading()
        defer { hideLoading() }
        do {
            let response = try await service.checkEmail(email: email)
            print(response)
            return response.statusCode == 200
        } catch {
            return false
        }
    }
    
    func didTapNextButton(with email: String) async {
        let nextVC = SignupAuthCodeViewController(email: email)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
