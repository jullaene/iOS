//
//  SignupProfileImageViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/8/25.
//

import UIKit

class SignupProfileImageViewController: UIViewController {
    
    private let signupProfileImageView = SignupProfileImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setConstraints()
        addCustomNavigationBar(titleText: "가입하기", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        addProgressBar(currentStep: 4, totalSteps: 7)
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
