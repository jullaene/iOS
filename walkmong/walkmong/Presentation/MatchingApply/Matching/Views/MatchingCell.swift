import UIKit
import SnapKit
import Kingfisher

class MatchingCell: UICollectionViewCell {
    
    // MARK: - Properties
    var matchingData: BoardList?
    
    // MARK: - UI Components
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    private let topFrame = UIView()

    internal let dateLabel = SmallTitleLabel(text: "")

    private let matchingStatusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14.5
        return view
    }()
    private let matchingStatusLabel = CaptionLabel(text: "", textColor: .gray400)
    
    private let bottomFrame = UIView()
    private let puppyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let contentFrame = UIView()
    private let dogInfoFrame = UIView()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.mainBlack
        label.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        return label
    }()
    private let genderIcon: UIImageView = UIImageView()
    private let sizeLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textColor = .mainGreen
        label.backgroundColor = .paleGreen
        label.layer.cornerRadius = 14
        label.clipsToBounds = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.padding = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
        return label
    }()
    private let postContentLabel: SmallMainParagraphLabel = {
        let label = SmallMainParagraphLabel(text: "", textColor: .gray500)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        return label
    }()
    
    private let locationTimeFrame = UIView()
    private let locationIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "locationIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let locationTimeLabel = CaptionLabel(text: "", textColor: .gray500)
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        setupMainView()
        setupTopFrame()
        setupBottomFrame()
    }
    
    private func setupMainView() {
        addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupTopFrame() {
        mainView.addSubview(topFrame)
        topFrame.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(29)
        }
        
        topFrame.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.height.equalTo(28)
        }
        
        topFrame.addSubview(matchingStatusView)
        matchingStatusView.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.equalTo(63)
            make.height.equalTo(29)
        }
        
        matchingStatusView.addSubview(matchingStatusLabel)
        matchingStatusLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupBottomFrame() {
        mainView.addSubview(bottomFrame)
        bottomFrame.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(topFrame.snp.bottom).offset(16)
        }
        
        bottomFrame.addSubview(puppyImageView)
        puppyImageView.snp.makeConstraints { make in
            make.width.equalTo(puppyImageView.snp.height)
            make.top.leading.bottom.equalToSuperview()
        }
        
        bottomFrame.addSubview(contentFrame)
        contentFrame.snp.makeConstraints { make in
            make.leading.equalTo(puppyImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        setupDogInfoFrame()
        setupPostContent()
        setupLocationTimeFrame()
    }
    
    private func setupDogInfoFrame() {
        contentFrame.addSubview(dogInfoFrame)
        dogInfoFrame.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(25)
        }
        
        dogInfoFrame.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(puppyImageView)
            make.leading.equalToSuperview()
            make.height.equalTo(25)
        }
        
        dogInfoFrame.addSubview(genderIcon)
        genderIcon.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(5)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(16)
        }
        
        dogInfoFrame.addSubview(sizeLabel)
        sizeLabel.snp.makeConstraints { make in
            make.leading.equalTo(genderIcon.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupPostContent() {
        contentFrame.addSubview(postContentLabel)
        postContentLabel.lineBreakStrategy = .pushOut
        postContentLabel.lineBreakMode = .byTruncatingTail
        postContentLabel.numberOfLines = 2
        postContentLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupLocationTimeFrame() {
        contentFrame.addSubview(locationTimeFrame)
        locationTimeFrame.snp.makeConstraints { make in
            make.top.equalTo(postContentLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(21)
        }
        
        locationTimeFrame.addSubview(locationIcon)
        locationIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(locationTimeFrame)
            make.width.size.equalTo(14)
        }
        
        contentFrame.addSubview(locationTimeLabel)
        locationTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(locationIcon.snp.trailing).offset(4)
            make.centerY.equalTo(locationIcon)
        }
    }
    
    // MARK: - Configuration
    func configure(with data: BoardList, selectedDate: String) {

        matchingData = data
        configureDateLabel(selectedDate: selectedDate, startTime: data.startTime, endTime: data.endTime)
        configureMatchingStatus(for: data.matchingYn)
        configurePuppyImage(with: data.safeDogProfile)
        
        nameLabel.text = data.dogName
        sizeLabel.text = data.dogSize.localizedDogSize()
        postContentLabel.text = data.content
        locationTimeLabel.text = "\(data.dongAddress) \(data.formattedDistance) · \(data.readableCreatedAt)"
        
        genderIcon.image = genderIconImage(for: data.dogGender)
    }
    
    func setCustomViewAppearance(
        hideSizeLabel: Bool,
        backgroundColor: UIColor,
        showOnlyDongAddress: Bool = false
    ) {
        sizeLabel.isHidden = hideSizeLabel
        mainView.backgroundColor = backgroundColor
        
        if showOnlyDongAddress, let data = matchingData {
            locationTimeLabel.text = data.dongAddress
        }
    }
    
    func configureDateLabel(selectedDate: String, startTime: String, endTime: String) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")

        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: selectedDate) else {
            dateLabel.text = "날짜 변환 오류"
            return
        }

        formatter.dateFormat = "MM.dd (E)"
        let formattedDate = formatter.string(from: date)

        formatter.dateFormat = "HH:mm"
        guard let startTimeDate = formatter.date(from: startTime),
              let endTimeDate = formatter.date(from: endTime) else {
            dateLabel.text = "시간 변환 오류"
            return
        }

        let formattedStartTime = formatter.string(from: startTimeDate)
        let formattedEndTime = formatter.string(from: endTimeDate)

        // 결과 출력
        dateLabel.text = "\(formattedDate) \(formattedStartTime) ~ \(formattedEndTime)"
    }
    
    private func configureMatchingStatus(for status: String) {
        let isMatched = (status == "Y")
        matchingStatusView.backgroundColor = isMatched ? .mainBlue : .lightBlue
        matchingStatusLabel.textColor = isMatched ? .white : .mainBlue
        matchingStatusLabel.text = isMatched ? "매칭확정" : "매칭중"
    }
    
    private func configurePuppyImage(with urlString: String) {
        if let url = URL(string: urlString) {
            puppyImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImage"))
        } else {
            puppyImageView.image = UIImage(named: "defaultDogImage")
        }
    }
    
    private func genderIconImage(for gender: String) -> UIImage? {
        switch gender {
        case "FEMALE": return UIImage(named: "femaleIcon")
        case "MALE": return UIImage(named: "maleIcon")
        default: return nil
        }
    }
}

class PaddingLabel: UILabel {
    var padding = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let width = size.width + padding.left + padding.right
        let height = size.height + padding.top + padding.bottom
        return CGSize(width: width, height: height)
    }
}
