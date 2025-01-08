//
//  SignupProfileImageView.swift
//  walkmong
//
//  Created by 황채웅 on 1/8/25.
//

import UIKit

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setConstraints()
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
    
}
