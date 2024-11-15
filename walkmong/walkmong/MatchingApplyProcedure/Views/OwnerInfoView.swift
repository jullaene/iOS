import UIKit
import SnapKit
import Kingfisher

class OwnerInfoView: UIView {
    
    // MARK: - UI Components
    private let titleLabel = OwnerInfoView.createLabel(
        text: "반려인 정보",
        textColor: .gray600,
        font: UIFont(name: "Pretendard-Bold", size: 20)
    )
    
    private let profileImageView = OwnerInfoView.createImageView(
        imageName: "profileExample.png", cornerRadius: 41
    )
    
    private let nameLabel = OwnerInfoView.createLabel(
        text: "",
        textColor: .gray600,
        font: UIFont(name: "Pretendard-SemiBold", size: 20)
    )
    
    private let ageLabel = OwnerInfoView.createLabel(
        text: "",
        textColor: .gray600,
        font: UIFont(name: "Pretendard-Regular", size: 14)
    )
    
    private let separatorLabel = OwnerInfoView.createLabel(
        text: "·",
        textColor: .gray600,
        font: UIFont(name: "Pretendard-Regular", size: 14)
    )
    
    private let genderLabel = OwnerInfoView.createLabel(
        text: "",
        textColor: .gray600,
        font: UIFont(name: "Pretendard-Regular", size: 14)
    )
    
    private let starIcon = OwnerInfoView.createImageView(
        imageName: "starIcon.svg", tintColor: UIColor.mainBlue
    )
    
    private let ratingLabel = OwnerInfoView.createLabel(
        text: "",
        textColor: .mainBlue,
        font: UIFont(name: "Pretendard-SemiBold", size: 14)
    )
    
    private let locationIcon = OwnerInfoView.createImageView(
        imageName: "locationIconBlue.svg"
    )
    
    private let locationLabel = OwnerInfoView.createLabel(
        text: "",
        textColor: .mainBlue,
        font: UIFont(name: "Pretendard-SemiBold", size: 14)
    )
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .gray100
        layer.cornerRadius = 20
        
        let subviews = [
            titleLabel, profileImageView, nameLabel, ageLabel, separatorLabel,
            genderLabel, starIcon, ratingLabel, locationIcon, locationLabel
        ]
        subviews.forEach { addSubview($0) }
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(82)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(8)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
        
        separatorLabel.snp.makeConstraints { make in
            make.leading.equalTo(ageLabel.snp.trailing).offset(4)
            make.centerY.equalTo(ageLabel.snp.centerY)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.leading.equalTo(separatorLabel.snp.trailing).offset(4)
            make.centerY.equalTo(separatorLabel.snp.centerY)
        }
        
        starIcon.snp.makeConstraints { make in
            make.top.equalTo(ageLabel.snp.bottom).offset(16)
            make.leading.equalTo(nameLabel.snp.leading)
            make.width.height.equalTo(17)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(starIcon.snp.trailing).offset(8)
            make.centerY.equalTo(starIcon.snp.centerY)
        }
        
        locationIcon.snp.makeConstraints { make in
            make.centerX.equalTo(starIcon.snp.centerX)
            make.top.equalTo(starIcon.snp.bottom).offset(16)
            make.height.equalTo(14)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationIcon.snp.centerY)
            make.leading.equalTo(ratingLabel.snp.leading)
            make.bottom.equalToSuperview().offset(-20)
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
        // 프로필 이미지 처리
        if let profileUrlString = ownerProfile?.trimmingCharacters(in: .whitespacesAndNewlines),
           let profileUrl = URL(string: profileUrlString),
           profileUrl.scheme == "http" || profileUrl.scheme == "https" {
            // 유효한 URL인 경우 Kingfisher로 로드
            profileImageView.kf.setImage(with: profileUrl, placeholder: UIImage(named: "profileExample"))
        } else {
            // URL이 유효하지 않은 경우 기본 이미지 설정
            profileImageView.image = UIImage(named: "profileExample")
        }
        
        // 이름
        nameLabel.text = ownerName
        
        // 나이
        let ageGroup = (ownerAge / 10) * 10
        let ageCategory: String
        switch ownerAge % 10 {
        case 0...2:
            ageCategory = "초반"
        case 3...6:
            ageCategory = "중반"
        case 7...9:
            ageCategory = "후반"
        default:
            ageCategory = ""
        }
        ageLabel.text = "\(ageGroup)대 \(ageCategory)"
        
        // 성별
        genderLabel.text = ownerGender == "FEMALE" ? "여성" : "남성"
        
        // 평점
        ratingLabel.text = String(format: "%.1f", ownerRate)
        
        // 위치
        if distance >= 1 {
            locationLabel.text = String(format: "%.1fkm", distance).replacingOccurrences(of: ".0km", with: "km")
        } else {
            locationLabel.text = "\(Int(distance * 1000))m"
        }
        locationLabel.text = "\(dongAddress) \(locationLabel.text ?? "")"
    }
    
    // MARK: - Helper Methods
    private static func createLabel(text: String, textColor: UIColor, font: UIFont?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = font
        return label
    }
    
    private static func createImageView(imageName: String, cornerRadius: CGFloat = 0, tintColor: UIColor? = nil) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        if let tintColor = tintColor {
            imageView.tintColor = tintColor
        }
        if cornerRadius > 0 {
            imageView.layer.cornerRadius = cornerRadius
            imageView.clipsToBounds = true
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}
