import UIKit
import SnapKit

class MatchingDogInformationView: UIView {

    // MARK: - UI Components
    private let mainScrollView = UIScrollView()
    private let contentView = UIView()
    private let imageScrollView = UIScrollView()
    private let imageContentView = UIView()
    private let pageControl = UIPageControl()
    private var imageViews: [UIImageView] = []

    private let profileFrame = UIView()
    private let infoFrame = UIView()
    private let walkInfoFrame = UIView()
    private let relatedInfoFrame = UIView()
    private let ownerInfoFrame = UIView()
    private let buttonFrame = UIView()

    private let walkTalkButton: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray100
        view.layer.cornerRadius = 15
        return view
    }()

    private let applyWalkButton: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray600
        view.layer.cornerRadius = 15
        return view
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupFrames()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupFrames()
    }

    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .white

        // Main ScrollView 설정
        addSubview(mainScrollView)
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-102)
        }

        // ScrollView Content View 설정
        mainScrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        // ScrollView 내부 콘텐츠: 이미지 뷰
        contentView.addSubview(imageScrollView)
        imageScrollView.isPagingEnabled = true
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.delegate = self
        imageScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(imageScrollView.snp.width).multipliedBy(297.66 / 393.0)
        }

        imageScrollView.addSubview(imageContentView)
        imageContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }

        // PageControl 설정
        contentView.addSubview(pageControl)
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.mainBlue.withAlphaComponent(0.3)
        pageControl.currentPageIndicatorTintColor = .mainBlue
        pageControl.backgroundColor = UIColor(red: 0.749, green: 0.749, blue: 0.749, alpha: 0.44)
        pageControl.layer.cornerRadius = 12
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(12.34)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }
    }

    private func setupFrames() {
        // Profile Frame
        profileFrame.backgroundColor = .red
        contentView.addSubview(profileFrame)
        profileFrame.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(102)
        }

        infoFrame.backgroundColor = .yellow
        contentView.addSubview(infoFrame)
        infoFrame.snp.makeConstraints { make in
            make.top.equalTo(profileFrame.snp.bottom).offset(34)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(754)
        }

        infoFrame.addSubview(walkInfoFrame)
        walkInfoFrame.snp.makeConstraints { make in
            make.top.equalTo(infoFrame.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalTo(353)
            make.height.equalTo(226)
        }

        infoFrame.addSubview(relatedInfoFrame)
        relatedInfoFrame.snp.makeConstraints { make in
            make.top.equalTo(walkInfoFrame.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(353)
            make.height.equalTo(324)
        }

        infoFrame.addSubview(ownerInfoFrame)
        ownerInfoFrame.snp.makeConstraints { make in
            make.top.equalTo(relatedInfoFrame.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(353)
            make.height.equalTo(172)
        }

        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(infoFrame.snp.bottom).offset(20)
        }

        addSubview(buttonFrame)
        buttonFrame.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(102)
        }
        setupButtonFrame()
    }

    private func setupButtonFrame() {
        // 워크톡 버튼
        buttonFrame.addSubview(walkTalkButton)
        walkTalkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(93)
            make.height.equalTo(53)
        }

        let walkTalkLabel = UILabel()
        walkTalkLabel.text = "워크톡"
        walkTalkLabel.textColor = UIColor.gray400
        walkTalkLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        walkTalkLabel.textAlignment = .center
        walkTalkButton.addSubview(walkTalkLabel)
        walkTalkLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        // 산책 지원 버튼
        buttonFrame.addSubview(applyWalkButton)
        applyWalkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(walkTalkButton.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(17)
            make.height.equalTo(54)
        }

        let applyWalkLabel = UILabel()
        applyWalkLabel.text = "산책 지원하기"
        applyWalkLabel.textColor = UIColor.gray100
        applyWalkLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        applyWalkLabel.textAlignment = .center
        applyWalkButton.addSubview(applyWalkLabel)
        applyWalkLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        // 버튼 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(applyWalkButtonTapped))
        applyWalkButton.addGestureRecognizer(tapGesture)
    }

    // MARK: - Helper Methods
    private func createImageView(named imageName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName) ?? UIImage(named: "defaultDogImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }

    // MARK: - Actions
    @objc private func applyWalkButtonTapped() {
        (self.findViewController() as? MatchingDogInformationViewController)?.navigateToMatchingApplyDetailSelect()
    }

    func configureImages(with imageNames: [String]) {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews = imageNames.map { imageName -> UIImageView in
            let imageView = createImageView(named: imageName)
            imageContentView.addSubview(imageView)
            return imageView
        }
        
        let screenWidth = UIScreen.main.bounds.width
        for (index, imageView) in imageViews.enumerated() {
            imageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(screenWidth)
                make.leading.equalToSuperview().offset(CGFloat(index) * screenWidth)
            }
        }
        
        imageContentView.snp.makeConstraints { make in
            make.width.equalTo(screenWidth * CGFloat(imageNames.count))
        }
        
        pageControl.numberOfPages = imageNames.count
    }
}

// MARK: - UIScrollViewDelegate
extension MatchingDogInformationView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / UIScreen.main.bounds.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

// MARK: - UIView 확장
extension UIView {
    func findViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        while let responder = nextResponder {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            nextResponder = responder.next
        }
        return nil
    }
}
