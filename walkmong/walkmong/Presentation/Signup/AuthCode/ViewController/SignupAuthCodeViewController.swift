//
//  SignupAuthCodeViewController.swift
//  walkmong
//
//  Created by 황채웅 on 12/31/24.
//

import UIKit

class SignupAuthCodeViewController: UIViewController {
    
    private let signupAuthCodeView = SignupAuthCodeView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setConstraints()
        addCustomNavigationBar(titleText: "가입하기", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        addProgressBar(currentStep: 2, totalSteps: 7)
        dismissKeyboardOnTap()
    }
    
    private func addSubview() {
        signupAuthCodeView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(156)
        }
    }
    
    private func setConstraints() {
        
    }
    
}
