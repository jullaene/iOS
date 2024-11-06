import UIKit
import SnapKit

class MatchingCell: UIView {
    
    private let mainView = UIView()
    private let topFrame = UIView()
    private let dateLabel = UILabel()
    private let matchingStatusView = UIView()
    private let matchingStatusLabel = UILabel()
    private let bottomFrame = UIView()
    private let puppyImageView = UIImageView()
    private let contentFrame = UIView()
    private let dogInfoFrame = UIView()
    private let nameLabel = UILabel()
    private let genderIcon = UIImageView()
    private let sizeLabel = UILabel()
    private let separatorLabel1 = UILabel()
    private let breedLabel = UILabel()
    private let weightLabel = UILabel()
    private let postContentLabel = UILabel()
    private let locationTimeFrame = UIView()
    private let locationIcon = UIImageView()
    private let locationLabel = UILabel()
    private let distanceLabel = UILabel()
    private let separatorLabel2 = UILabel()
    private let timeLabel = UILabel()
    
    private var isLoading: Bool = false {
        didSet {
            updateForLoadingState()
        }
    }
    
    // 로딩 UI 요소
    private let loadingDatePlaceholder = UIView()
    private let loadingStatusPlaceholder = UIView()
    private let loadingImagePlaceholder = UIView()
    private let loadingNamePlaceholder = UIView()
    private let loadingBreedPlaceholder = UIView()
    private var loadingLines: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        setupMainView()
        setupTopFrame()
        setupDateLabel()
        setupMatchingStatusView()
        setupBottomFrame()
        setupPuppyImageView()
        setupContentFrame()
        setupDogInfoFrame()
        setupNameLabel()
        setupGenderIcon()
        setupSizeLabel()
        setupSeparatorLabel1()
        setupBreedLabel()
        setupWeightLabel()
        setupPostContentLabel()
        setupLocationTimeFrame()
        setupLocationIcon()
        setupLocationLabel()
        setupDistanceLabel()
        setupSeparatorLabel2()
        setupTimeLabel()
        setupLoadingUI()
        updateForLoadingState()
    }
    
    private func setupMainView() {
        addSubview(mainView)
        mainView.backgroundColor = .white
        
        mainView.snp.makeConstraints { make in
            make.width.equalTo(353)
            make.height.equalTo(151)
            make.edges.equalToSuperview()
        }
    }
    
    private func setupTopFrame() {
        mainView.addSubview(topFrame)
        
        topFrame.snp.makeConstraints { make in
            make.width.equalTo(353)
            make.height.equalTo(29)
            make.top.leading.equalToSuperview()
        }
    }
    
    private func setupDateLabel() {
        dateLabel.text = "11. 06 (수) 16:00 ~ 16:30"
        dateLabel.textColor = UIColor(red: 0.081, green: 0.081, blue: 0.076, alpha: 1)
        dateLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        topFrame.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.height.equalTo(28)
        }
    }
    
    private func setupMatchingStatusView() {
        matchingStatusView.backgroundColor = UIColor(red: 0.018, green: 0.795, blue: 0.333, alpha: 1)
        matchingStatusView.layer.cornerRadius = 14.5
        topFrame.addSubview(matchingStatusView)
        
        matchingStatusView.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.equalTo(63)
            make.height.equalTo(29)
        }
        
        matchingStatusLabel.text = "매칭중"
        matchingStatusLabel.textColor = .white
        matchingStatusLabel.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        matchingStatusView.addSubview(matchingStatusLabel)
        
        matchingStatusLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupBottomFrame() {
        mainView.addSubview(bottomFrame)
        
        bottomFrame.snp.makeConstraints { make in
            make.width.equalTo(353)
            make.height.equalTo(106)
            make.bottom.leading.equalToSuperview()
        }
    }
    
    private func setupPuppyImageView() {
        puppyImageView.image = UIImage(named: "puppyImage.png")
        puppyImageView.layer.cornerRadius = 10
        puppyImageView.clipsToBounds = true
        puppyImageView.contentMode = .scaleAspectFill
        bottomFrame.addSubview(puppyImageView)
        
        puppyImageView.snp.makeConstraints { make in
            make.width.height.equalTo(97)
            make.leading.equalTo(bottomFrame.snp.leading)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupContentFrame() {
        bottomFrame.addSubview(contentFrame)
        
        contentFrame.snp.makeConstraints { make in
            make.leading.equalTo(puppyImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.height.equalTo(106)
        }
    }
    
    private func setupDogInfoFrame() {
        contentFrame.addSubview(dogInfoFrame)
        
        dogInfoFrame.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(25)
        }
    }
    
    private func setupNameLabel() {
        nameLabel.text = "봄별이"
        nameLabel.textColor = UIColor(red: 0.081, green: 0.081, blue: 0.076, alpha: 1)
        nameLabel.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        dogInfoFrame.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
    }
    
    private func setupGenderIcon() {
        genderIcon.image = UIImage(named: "femaleIcon.svg")
        dogInfoFrame.addSubview(genderIcon)
        
        genderIcon.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(5.53)
            make.centerY.equalToSuperview()
            make.width.equalTo(8.94)
            make.height.equalTo(16)
        }
    }
    
    private func setupSizeLabel() {
        sizeLabel.text = "소형견"
        sizeLabel.textColor = UIColor(red: 0.018, green: 0.795, blue: 0.333, alpha: 1)
        sizeLabel.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        dogInfoFrame.addSubview(sizeLabel)
        
        sizeLabel.snp.makeConstraints { make in
            make.leading.equalTo(genderIcon.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupSeparatorLabel1() {
        separatorLabel1.text = "·"
        separatorLabel1.textColor = UIColor(red: 0.365, green: 0.373, blue: 0.404, alpha: 1)
        separatorLabel1.font = UIFont(name: "Pretendard-Regular", size: 14)
        dogInfoFrame.addSubview(separatorLabel1)
        
        separatorLabel1.snp.makeConstraints { make in
            make.leading.equalTo(sizeLabel.snp.trailing).offset(2)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupBreedLabel() {
        breedLabel.text = "말티즈"
        breedLabel.textColor = UIColor(red: 0.365, green: 0.373, blue: 0.404, alpha: 1)
        breedLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        dogInfoFrame.addSubview(breedLabel)
        
        breedLabel.snp.makeConstraints { make in
            make.leading.equalTo(separatorLabel1.snp.trailing).offset(2)
            make.centerY.equalToSuperview()
        }
    }
        
    private func setupWeightLabel() {
        weightLabel.text = "4kg"
        weightLabel.textColor = UIColor(red: 0.365, green: 0.373, blue: 0.404, alpha: 1)
        weightLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        dogInfoFrame.addSubview(weightLabel)
        
        weightLabel.snp.makeConstraints { make in
            make.leading.equalTo(breedLabel.snp.trailing).offset(2)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupPostContentLabel() {
        postContentLabel.text = "30분만 산책시켜주실 분 구합니다. 산책할 때 주의사항은 으아아아아아아아아아아아아아..."
        postContentLabel.textColor = UIColor(red: 0.365, green: 0.373, blue: 0.404, alpha: 1)
        postContentLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        postContentLabel.numberOfLines = 0
        postContentLabel.lineBreakMode = .byCharWrapping
        contentFrame.addSubview(postContentLabel)
        
        postContentLabel.snp.makeConstraints { make in
            make.top.equalTo(dogInfoFrame.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalTo(mainView.snp.trailing).offset(0)
        }
    }
    
    private func setupLocationTimeFrame() {
        contentFrame.addSubview(locationTimeFrame)
        
        locationTimeFrame.snp.makeConstraints { make in
            make.top.equalTo(postContentLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(21)
        }
    }
    
    private func setupLocationIcon() {
        locationIcon.image = UIImage(named: "locationIcon.svg")
        locationIcon.contentMode = .scaleAspectFit
        locationTimeFrame.addSubview(locationIcon)
        
        locationIcon.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
    }
    
    private func setupLocationLabel() {
        locationLabel.text = "노원구 공릉동"
        locationLabel.textColor = UIColor(red: 0.365, green: 0.373, blue: 0.404, alpha: 1)
        locationLabel.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        locationTimeFrame.addSubview(locationLabel)
        
        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(locationIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
    }

    private func setupDistanceLabel() {
        distanceLabel.text = "1km"
        distanceLabel.textColor = UIColor(red: 0.365, green: 0.373, blue: 0.404, alpha: 1)
        distanceLabel.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        locationTimeFrame.addSubview(distanceLabel)
        
        distanceLabel.snp.makeConstraints { make in
            make.leading.equalTo(locationLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupSeparatorLabel2() {
        separatorLabel2.text = "·"
        separatorLabel2.textColor = UIColor(red: 0.365, green: 0.373, blue: 0.404, alpha: 1)
        separatorLabel2.font = UIFont(name: "Pretendard-Regular", size: 12)
        locationTimeFrame.addSubview(separatorLabel2)
        
        separatorLabel2.snp.makeConstraints { make in
            make.leading.equalTo(distanceLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
    }

    private func setupTimeLabel() {
        timeLabel.text = "3시간 전"
        timeLabel.textColor = UIColor(red: 0.365, green: 0.373, blue: 0.404, alpha: 1)
        timeLabel.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        locationTimeFrame.addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(separatorLabel2.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupLoadingUI() {
        mainView.addSubview(loadingDatePlaceholder)
        loadingDatePlaceholder.backgroundColor = UIColor(red: 0.906, green: 0.922, blue: 0.937, alpha: 1)
        loadingDatePlaceholder.layer.cornerRadius = 14
        loadingDatePlaceholder.snp.makeConstraints { make in
            make.width.equalTo(245)
            make.height.equalTo(28)
            make.top.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(0)
        }
        
        mainView.addSubview(loadingStatusPlaceholder)
        loadingStatusPlaceholder.backgroundColor = UIColor(red: 0.906, green: 0.922, blue: 0.937, alpha: 1)
        loadingStatusPlaceholder.layer.cornerRadius = 14.5
        loadingStatusPlaceholder.snp.makeConstraints { make in
            make.width.equalTo(63)
            make.height.equalTo(29)
            make.trailing.equalToSuperview().offset(0)
            make.centerY.equalTo(loadingDatePlaceholder)
        }
        
        mainView.addSubview(loadingImagePlaceholder)
        loadingImagePlaceholder.backgroundColor = UIColor(red: 0.906, green: 0.922, blue: 0.937, alpha: 1)
        loadingImagePlaceholder.layer.cornerRadius = 10
        loadingImagePlaceholder.snp.makeConstraints { make in
            make.width.height.equalTo(97)
            make.leading.equalToSuperview().offset(0)
            make.top.equalTo(loadingDatePlaceholder.snp.bottom).offset(16.5)
        }
        
        let nameAndBreedStack = UIStackView(arrangedSubviews: [loadingNamePlaceholder, loadingBreedPlaceholder])
        nameAndBreedStack.axis = .horizontal
        nameAndBreedStack.spacing = 8
        nameAndBreedStack.alignment = .center // 중앙 정렬
        
        mainView.addSubview(nameAndBreedStack)
        
        loadingNamePlaceholder.backgroundColor = UIColor(red: 0.906, green: 0.922, blue: 0.937, alpha: 1)
        loadingNamePlaceholder.layer.cornerRadius = 12.5
        loadingNamePlaceholder.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.greaterThanOrEqualTo(65) // 최소 너비 설정
        }
        
        loadingBreedPlaceholder.backgroundColor = UIColor(red: 0.906, green: 0.922, blue: 0.937, alpha: 1)
        loadingBreedPlaceholder.layer.cornerRadius = 12.5
        loadingBreedPlaceholder.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.greaterThanOrEqualTo(170) // 최소 너비 설정
        }
        
        nameAndBreedStack.snp.makeConstraints { make in
            make.leading.equalTo(loadingImagePlaceholder.snp.trailing).offset(12)
            make.trailing.equalTo(mainView.snp.trailing).offset(0)
            make.top.equalTo(loadingStatusPlaceholder.snp.bottom).offset(16.5)
            make.height.equalTo(25)
        }
        
        var previousLine: UIView? = nil
        for _ in 0..<5 {
            let line = UIView()
            line.backgroundColor = UIColor(red: 0.906, green: 0.922, blue: 0.937, alpha: 1)
            line.layer.cornerRadius = 4
            mainView.addSubview(line)
            
            line.snp.makeConstraints { make in
                make.width.equalTo(245)
                make.height.equalTo(8)
                make.leading.equalTo(loadingImagePlaceholder.snp.trailing).offset(12)
                make.trailing.equalTo(mainView.snp.trailing).offset(0)
                if let prev = previousLine {
                    make.top.equalTo(prev.snp.bottom).offset(5)
                } else {
                    make.top.equalTo(nameAndBreedStack.snp.bottom).offset(8)
                }
            }
            loadingLines.append(line)
            previousLine = line
        }
    }
    
    private func updateForLoadingState() {
        let shouldShowLoadingUI = isLoading
        loadingDatePlaceholder.isHidden = !shouldShowLoadingUI
        loadingStatusPlaceholder.isHidden = !shouldShowLoadingUI
        loadingImagePlaceholder.isHidden = !shouldShowLoadingUI
        loadingNamePlaceholder.isHidden = !shouldShowLoadingUI
        loadingBreedPlaceholder.isHidden = !shouldShowLoadingUI
        loadingLines.forEach { $0.isHidden = !shouldShowLoadingUI }
        
        dateLabel.isHidden = shouldShowLoadingUI
        matchingStatusView.isHidden = shouldShowLoadingUI
        puppyImageView.isHidden = shouldShowLoadingUI
        nameLabel.isHidden = shouldShowLoadingUI
        genderIcon.isHidden = shouldShowLoadingUI
        sizeLabel.isHidden = shouldShowLoadingUI
        separatorLabel1.isHidden = shouldShowLoadingUI
        breedLabel.isHidden = shouldShowLoadingUI
        weightLabel.isHidden = shouldShowLoadingUI
        postContentLabel.isHidden = shouldShowLoadingUI
        locationIcon.isHidden = shouldShowLoadingUI
        locationLabel.isHidden = shouldShowLoadingUI
        distanceLabel.isHidden = shouldShowLoadingUI
        separatorLabel2.isHidden = shouldShowLoadingUI
        timeLabel.isHidden = shouldShowLoadingUI
    }
    
    func configureLoading(_ loading: Bool) {
        self.isLoading = loading
    }
}
