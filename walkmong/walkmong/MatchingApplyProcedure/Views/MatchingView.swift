import UIKit
import SnapKit

class MatchingView: UIView {
    
    var filterButtonAction: (() -> Void)? // filterButton 클릭 시 실행될 동작을 전달하기 위한 클로저
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let customView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainBlue
        return view
    }()
    
    let locationSelectView: UIView = {
        let view = UIView()
        return view
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "공릉동"
        label.textColor = UIColor.mainBlack
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        label.attributedText = NSMutableAttributedString(string: "공릉동", attributes: [
            .kern: -0.32,
            .paragraphStyle: paragraphStyle
        ])
        return label
    }()
    
    private let selectImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "selectdongbtn")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let calendarView = CalendarView()
    let filterSelectView = FilterSelectView()
    private var matchingCells: [MatchingCell] = []
    
    private let floatingButton: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.mainBlue.cgColor
        view.layer.cornerRadius = 32
        return view
    }()
    
    private let floatingButtonIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pencilIcon") // pencilIcon.svg를 UIImage로 변환 후 프로젝트에 추가해야 합니다.
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let safeAreaBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainBlue
        return view
    }()
    
    private let bounceBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainBlue
        view.isHidden = true // 기본적으로 숨김
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSafeAreaBackgroundView()
        setupBounceBackgroundView()
        setupScrollView()
        setupCustomView()
        setupLocationSelectView()
        setupCalendarView()
        setupFilterSelectView()
        setupMatchingCells()
        setupFloatingButton()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSafeAreaBackgroundView() {
        addSubview(safeAreaBackgroundView) // 부모 뷰에 배경 뷰 추가

        safeAreaBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview() // 화면의 최상단
            make.bottom.equalTo(safeAreaLayoutGuide.snp.top) // Safe Area의 최하단
            make.leading.trailing.equalToSuperview() // 화면 양쪽 끝
        }
    }
    
    private func setupBounceBackgroundView() {
        addSubview(bounceBackgroundView)
        
        bounceBackgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200) // 충분히 큰 높이 설정
        }
    }
    
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.delegate = self // UIScrollViewDelegate 연결
        scrollView.contentInsetAdjustmentBehavior = .never
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top) // Safe Area 아래에서 시작
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    private func setupCustomView() {
        contentView.addSubview(customView)
        
        customView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(226)
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        let path = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 226),
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: 30, height: 30)
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        customView.layer.mask = maskLayer
    }
    
    private func setupLocationSelectView() {
        contentView.addSubview(locationSelectView)
        
        locationSelectView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(72)
            make.height.equalTo(28)
        }
        
        locationSelectView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        locationSelectView.addSubview(selectImageView)
        selectImageView.snp.makeConstraints { make in
            make.leading.equalTo(locationLabel.snp.trailing).offset(4)
            make.trailing.centerY.equalToSuperview()
            make.width.equalTo(16)
            make.height.equalTo(14)
        }
    }
    
    private func setupCalendarView() {
        contentView.addSubview(calendarView)
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(locationSelectView.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(97)
        }
    }
    
    private func setupFilterSelectView() {
        contentView.addSubview(filterSelectView)
        
        filterSelectView.snp.makeConstraints { make in
            make.top.equalTo(customView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(78)
        }
        
        // filterButton 클릭 이벤트와 연결
        filterSelectView.filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    
    @objc private func filterButtonTapped() {
        filterButtonAction?() // 클로저를 통해 클릭 이벤트를 전달
    }
    
    private func setupMatchingCells() {
        for _ in 0..<4 {
            let cell = MatchingCell() // MatchingCell 인스턴스를 생성
            matchingCells.append(cell)
            contentView.addSubview(cell)
        }
        
        for (index, cell) in matchingCells.enumerated() {
            cell.snp.makeConstraints { make in
                make.width.equalTo(353)
                make.height.equalTo(151)
                make.centerX.equalToSuperview()
                
                if index == 0 {
                    make.top.equalTo(filterSelectView.snp.bottom).offset(12)
                } else {
                    make.top.equalTo(matchingCells[index - 1].snp.bottom).offset(32)
                }
            }
        }
        
        matchingCells.last?.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
//    private func toggleLoadingCells(isLoading: Bool) {
//        for cell in matchingCells {
//            cell.configureLoading(isLoading)
//        }
//    }
    
    private func setupFloatingButton() {
        addSubview(floatingButton)
        
        floatingButton.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-33)
        }
        
        floatingButton.addSubview(floatingButtonIcon)
        
        floatingButtonIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(32) // 아이콘 크기 조정
        }
    }
}

extension MatchingView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 최상단 이상으로 스크롤을 당길 경우 contentOffset 제한
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: 0) // 최상단에서 멈춤
        }
    }
}
