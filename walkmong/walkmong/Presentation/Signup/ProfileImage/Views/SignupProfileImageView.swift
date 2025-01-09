//
//  SignupProfileImageView.swift
//  walkmong
//
//  Created by 황채웅 on 1/8/25.
//

import UIKit
import PhotosUI

protocol SignupProfileImageViewDelegate: AnyObject {
    func didTapNextButton(with Image: UIImage)
}

class SignupProfileImageView: UIView {
    
    private let profileImageLabel = MiddleTitleLabel(text: "내 프로필 사진을 등록해주세요.")

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .profileImageNil
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 107.5
        return imageView
    }()
    
    private let profileImageIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .profileImageIcon
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 17.5
        return imageView
    }()
    
    private let nextButton = NextButton(text: "다음으로")
    
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
        addSubviews(profileImageLabel, profileImageView, profileImageIconView, nextButton)
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
        
        profileImageIconView.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.trailing.equalTo(profileImageView.snp.trailing).offset(20)
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
    }
    
    @objc private func nextButtonTapped() {
        if let image = self.profileImageView.image {
            delegate?.didTapNextButton(with: image)
        }
    }
    
    private func setPHPicker() {
        configuration.filter = .any(of: [.images])
        configuration.selectionLimit = 1
        picker = PHPickerViewController(configuration: configuration)
        picker?.delegate = self
        if let vc = self.getViewController() {
            picker?.present(vc, animated: true)
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
                    self.profileImageView.image = image as? UIImage
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
    }
    
}
