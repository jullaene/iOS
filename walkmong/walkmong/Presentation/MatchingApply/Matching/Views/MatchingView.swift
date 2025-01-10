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
        text: "내주소",
        font: UIFont(name: "Pretendard-Bold", size: 20),
        textColor: UIColor.mainBlack
    )
    private let selectImageView = UIImage.createImageView(named: "selectdongbtn")
    private let alertIcon = UIImage.createImageView(named: "alertIcon")
    private let calendarView = CalendarView()
    let filterSelectView = FilterSelectView()
    var matchingCells: [MatchingCell] = []
    
    private let floatingButton = UIView.createRoundedView(backgroundColor: .mainBlue, cornerRadius: 32)
    private let floatingButtonIcon = UIImage.createImageView(named: "pencilIcon")
    
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
        clearMatchingCells()
        createMatchingCells(from: data)
        layoutMatchingCells()
    }
    
    func updateLocationLabel(with location: String) {
        locationLabel.text = location
    }
    
    var selectedDate: String? {
        return calendarView.selectedDate
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
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bounces = false
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
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
        
        customView.addSubview(alertIcon)
        alertIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalTo(customView.snp.top).offset(27)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(alertIconTapped))
        alertIcon.isUserInteractionEnabled = true
        alertIcon.addGestureRecognizer(tapGesture)
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
            make.leading.trailing.equalToSuperview()
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(floatingButtonTapped))
        floatingButton.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Matching Cells Management
    private func clearMatchingCells() {
        matchingCells.forEach { $0.removeFromSuperview() }
        matchingCells.removeAll()
    }
    
    private func createMatchingCells(from data: [MatchingData]) {
        data.forEach { item in
            let cell = MatchingCell()
            cell.configure(with: item)
            matchingCells.append(cell)
            contentView.addSubview(cell)
        }
    }
    
    private func layoutMatchingCells() {
        for (index, cell) in matchingCells.enumerated() {
            cell.snp.makeConstraints { make in
                make.height.equalTo(151)
                make.centerX.equalToSuperview()
                make.top.equalTo(index == 0 ? filterSelectView.snp.bottom : matchingCells[index - 1].snp.bottom).offset(index == 0 ? 12 : 32)
                make.leading.trailing.equalToSuperview().inset(20)
            }
        }

        matchingCells.last?.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-110)
        }
    }

    @objc private func filterButtonTapped() {
        filterButtonAction?()
    }
    
    @objc private func alertIconTapped() {
        if let viewController = getViewController() {
            let alertVC = AlertViewController()
            viewController.navigationController?.pushViewController(alertVC, animated: true)
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
    
    static func createLabel(text: String, font: UIFont?, textColor: UIColor, kern: CGFloat = 0, lineHeight: CGFloat = 1.0) -> UILabel {
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

    @objc private func floatingButtonTapped() {
        if let viewController = findViewController() as? MatchingViewController {
            viewController.navigateToWalkRequestView()
        }
    }
}
