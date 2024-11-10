import UIKit
import SnapKit

class MatchingCell: UIView {
    
    // Main Container View
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // Top Section (Date & Matching Status)
    private let topFrame = UIView()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "11. 06 (수) 16:00 ~ 16:30"
        label.textColor = UIColor.mainBlack
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        return label
    }()
    private let matchingStatusView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainGreen
        view.layer.cornerRadius = 14.5
        return view
    }()
    private let matchingStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "매칭중"
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        return label
    }()
    
    // Bottom Section
    private let bottomFrame = UIView()
    private let puppyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puppyImage.png")
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
        label.text = "봄별이"
        label.textColor = UIColor.mainBlack
        label.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        return label
    }()
    private let genderIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "femaleIcon.svg")
        return imageView
    }()
    private let sizeLabel: UILabel = {
        let label = UILabel()
        label.text = "소형견"
        label.textColor = UIColor.mainGreen
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()
    private let separatorLabel1 = createSeparatorLabel()
    private let breedLabel: UILabel = {
        let label = UILabel()
        label.text = "말티즈"
        label.textColor = UIColor.gray500
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "4kg"
        label.textColor = UIColor.gray500
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()
    
    // Post Content
    private let postContentLabel: UILabel = {
        let label = UILabel()
        label.text = "30분만 산책시켜주실 분 구합니다. 산책할 때 주의사항은 으아아아아아아아아아아아아아..."
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
        imageView.image = UIImage(named: "locationIcon.svg")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "노원구 공릉동"
        label.textColor = UIColor.gray500
        label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        return label
    }()
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "1km"
        label.textColor = UIColor.gray500
        label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        return label
    }()
    private let separatorLabel2 = createSeparatorLabel()
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "3시간 전"
        label.textColor = UIColor.gray500
        label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
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
        [nameLabel, genderIcon, sizeLabel, separatorLabel1, breedLabel, weightLabel].forEach {
            dogInfoFrame.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        
        genderIcon.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(5.53)
            make.centerY.equalToSuperview()
            make.width.equalTo(8.94)
            make.height.equalTo(16)
        }
        
        sizeLabel.snp.makeConstraints { make in
            make.leading.equalTo(genderIcon.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        separatorLabel1.snp.makeConstraints { make in
            make.leading.equalTo(sizeLabel.snp.trailing).offset(2)
            make.centerY.equalToSuperview()
        }
        
        breedLabel.snp.makeConstraints { make in
            make.leading.equalTo(separatorLabel1.snp.trailing).offset(2)
            make.centerY.equalToSuperview()
        }
        
        weightLabel.snp.makeConstraints { make in
            make.leading.equalTo(breedLabel.snp.trailing).offset(2)
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
        [locationIcon, locationLabel, distanceLabel, separatorLabel2, timeLabel].forEach {
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
        
        separatorLabel2.snp.makeConstraints { make in
            make.leading.equalTo(distanceLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(separatorLabel2.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Helper Methods
    private static func createSeparatorLabel() -> UILabel {
        let label = UILabel()
        label.text = "·"
        label.textColor = UIColor.gray500
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }
    
    func configure(with data: MatchingData) {
        dateLabel.text = "\(data.date) \(data.startTime) ~ \(data.endTime)"
        matchingStatusLabel.text = data.matchingStatus
        puppyImageView.image = UIImage(named: data.dogProfile)
        nameLabel.text = data.dogName
        sizeLabel.text = data.dogSize
        breedLabel.text = data.breed
        weightLabel.text = data.weight
        postContentLabel.text = data.content
        locationLabel.text = data.dongAddress
        distanceLabel.text = data.distance
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

// MARK: - 로딩 상태 관련 코드
// private var isLoading: Bool = false {
//     didSet {
//         updateForLoadingState()
//     }
// }

// // 로딩 UI 요소
// private let loadingDatePlaceholder = UIView()
// private let loadingStatusPlaceholder = UIView()
// private let loadingImagePlaceholder = UIView()
// private let loadingNamePlaceholder = UIView()
// private let loadingBreedPlaceholder = UIView()
// private var loadingLines: [UIView] = []

// private func setupLoadingUI() {
//     mainView.addSubview(loadingDatePlaceholder)
//     loadingDatePlaceholder.backgroundColor = UIColor.gray200
//     loadingDatePlaceholder.layer.cornerRadius = 14
//     loadingDatePlaceholder.snp.makeConstraints { make in
//         make.width.equalTo(245)
//         make.height.equalTo(28)
//         make.top.equalToSuperview().offset(0)
//         make.leading.equalToSuperview().offset(0)
//     }
    
//     mainView.addSubview(loadingStatusPlaceholder)
//     loadingStatusPlaceholder.backgroundColor = UIColor.gray200
//     loadingStatusPlaceholder.layer.cornerRadius = 14.5
//     loadingStatusPlaceholder.snp.makeConstraints { make in
//         make.width.equalTo(63)
//         make.height.equalTo(29)
//         make.trailing.equalToSuperview().offset(0)
//         make.centerY.equalTo(loadingDatePlaceholder)
//     }
    
//     mainView.addSubview(loadingImagePlaceholder)
//     loadingImagePlaceholder.backgroundColor = UIColor(red: 0.906, green: 0.922, blue: 0.937, alpha: 1)
//     loadingImagePlaceholder.layer.cornerRadius = 10
//     loadingImagePlaceholder.snp.makeConstraints { make in
//         make.width.height.equalTo(97)
//         make.leading.equalToSuperview().offset(0)
//         make.top.equalTo(loadingDatePlaceholder.snp.bottom).offset(16.5)
//     }
    
//     let nameAndBreedStack = UIStackView(arrangedSubviews: [loadingNamePlaceholder, loadingBreedPlaceholder])
//     nameAndBreedStack.axis = .horizontal
//     nameAndBreedStack.spacing = 8
//     nameAndBreedStack.alignment = .center // 중앙 정렬
    
//     mainView.addSubview(nameAndBreedStack)
    
//     loadingNamePlaceholder.backgroundColor = UIColor.gray200
//     loadingNamePlaceholder.layer.cornerRadius = 12.5
//     loadingNamePlaceholder.snp.makeConstraints { make in
//         make.height.equalTo(25)
//         make.width.greaterThanOrEqualTo(65) // 최소 너비 설정
//     }
    
//     loadingBreedPlaceholder.backgroundColor = UIColor.gray200
//     loadingBreedPlaceholder.layer.cornerRadius = 12.5
//     loadingBreedPlaceholder.snp.makeConstraints { make in
//         make.height.equalTo(25)
//         make.width.greaterThanOrEqualTo(170) // 최소 너비 설정
//     }
    
//     nameAndBreedStack.snp.makeConstraints { make in
//         make.leading.equalTo(loadingImagePlaceholder.snp.trailing).offset(12)
//         make.trailing.equalTo(mainView.snp.trailing).offset(0)
//         make.top.equalTo(loadingStatusPlaceholder.snp.bottom).offset(16.5)
//         make.height.equalTo(25)
//     }
    
//     var previousLine: UIView? = nil
//     for _ in 0..<5 {
//         let line = UIView()
//         line.backgroundColor = UIColor(red: 0.906, green: 0.922, blue: 0.937, alpha: 1)
//         line.layer.cornerRadius = 4
//         mainView.addSubview(line)
        
//         line.snp.makeConstraints { make in
//             make.height.equalTo(8)
//             make.leading.equalTo(loadingImagePlaceholder.snp.trailing).offset(12)
//             make.trailing.equalTo(mainView.snp.trailing).offset(0)
//             if let prev = previousLine {
//                 make.top.equalTo(prev.snp.bottom).offset(5)
//             } else {
//                 make.top.equalTo(nameAndBreedStack.snp.bottom).offset(8)
//             }
//         }
//         loadingLines.append(line)
//         previousLine = line
//     }
// }

// private func updateForLoadingState() {
//     let shouldShowLoadingUI = isLoading
//     loadingDatePlaceholder.isHidden = !shouldShowLoadingUI
//     loadingStatusPlaceholder.isHidden = !shouldShowLoadingUI
//     loadingImagePlaceholder.isHidden = !shouldShowLoadingUI
//     loadingNamePlaceholder.isHidden = !shouldShowLoadingUI
//     loadingBreedPlaceholder.isHidden = !shouldShowLoadingUI
//     loadingLines.forEach { $0.isHidden = !shouldShowLoadingUI }
    
//     dateLabel.isHidden = shouldShowLoadingUI
//     matchingStatusView.isHidden = shouldShowLoadingUI
//     puppyImageView.isHidden = shouldShowLoadingUI
//     nameLabel.isHidden = shouldShowLoadingUI
//     genderIcon.isHidden = shouldShowLoadingUI
//     sizeLabel.isHidden = shouldShowLoadingUI
//     separatorLabel1.isHidden = shouldShowLoadingUI
//     breedLabel.isHidden = shouldShowLoadingUI
//     weightLabel.isHidden = shouldShowLoadingUI
//     postContentLabel.isHidden = shouldShowLoadingUI
//     locationIcon.isHidden = shouldShowLoadingUI
//     locationLabel.isHidden = shouldShowLoadingUI
//     distanceLabel.isHidden = shouldShowLoadingUI
//     separatorLabel2.isHidden = shouldShowLoadingUI
//     timeLabel.isHidden = shouldShowLoadingUI
// }

// func configureLoading(_ loading: Bool) {
//     self.isLoading = loading
// }
