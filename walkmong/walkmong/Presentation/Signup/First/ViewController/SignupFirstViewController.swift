//
//  SignupFirstViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/9/25.
//

import UIKit

class SignupFirstViewController: UIViewController {
    
    private let signupFirstView = SignupFirstView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBlue
        view.addSubview(signupFirstView)
        signupFirstView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        signupFirstView.delegate = self
    }
}

extension SignupFirstViewController: SignupFirstViewDelegate {
    func didTapEmailSignupButton() {
        let nextVC = SignupEmailViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func didTapLoginButton() {
        let nextVC = LoginViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
