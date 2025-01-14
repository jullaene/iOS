import UIKit
import SnapKit

protocol MatchingViewLocationProvider: AnyObject {
    var locationText: String { get }
}

protocol MatchingViewDelegate: AnyObject {
    func didSelectDate(_ date: String)
}


class MatchingView: UIView, MatchingViewLocationProvider, CalendarViewDelegate {
    func didSelectDate(_ date: String) {
        let formattedDate = configureDateLabel(date)
        delegate?.didSelectDate(formattedDate)
    }
    
    weak var delegate: MatchingViewDelegate?
    private var data: [BoardList]
    
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
    private let matchingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MatchingCell.self, forCellWithReuseIdentifier: MatchingCell.className)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let floatingButton = UIView.createRoundedView(backgroundColor: .mainBlue, cornerRadius: 32)
    private let floatingButtonIcon = UIImage.createImageView(named: "pencilIcon")
    
    // MARK: - Initializer
    init(data: [BoardList]) {
        self.data = data
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCollectionView() {
        matchingCollectionView.delegate = self
        matchingCollectionView.dataSource = self
    }
    
    func updateLocationLabel(with location: String) {
        let lastWord = location.components(separatedBy: " ").last ?? ""
        locationLabel.text = lastWord
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
        setCollectionView()
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
        contentView.addSubviews(matchingCollectionView, filterSelectView, customView)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = false
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().offset(-86)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.horizontalEdges.top.equalToSuperview()
            make.bottom.equalTo(matchingCollectionView.snp.bottom).offset(24)
        }
        
        customView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(226)
        }
        filterSelectView.snp.makeConstraints { make in
            make.top.equalTo(customView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(78)
        }

        matchingCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(filterSelectView.snp.bottom)
            make.height.equalTo(400)
        }
    }

    private func setupCustomView() {
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews()

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let contentHeight = self.matchingCollectionView.contentSize.height
            self.matchingCollectionView.snp.updateConstraints { make in
                make.height.equalTo(contentHeight)
            }
            self.contentView.snp.updateConstraints { make in
                make.bottom.equalTo(self.matchingCollectionView.snp.bottom).offset(24)
            }
        }
        print("CollectionView contentSize: \(matchingCollectionView.contentSize)")
        print("ScrollView contentSize: \(scrollView.contentSize)")
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
        calendarView.delegate = self
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(locationSelectView.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(97)
        }
    }
    
    private func setupFilterSelectView() {
        delegate?.didSelectDate(calendarView.selectedDate ?? "날짜 오류")
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

    @objc private func filterButtonTapped() {
        filterButtonAction?()
    }
    
    @objc private func alertIconTapped() {
        if let viewController = getViewController() {
            let alertVC = AlertViewController()
            viewController.navigationController?.pushViewController(alertVC, animated: true)
        }
    }
    
    func updateMatchingCells(with data: [BoardList]) {
        self.data = data
        matchingCollectionView.reloadData()
        layoutSubviews()
    }
    
    private func configureDateLabel(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let dateObject = dateFormatter.date(from: date) else {
            return date
        }
        
        dateFormatter.dateFormat = "MM.dd (E)"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: dateObject)
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
        if let viewController = getViewController() as? MatchingViewController {
            viewController.navigateToWalkRequestView()
        }
    }
}

extension MatchingView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Data count: \(data.count)")
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchingCell.className, for: indexPath) as? MatchingCell else { return UICollectionViewCell() }
        cell.configure(with: self.data[indexPath.row], selectedDate: selectedDate ?? "날짜 오류")
        return cell
    }
    
    
}

extension MatchingView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = MatchingDogInformationViewController()
        nextVC.configure(with: data[indexPath.row].boardId)
        self.getViewController()?.navigationController?.pushViewController(nextVC, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(32)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: matchingCollectionView.bounds.width-40, height: 151)
    }
}
