import UIKit
import SnapKit
import Kingfisher

protocol MatchingCellDelegate: AnyObject {
    func didSelectMatchingCell(data: MatchingData)
}

class MatchingCell: UIView {
    
    // MARK: - Properties
    weak var delegate: MatchingCellDelegate?
    var matchingData: MatchingData?
    
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
    private let sizeLabel = SmallMainHighlightParagraphLabel(text: "", textColor: .mainGreen)
    private let postContentLabel = SmallMainParagraphLabel(text: "", textColor: .gray500)
    
    private let locationTimeFrame = UIView()
    private let locationIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "locationIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let locationLabel = CaptionLabel(text: "", textColor: .gray500)
    private let distanceLabel = CaptionLabel(text: "", textColor: .gray500)
    private let timeLabel = CaptionLabel(text: "", textColor: .gray500)
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupTapGesture()
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
            make.height.equalTo(109)
        }
        
        bottomFrame.addSubview(puppyImageView)
        puppyImageView.snp.makeConstraints { make in
            make.width.height.equalTo(112)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
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
            make.leading.centerY.equalToSuperview()
        }
        
        dogInfoFrame.addSubview(genderIcon)
        genderIcon.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
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
            make.top.equalTo(dogInfoFrame.snp.bottom).offset(8)
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
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
        
        locationTimeFrame.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(locationIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        locationTimeFrame.addSubview(distanceLabel)
        distanceLabel.snp.makeConstraints { make in
            make.leading.equalTo(locationLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        locationTimeFrame.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(distanceLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Configuration
    func configure(with data: MatchingData) {
        matchingData = data
        configureDateLabel(selectedDate: data.date, startTime: data.startTime, endTime: data.endTime)
        configureMatchingStatus(for: data.matchingYn)
        configurePuppyImage(with: data.safeDogProfile)
        
        nameLabel.text = data.dogName
        sizeLabel.text = data.translatedDogSize
        postContentLabel.text = data.content
        locationLabel.text = data.dongAddress
        distanceLabel.text = data.formattedDistance
        timeLabel.text = data.readableCreatedAt
        
        genderIcon.image = genderIconImage(for: data.dogGender)
    }
    
    func setCustomViewAppearance(hideSizeLabel: Bool, hideDistanceLabel: Bool, hideTimeLabel: Bool, backgroundColor: UIColor) {
        sizeLabel.isHidden = hideSizeLabel
        distanceLabel.isHidden = hideDistanceLabel
        timeLabel.isHidden = hideTimeLabel
        mainView.backgroundColor = backgroundColor
    }
    
    func configureDateLabel(selectedDate: String, startTime: String, endTime: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        
        let components = selectedDate.split(separator: ".")
        guard components.count >= 1, let day = Int(components[0].trimmingCharacters(in: .whitespaces)) else {
            dateLabel.text = "날짜 변환 오류"
            return
        }
        
        var dateComponents = DateComponents()
        dateComponents.year = currentYear
        dateComponents.month = currentMonth
        dateComponents.day = day
        
        guard let datePart = Calendar.current.date(from: dateComponents) else {
            print("Failed to create date from components: \(dateComponents)")
            dateLabel.text = "날짜 변환 오류"
            return
        }
        
        dateFormatter.dateFormat = "MM. dd (EEE)"
        let formattedDate = dateFormatter.string(from: datePart)
        
        dateFormatter.dateFormat = "HH:mm"
        guard let startTimeDate = dateFormatter.date(from: startTime),
              let endTimeDate = dateFormatter.date(from: endTime) else {
            print("Failed to parse startTime or endTime: \(startTime), \(endTime)")
            dateLabel.text = "시간 변환 오류"
            return
        }
        
        let formattedStartTime = dateFormatter.string(from: startTimeDate)
        let formattedEndTime = dateFormatter.string(from: endTimeDate)
        
        dateLabel.text = "\(formattedDate) \(formattedStartTime) ~ \(formattedEndTime)"
    }
    
    private func configureMatchingStatus(for status: String) {
        let isMatched = (status == "Y")
        matchingStatusView.backgroundColor = isMatched ? .gray100 : .mainGreen
        matchingStatusLabel.textColor = isMatched ? .gray400 : .white
        matchingStatusLabel.text = isMatched ? "매칭확정" : "매칭중"
    }
    
    private func configurePuppyImage(with urlString: String) {
        if let url = URL(string: urlString) {
            puppyImageView.kf.setImage(with: url)
        } else {
            puppyImageView.image = nil
        }
    }
    
    private func genderIconImage(for gender: String) -> UIImage? {
        switch gender {
        case "FEMALE": return UIImage(named: "femaleIcon")
        case "MALE": return UIImage(named: "maleIcon")
        default: return nil
        }
    }
    
    // MARK: - Actions
    @objc private func handleTap() {
        if let data = matchingData {
            delegate?.didSelectMatchingCell(data: data)
        }
    }
}
