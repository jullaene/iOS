import UIKit
import SnapKit

class MatchingDogInformationView: UIView, UIScrollViewDelegate {
    
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
        
        walkInfoFrame.backgroundColor = UIColor.gray100
        walkInfoFrame.layer.cornerRadius = 20
        infoFrame.addSubview(walkInfoFrame)
        walkInfoFrame.snp.makeConstraints { make in
            make.top.equalTo(infoFrame.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalTo(353)
            make.height.equalTo(226)
        }
        
        relatedInfoFrame.backgroundColor = UIColor.gray100
        relatedInfoFrame.layer.cornerRadius = 20
        infoFrame.addSubview(relatedInfoFrame)
        relatedInfoFrame.snp.makeConstraints { make in
            make.top.equalTo(walkInfoFrame.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(353)
            make.height.equalTo(324)
        }
        
        ownerInfoFrame.backgroundColor = UIColor.gray100
        ownerInfoFrame.layer.cornerRadius = 20
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
        buttonFrame.backgroundColor = .blue
        buttonFrame.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(102)
        }
    }
    
    // MARK: - Public Methods
    func configureImages(with imageNames: [String]) {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews = []
        
        let screenWidth = UIScreen.main.bounds.width
        
        for (index, imageName) in imageNames.enumerated() {
            let imageView = UIImageView()
            imageView.image = UIImage(named: imageName) ?? UIImage(named: "defaultDogImage")
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageContentView.addSubview(imageView)
            imageViews.append(imageView)
            
            imageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(screenWidth)
                make.height.equalTo(imageScrollView.snp.height)
                make.leading.equalToSuperview().offset(CGFloat(index) * screenWidth)
            }
        }
        
        imageContentView.snp.makeConstraints { make in
            make.width.equalTo(screenWidth * CGFloat(imageNames.count))
        }
        
        pageControl.numberOfPages = imageNames.count
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / UIScreen.main.bounds.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
