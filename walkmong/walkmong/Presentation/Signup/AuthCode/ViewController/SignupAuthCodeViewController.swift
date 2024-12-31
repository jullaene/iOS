//
//  SignupAuthCodeViewController.swift
//  walkmong
//
//  Created by 황채웅 on 12/31/24.
//

import UIKit

final class SignupAuthCodeViewController: UIViewController {
    
    private let signupAuthCodeView = SignupAuthCodeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setConstraints()
        addCustomNavigationBar(titleText: "가입하기", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        addProgressBar(currentStep: 2, totalSteps: 7)
        dismissKeyboardOnTap()
        signupAuthCodeView.delegate = self
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
    func didEnterCode(_ code: String) {
        //TODO: 코드 인증 API 호출
        print(code)
        let nextVC = SignupPasswordViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
