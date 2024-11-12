import UIKit
import SnapKit

protocol MatchingDogInformationViewDelegate: AnyObject {
    func applyWalkButtonTapped()
}

class MatchingDogInformationView: UIView, UIScrollViewDelegate {

    // MARK: - Delegate
    weak var delegate: MatchingDogInformationViewDelegate?
    
    // MARK: - UI Components
    private let mainScrollView = UIScrollView()
    private let contentView = UIView()
    private let imageScrollView = UIScrollView()
    private let imageContentView = UIView()
    private let pageControl = UIPageControl()
    private var imageViews: [UIImageView] = []

    private let profileFrame = ProfileView()
    private let walkInfoFrame = WalkInfoView()
    private let relatedInfoFrame = RelatedInfoView()
    private let ownerInfoFrame = OwnerInfoView()
    private let buttonFrame = UIView()

    private let walkTalkButton: UIView = MatchingDogInformationView.createRoundedButton(
        backgroundColor: UIColor.gray100, cornerRadius: 15
    )
    
    private let applyWalkButton: UIView = MatchingDogInformationView.createRoundedButton(
        backgroundColor: UIColor.gray600, cornerRadius: 15
    )

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupFrames()
        setupButtonActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupFrames()
        setupButtonActions()
    }
    
    // MARK: - Private Methods
    private func setupButtonActions() {
        let applyTapGesture = UITapGestureRecognizer(target: self, action: #selector(applyWalkButtonTapped))
        applyWalkButton.addGestureRecognizer(applyTapGesture)
        applyWalkButton.isUserInteractionEnabled = true
    }

    @objc private func applyWalkButtonTapped() {
        delegate?.applyWalkButtonTapped()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .white

        // Main ScrollView 설정
        addSubview(mainScrollView)
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 102, right: 0))
        }

        // Content View 설정
        mainScrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        // Image ScrollView와 PageControl 설정
        setupImageScrollView()
        setupPageControl()
    }

    private func setupImageScrollView() {
        contentView.addSubview(imageScrollView)
        imageScrollView.isPagingEnabled = true
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.delegate = self
        imageScrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(imageScrollView.snp.width).multipliedBy(297.66 / 393.0)
        }

        imageScrollView.addSubview(imageContentView)
        imageContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }

    private func setupPageControl() {
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

    // MARK: - Public Method
    func setProfileDelegate(_ delegate: ProfileViewDelegate) {
        profileFrame.setDelegate(delegate)
    }

    private func setupFrames() {
        addFramesToContentView([
            (profileFrame, 102, pageControl.snp.bottom, 32),
            (walkInfoFrame, 226, profileFrame.snp.bottom, 34),
            (relatedInfoFrame, nil, walkInfoFrame.snp.bottom, 16),
            (ownerInfoFrame, 172, relatedInfoFrame.snp.bottom, 16)
        ])

        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(ownerInfoFrame.snp.bottom).offset(20)
        }

        // Button Frame
        setupButtonFrame()
    }

    private func addFramesToContentView(_ frames: [(UIView, CGFloat?, ConstraintRelatableTarget, CGFloat)]) {
        for (frame, height, topAnchor, topOffset) in frames {
            contentView.addSubview(frame)
            frame.snp.makeConstraints { make in
                make.top.equalTo(topAnchor).offset(topOffset)
                make.centerX.equalToSuperview()
                make.width.equalTo(353)
                if let height = height {
                    make.height.equalTo(height)
                }
            }
        }
    }

    private func setupButtonFrame() {
        addSubview(buttonFrame)
        buttonFrame.backgroundColor = .white
        buttonFrame.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(102)
        }

        // 워크톡 버튼
        buttonFrame.addSubview(walkTalkButton)
        walkTalkButton.snp.makeConstraints { make in
            make.top.equalTo(buttonFrame.snp.top).offset(24)
            make.leading.equalTo(buttonFrame.snp.leading).offset(20)
            make.width.equalTo(93)
            make.height.equalTo(54)
        }

        // 산책 지원하기 버튼
        buttonFrame.addSubview(applyWalkButton)
        applyWalkButton.snp.makeConstraints { make in
            make.top.equalTo(buttonFrame.snp.top).offset(24)
            make.leading.equalTo(walkTalkButton.snp.trailing).offset(12)
            make.trailing.equalTo(buttonFrame.snp.trailing).inset(17)
            make.height.equalTo(54)
        }

        // 버튼 라벨 설정
        setupButtonLabel(walkTalkButton, text: "워크톡", textColor: UIColor.gray400)
        setupButtonLabel(applyWalkButton, text: "산책 지원하기", textColor: UIColor.gray100)
    }

    private func setupButtonLabel(_ button: UIView, text: String, textColor: UIColor) {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.textAlignment = .center
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / UIScreen.main.bounds.width)
        pageControl.currentPage = Int(pageIndex)
    }

    // MARK: - Helper Methods
    private static func createRoundedButton(backgroundColor: UIColor, cornerRadius: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = cornerRadius
        return view
    }

    func configureImages(with imageNames: [String]) {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews = imageNames.map { createImageView(named: $0) }
        
        for (index, imageView) in imageViews.enumerated() {
            imageContentView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(UIScreen.main.bounds.width)
                make.leading.equalToSuperview().offset(CGFloat(index) * UIScreen.main.bounds.width)
            }
        }
        
        imageContentView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * CGFloat(imageNames.count))
        }
        
        pageControl.numberOfPages = imageNames.count
    }

    private func createImageView(named imageName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName) ?? UIImage(named: "defaultDogImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
}
