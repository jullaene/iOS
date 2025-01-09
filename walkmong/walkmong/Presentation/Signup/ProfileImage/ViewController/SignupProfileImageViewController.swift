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
    func didTapNextButton(with Image: UIImage) {
        //TODO: 이미지 데이터 넘김
    }
}
