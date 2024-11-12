import UIKit
import SnapKit

protocol MatchingViewLocationProvider: AnyObject {
    var locationText: String { get }
}

class MatchingView: UIView, MatchingViewLocationProvider {
    var locationText: String {
        return locationLabel.text ?? ""
    }
    
    // MARK: - Properties
    var filterButtonAction: (() -> Void)?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let customView: UIView = MatchingView.createBackgroundView(color: UIColor.mainBlue)
    private let safeAreaBackgroundView = MatchingView.createBackgroundView(color: UIColor.mainBlue)
    private let bounceBackgroundView = MatchingView.createBackgroundView(color: UIColor.mainBlue, isHidden: true)
    let locationSelectView = UIView()
    private let locationLabel = MatchingView.createLabel(
        text: "공릉동",
        font: UIFont(name: "Pretendard-Bold", size: 20),
        textColor: UIColor.mainBlack,
        kern: -0.32,
        lineHeight: 1.17
    )
    private let selectImageView = MatchingView.createImageView(named: "selectdongbtn")
    private let calendarView = CalendarView()
    let filterSelectView = FilterSelectView()
    private(set) var matchingCells: [MatchingCell] = []
    private let floatingButton = MatchingView.createRoundedView(color: UIColor.mainBlue, cornerRadius: 32)
    private let floatingButtonIcon = MatchingView.createImageView(named: "pencilIcon")
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func updateMatchingCells(with data: [MatchingData]) {
        // Clear existing cells
        matchingCells.forEach { $0.removeFromSuperview() }
        matchingCells.removeAll()
        
        // Add new cells
        for item in data {
            let cell = MatchingCell()
            cell.configure(with: item) // 데이터만 설정
            matchingCells.append(cell)
            contentView.addSubview(cell)
        }
        
        // Layout cells
        for (index, cell) in matchingCells.enumerated() {
            cell.snp.makeConstraints { make in
                make.width.equalTo(353)
                make.height.equalTo(151)
                make.centerX.equalToSuperview()
                make.top.equalTo(index == 0 ? filterSelectView.snp.bottom : matchingCells[index - 1].snp.bottom).offset(index == 0 ? 12 : 32)
            }
        }

        matchingCells.last?.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-110)
        }
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
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
    
    private func setupSafeAreaBackgroundView() {
        addSubview(safeAreaBackgroundView)
        safeAreaBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupBounceBackgroundView() {
        addSubview(bounceBackgroundView)
        bounceBackgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
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
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(226)
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
            make.leading.trailing.equalToSuperview().inset(16)
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
        
        filterSelectView.filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    
    @objc private func filterButtonTapped() {
        filterButtonAction?()
    }
    
    private func setupMatchingCells() {
        for _ in 0..<4 {
            let cell = MatchingCell()
            matchingCells.append(cell)
            contentView.addSubview(cell)
        }
        
        for (index, cell) in matchingCells.enumerated() {
            cell.snp.makeConstraints { make in
                make.width.equalTo(353)
                make.height.equalTo(151)
                make.centerX.equalToSuperview()
                make.top.equalTo(index == 0 ? filterSelectView.snp.bottom : matchingCells[index - 1].snp.bottom).offset(index == 0 ? 12 : 32)
            }
        }
        
        matchingCells.last?.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-110)
        }
    }
    
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
            make.width.height.equalTo(32)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension MatchingView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint.zero
        }
    }
}

// MARK: - Factory Methods
private extension MatchingView {
    static func createBackgroundView(color: UIColor, isHidden: Bool = false) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.isHidden = isHidden
        return view
    }
    
    static func createRoundedView(color: UIColor, cornerRadius: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = cornerRadius
        return view
    }
    
    static func createLabel(text: String, font: UIFont?, textColor: UIColor, kern: CGFloat, lineHeight: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = font
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeight
        
        label.attributedText = NSAttributedString(string: text, attributes: [
            .kern: kern,
            .paragraphStyle: paragraphStyle
        ])
        return label
    }
    
    static func createImageView(named: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: named)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}

// MARK: - Public Methods
extension MatchingView {
    func updateLocationLabel(with location: String) {
        locationLabel.text = location
    }
}
