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
    private let genderIcon = UIImageView()
    
    var didTapProfileButton: (() -> Void)?
    var didTapAddPetCell: (() -> Void)?
    
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
        
        genderIcon.image = UIImage(named: "femaleIcon")
        contentView.addSubview(genderIcon)
        genderIcon.snp.makeConstraints { make in
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
        if let url = URL(string: profile.imageURL ?? "") {
            petImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            petImageView.image = UIImage(named: "placeholder")
        }
        petNameLabel.text = profile.name
        petDetailsLabel.text = profile.details

        switch profile.gender.uppercased() {
        case "FEMALE":
            genderIcon.image = UIImage(named: "femaleIcon")
        case "MALE":
            genderIcon.image = UIImage(named: "maleIcon")
        default:
            genderIcon.image = UIImage(named: "defaultIcon")
        }
        
        genderIcon.isHidden = false
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
        genderIcon.isHidden = true
    }
    
    private func setupActions() {
        profileButton.addTarget(self, action: #selector(handleProfileButtonTap), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap))
        contentView.addGestureRecognizer(tapGesture)
        contentView.isUserInteractionEnabled = true
    }

    @objc private func handleProfileButtonTap() {
        didTapProfileButton?()
    }
    
    @objc private func handleCellTap() {
        didTapAddPetCell?()
    }
}

extension PetProfileCell {
    func setSelectedStyle() {
        contentView.backgroundColor = .mainBlue
        petNameLabel.textColor = .white
        petDetailsLabel.textColor = .white
        
        if let icon = genderIcon.image?.withRenderingMode(.alwaysTemplate) {
            genderIcon.image = icon
        }
        genderIcon.tintColor = .white

        profileButton.setTitleColor(.mainBlue, for: .normal)
        profileButton.backgroundColor = .lightBlue
    }

    func setDefaultStyle() {
        contentView.backgroundColor = .gray100
        petNameLabel.textColor = .black
        petDetailsLabel.textColor = .gray

        if let icon = genderIcon.image?.withRenderingMode(.alwaysTemplate) {
            genderIcon.image = icon
        }
        genderIcon.tintColor = .black
        
        profileButton.setTitleColor(.white, for: .normal)
        profileButton.backgroundColor = .mainBlue
    }
}
