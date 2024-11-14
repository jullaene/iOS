import UIKit
import SnapKit

protocol MatchingCellDelegate: AnyObject {
    func didSelectMatchingCell(data: MatchingData)
}

class MatchingCell: UIView {
    
    // MARK: - Properties
    weak var delegate: MatchingCellDelegate?
    private var matchingData: MatchingData?
    
    // Main Container View
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    // Top Section (Date & Matching Status)
    private let topFrame = UIView()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.mainBlack
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        return label
    }()
    private let matchingStatusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14.5
        return view
    }()
    private let matchingStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        return label
    }()
    
    // Bottom Section
    private let bottomFrame = UIView()
    private let puppyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let contentFrame = UIView()
    
    // Dog Information
    private let dogInfoFrame = UIView()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.mainBlack
        label.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        return label
    }()
    private let genderIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let sizeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.mainGreen
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()
    
    // Post Content
    private let postContentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray500
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    // Location and Time
    private let locationTimeFrame = UIView()
    private let locationIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray500
        label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        return label
    }()
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray500
        label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        return label
    }()
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray500
        label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        return label
    }()
    
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
    
    // MARK: - View Setup
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
        
        // Date Label
        topFrame.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.height.equalTo(28)
        }
        
        // Matching Status View
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
            make.height.equalTo(106)
        }
        
        // Puppy Image
        bottomFrame.addSubview(puppyImageView)
        puppyImageView.snp.makeConstraints { make in
            make.width.height.equalTo(97)
            make.leading.centerY.equalToSuperview()
        }
        
        // Content Frame
        bottomFrame.addSubview(contentFrame)
        contentFrame.snp.makeConstraints { make in
            make.leading.equalTo(puppyImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
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
        
        // Dog Info Labels
        [nameLabel, genderIcon, sizeLabel].forEach {
            dogInfoFrame.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        
        genderIcon.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        sizeLabel.snp.makeConstraints { make in
            make.leading.equalTo(genderIcon.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupPostContent() {
        contentFrame.addSubview(postContentLabel)
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
        
        // Location and Time Labels
        [locationIcon, locationLabel, distanceLabel, timeLabel].forEach {
            locationTimeFrame.addSubview($0)
        }
        
        locationIcon.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(locationIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.leading.equalTo(locationLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(distanceLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func handleTap() {
        guard let data = matchingData else { return }
        delegate?.didSelectMatchingCell(data: data)
    }
    
    // MARK: - Configuration
    func configure(with data: MatchingData) {
        matchingData = data
        dateLabel.text = "\(data.date) \(data.startTime) ~ \(data.endTime)"
        matchingStatusLabel.text = data.matchingStatus
        
        // dogProfile을 안전하게 처리하고 기본 이미지 설정
        if let profileImageName = data.dogProfile {
            puppyImageView.image = UIImage(named: profileImageName)
        } else {
            puppyImageView.image = UIImage(named: "puppyImage01") // 기본 이미지 이름
        }
        
        nameLabel.text = data.dogName
        sizeLabel.text = data.dogSize
        postContentLabel.text = data.content
        locationLabel.text = data.dongAddress
        distanceLabel.text = data.formattedDistance
        timeLabel.text = data.createdAt
        
        // Matching Status에 따른 UI 변경
        matchingStatusLabel.text = data.matchingStatus
        if data.matchingStatus == "매칭확정" {
            matchingStatusView.backgroundColor = .gray100
            matchingStatusLabel.textColor = .gray400
            matchingStatusView.snp.remakeConstraints { make in
                make.trailing.centerY.equalToSuperview()
                make.width.equalTo(73)
                make.height.equalTo(29)
            }
        } else { // 기본 "매칭중" 상태
            matchingStatusView.backgroundColor = .mainGreen
            matchingStatusLabel.textColor = .white
            matchingStatusView.snp.remakeConstraints { make in
                make.trailing.centerY.equalToSuperview()
                make.width.equalTo(63)
                make.height.equalTo(29)
            }
        }
    }
}
