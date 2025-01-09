import UIKit
import SnapKit

class OwnerInfoView: UIView {
    
    // MARK: - UI Components
    private let titleLabel = SmallTitleLabel(text: "반려인 정보", textColor: .gray600)
    
    private let profileImageView = UIImage.createImageView(
        named: "profileExample.png",
        cornerRadius: 41
    )
    
    private let nameLabel = UpperTitleLabel(text: "", textColor: .gray600)
    private let infoLabel = SmallMainParagraphLabel(text: "", textColor: .gray600)
    private let starIcon = UIImage.createImageView(named: "starIcon.png")
    
    private let ratingLabel = SmallMainHighlightParagraphLabel(text: "", textColor: .mainBlue)
    
    private let locationIcon = UIImage.createImageView(named: "locationIconBlue.png")
    
    private let locationLabel = SmallMainHighlightParagraphLabel(text: "", textColor: .mainBlue)
    
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
            titleLabel, profileImageView, nameLabel, infoLabel, starIcon, ratingLabel, locationIcon, locationLabel
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
        
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.leading.equalTo(nameLabel.snp.trailing).offset(24)
        }
        
        starIcon.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(16)
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
