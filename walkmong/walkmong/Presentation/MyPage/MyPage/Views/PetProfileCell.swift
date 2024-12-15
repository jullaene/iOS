//
//  PetProfileCell.swift
//  walkmong
//
//  Created by 신호연 on 12/12/24.
//

import UIKit

class PetProfileCell: UICollectionViewCell {
    private let petImageView = UIImageView()
    private let petNameLabel = UpperTitleLabel(text: "")
    private let petDetailsLabel = SmallMainParagraphLabel(text: "")
    private let profileButton = UIButton()
    private let femaleIcon = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = .gray100
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        petImageView.contentMode = .scaleAspectFill
        petImageView.layer.cornerRadius = 31
        petImageView.clipsToBounds = true
        contentView.addSubview(petImageView)
        petImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 62, height: 62))
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        contentView.addSubview(petNameLabel)
        petNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(petImageView.snp.trailing).offset(16)
            make.top.equalToSuperview().offset(16)
        }
        
        femaleIcon.image = UIImage(named: "femaleIcon")
        contentView.addSubview(femaleIcon)
        femaleIcon.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.leading.equalTo(petNameLabel.snp.trailing).offset(4)
            make.centerY.equalTo(petNameLabel)
        }
        
        contentView.addSubview(petDetailsLabel)
        petDetailsLabel.snp.makeConstraints { make in
            make.leading.equalTo(petNameLabel)
            make.top.equalTo(petNameLabel.snp.bottom).offset(8)
        }
        
        profileButton.setTitle("프로필", for: .normal)
        profileButton.backgroundColor = .mainBlue
        profileButton.layer.cornerRadius = 5
        profileButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        profileButton.setTitleColor(.white, for: .normal)
        contentView.addSubview(profileButton)
        profileButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 54, height: 25))
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(petNameLabel)
        }
    }
    
    func configure(with profile: PetProfile) {
        petImageView.setImage(from: profile.imageURL, placeholder: "placeholder_image_name")
        petNameLabel.text = profile.name
        petDetailsLabel.text = profile.details
    }
    
    func configureAsAddPet() {
        contentView.backgroundColor = UIColor(red: 0.978, green: 0.978, blue: 0.978, alpha: 0.3)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray200.cgColor
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true

        let plusIcon = UIImageView()
        plusIcon.image = UIImage(named: "MyPagePlusIcon")
        plusIcon.contentMode = .scaleAspectFit
        contentView.addSubview(plusIcon)
        plusIcon.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 14, height: 14))
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }

        petNameLabel.text = "반려견 등록하기"
        petNameLabel.textColor = .gray400
        petNameLabel.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        petNameLabel.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(plusIcon.snp.bottom).offset(12)
        }

        petImageView.isHidden = true
        petDetailsLabel.isHidden = true
        profileButton.isHidden = true
        femaleIcon.isHidden = true
    }
}
