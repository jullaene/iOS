//
//  SignupProfileImageView.swift
//  walkmong
//
//  Created by 황채웅 on 1/8/25.
//

import UIKit
import PhotosUI

protocol SignupProfileImageViewDelegate: AnyObject {
    func didTapNextButton(with image: UIImage)
}

final class SignupProfileImageView: UIView {
    
    private let profileImageLabel = MiddleTitleLabel(text: "내 프로필 사진을 등록해주세요.")

    private let profileImageView: UIButton = {
        let button = UIButton()
        button.setImage(.profileImageNil, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.cornerRadius = 107.5
        return button
    }()
    
    private let profileImageIconButton: UIButton = {
        let button = UIButton()
        button.setImage(.profileImageIcon, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 17.5
        return button
    }()
    
    private let nextButton = NextButton(text: "가입하기")
    
    private var configuration = PHPickerConfiguration()
    
    private var picker: PHPickerViewController?
    
    weak var delegate: SignupProfileImageViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setConstraints()
        setButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        addSubviews(profileImageLabel, profileImageView, profileImageIconButton, nextButton)
    }
    
    private func setConstraints() {
        profileImageLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(24)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageLabel.snp.bottom).offset(63)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(215)
        }
        
        profileImageIconButton.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.trailing.equalTo(profileImageView.snp.trailing).offset(-20)
            make.width.height.equalTo(35)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(58)
        }
    }
    
    private func setButtonAction() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        profileImageView.addTarget(self, action: #selector(setPHPicker), for: .touchUpInside)
        profileImageIconButton.addTarget(self, action: #selector(setPHPicker), for: .touchUpInside)
    }
    
    @objc private func nextButtonTapped() {
        if let image = self.profileImageView.imageView?.image {
            delegate?.didTapNextButton(with: image)
        }
    }
    
    @objc private func setPHPicker() {
        configuration.filter = .any(of: [.images])
        configuration.selectionLimit = 1
        picker = PHPickerViewController(configuration: configuration)
        picker?.delegate = self
        if let vc = self.getViewController() {
            vc.present(picker!, animated: true)
        }
    }
    
}

extension SignupProfileImageView: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.profileImageView.setImage(image as? UIImage, for: .normal)
                    self.nextButton.setButtonState(isEnabled: true)
                    return
                }
            }
        } else {
            if let vc = self.getViewController() {
                CustomAlertViewController
                    .CustomAlertBuilder(viewController: vc)
                    .setTitleState(.useTitleOnly)
                    .setTitleText("이미지 불러오기 실패")
                    .setButtonState(.singleButton)
                    .setSingleButtonTitle("돌아가기")
                    .showAlertView()
            }
        }
        self.profileImageView.setImage(.profileImageNil, for: .normal)
        self.nextButton.setButtonState(isEnabled: false)
    }
    
}
