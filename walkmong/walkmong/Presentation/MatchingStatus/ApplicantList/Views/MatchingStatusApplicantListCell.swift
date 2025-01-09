//
//  MatchingStatusApplicantListCell.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit
import SnapKit

final class MatchingStatusApplicantListCell: UIView {
    
    // MARK: - UI Components
    
    private let profileImageView = UIImage.createImageView(
        named: "profileExample",
        cornerRadius: 41
    )
    
    private let nameLabel = UpperTitleLabel(text: "", textColor: .gray600)
    private let infoLabel = SmallMainParagraphLabel(text: "", textColor: .gray600)
    private let profileButton = UIButton()
    private let starIcon = UIImage.createImageView(named: "starIcon.png")
    
    private let ratingLabel = SmallMainHighlightParagraphLabel(text: "", textColor: .mainBlue)
    
    private let locationIcon = UIImage.createImageView(named: "locationIcon.png")
    
    private let locationLabel = SmallMainHighlightParagraphLabel(text: "", textColor: .gray400)
        
    private let walkTalkButton: UIView = {
        let view = UIView.createRoundedView(backgroundColor: UIColor.gray100, cornerRadius: 15)
        
        let label = UILabel()
        label.text = "워크톡"
        label.textColor = UIColor.gray400
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        
        let icon = UIImageView()
        icon.image = UIImage(named: "messageIcon")
        icon.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [label, icon])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return view
    }()
    
    private let viewApplicationButton = UIButton.createStyledButton(type: .large, style: .dark, title: "지원서 보기")
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .gray100
        layer.cornerRadius = 20
        
        addSubviews(profileImageView, nameLabel, infoLabel, profileButton, starIcon, ratingLabel, locationIcon, locationLabel, walkTalkButton, viewApplicationButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.height.equalTo(82)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.leading.equalTo(nameLabel.snp.trailing).offset(24)
        }
        
        profileButton.setTitle("프로필", for: .normal)
        profileButton.backgroundColor = .mainBlue
        profileButton.layer.cornerRadius = 5
        profileButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        profileButton.setTitleColor(.white, for: .normal)
        profileButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(profileImageView)
            make.width.equalTo(54)
            make.height.equalTo(25)
        }
        
        starIcon.snp.makeConstraints { make in
            make.centerY.equalTo(ratingLabel)
            make.leading.equalTo(nameLabel.snp.leading)
            make.width.height.equalTo(17)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(starIcon.snp.trailing).offset(4)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        
        locationIcon.snp.makeConstraints { make in
            make.centerX.equalTo(starIcon.snp.centerX)
            make.centerY.equalTo(locationLabel)
            make.height.equalTo(14)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(8)
            make.leading.equalTo(ratingLabel.snp.leading)
        }
        
        walkTalkButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(24)
            make.leading.equalToSuperview()
            make.width.equalTo(83)
            make.height.equalTo(53)
            make.bottom.equalToSuperview()
        }
        
        viewApplicationButton.snp.makeConstraints { make in
            make.centerY.equalTo(walkTalkButton)
            make.leading.equalTo(walkTalkButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.height.equalTo(walkTalkButton)
        }
    }
    
    // MARK: - Public Method
    func updateOwnerInfo(
        ownerProfile: String?,
        ownerName: String,
        ownerAge: Int,
        ownerGender: String,
        ownerRate: Double,
        dongAddress: String,
        distance: Double
    ) {
        profileImageView.setImage(from: ownerProfile, placeholder: "profileExample")
        nameLabel.text = ownerName
        let genderText = ownerGender == "FEMALE" ? "여성" : "남성"
        infoLabel.text = "\(ownerAge)살 · \(genderText)"
        ratingLabel.text = String(format: "%.1f", ownerRate)
        locationLabel.text = "\(dongAddress) \(formatDistance(distance))"
    }
    
    // MARK: - Helper Methods
    private static func createLabel(text: String, textColor: UIColor, font: UIFont?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = font
        return label
    }
    
    private func formatDistance(_ distance: Double) -> String {
        if distance < 1000 {
            return "\(Int(distance))m"
        } else {
            let distanceInKm = distance / 1000
            return distanceInKm == floor(distanceInKm) ? "\(Int(distanceInKm))km" : String(format: "%.1fkm", distanceInKm)
        }
    }
}
