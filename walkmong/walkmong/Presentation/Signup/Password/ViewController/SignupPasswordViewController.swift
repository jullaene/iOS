//
//  SignupPasswordViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/1/25.
//

import UIKit

final class SignupPasswordViewController: UIViewController {
    
    private let signupPasswordView = SignupPasswordView()
    private var email: String?
    private var password: String?
    
    init(email: String?) {
        super.init(nibName: nil, bundle: nil)
        self.email = email
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
        addProgressBar(currentStep: 3, totalSteps: 7)
        dismissKeyboardOnTap()
        signupPasswordView.delegate = self
    }
    
    private func addSubview() {
        view.addSubview(signupPasswordView)
    }
    
    private func setConstraints() {
        signupPasswordView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(156)
        }
    }
    
}

extension SignupPasswordViewController: SignupPasswordViewDelegate {
    func didTapNextButton(password: String) {
        if let email = email {
            let nextVC = SignupDetailViewController(email: email, password: password)
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
