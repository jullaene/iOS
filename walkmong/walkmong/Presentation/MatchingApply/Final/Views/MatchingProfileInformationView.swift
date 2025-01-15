//
//  MatchingProfileInformationView.swift
//  walkmong
//
//  Created by 황채웅 on 11/14/24.
//

import UIKit

class BaseProfileInformationView: UIView {
    
    internal let profileTitleLabel = SmallTitleLabel(text: "산책자 정보")
    
    internal let profileImageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = .matchingApplyProcedureIcon
        imageview.contentMode = .scaleAspectFill
        imageview.layer.cornerRadius = 41
        imageview.clipsToBounds = true
        return imageview
    }()
        
    internal let nameLabel = SmallTitleLabel(text: "봄별이")
    
    internal let profileInformationLabel = SmallMainParagraphLabel(text: "소형견 · 말티즈 · 4kg")
    
    internal let locationImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = .meetingPlace
        imageview.contentMode = .center
        return imageview
    }()
    
    internal let locationLabel = SmallMainHighlightParagraphLabel(text: "장소", textColor: .gray400)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubView(){
        self.addSubviews(profileTitleLabel, profileImageview, nameLabel, profileInformationLabel, locationImageView, locationLabel)
    }
    
    private func setConstraints(){
        profileTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(24)
        }
        profileImageview.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(profileTitleLabel.snp.bottom).offset(16)
            make.width.height.equalTo(82)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageview.snp.trailing).offset(12)
            make.top.equalTo(profileImageview.snp.top)
        }
        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageview.snp.trailing).offset(32)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        locationImageView.snp.makeConstraints { make in
            make.centerY.equalTo(locationLabel.snp.centerY)
            make.leading.equalTo(nameLabel.snp.leading)
            make.width.height.equalTo(14)
        }
        profileInformationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.leading.equalTo(nameLabel.snp.trailing).offset(44)
        }
    }
    func configure(name: String, informationText: String, location: String, profileImage: String) {
        profileImageview.kf.setImage(with: URL(string: profileImage))
        nameLabel.text = name
        profileInformationLabel.text = informationText
        locationLabel.text = location
    }
}


class DogProfileInformationView: BaseProfileInformationView{
    
    private let genderIcon: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(genderIcon)
        genderIcon.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.leading.equalTo(nameLabel.snp.trailing).offset(4)
            make.width.equalTo(9)
            make.height.equalTo(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(isFemale: Bool, name: String, informationText: String, location: String, profileImage: String) {
        profileTitleLabel.text = "반려견 정보"
        genderIcon.image = isFemale ? .femaleIcon : .maleIcon
        profileImageview.kf.setImage(with: URL(string: profileImage))
        nameLabel.text = name
        profileInformationLabel.text = informationText
        locationLabel.text = location
    }
}

extension DogProfileInformationView {
    func updateWithDogInfo(_ dogInfo: DogInfo, location: String?) {
        nameLabel.text = dogInfo.dogName
        profileInformationLabel.text = dogInfo.profileInformationText
        locationLabel.text = location ?? "위치 정보 없음"

        if let encodedURL = dogInfo.dogProfile.removingPercentEncoding,
           let url = URL(string: encodedURL) {
            profileImageview.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholderImage"),
                options: [.cacheOriginalImage, .transition(.fade(0.2))]
            )
        } else {
            profileImageview.image = UIImage(named: "placeholderImage")
        }
    }
}
