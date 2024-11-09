import UIKit
import SnapKit

class CalendarView: UIView {
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray600
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var dayCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 37, height: 63)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: DayCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private var selectedIndexPath: IndexPath?
    private var days: [(dayOfWeek: String, date: String)] = []
    private let calendar = Calendar.current
    private let today = Date()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configureDays()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(monthLabel)
        addSubview(dayCollectionView)
        
        monthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(22)
        }
        
        dayCollectionView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(63)
        }
    }
    
    private func configureDays() {
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "M월"
        monthLabel.text = "\(calendar.component(.year, from: today))년 \(monthFormatter.string(from: today))"
        
        let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
        
        // 14개의 날짜만 계산
        for offset in 0..<14 {
            if let date = calendar.date(byAdding: .day, value: offset, to: today) {
                let weekdayIndex = calendar.component(.weekday, from: date) - 1
                let dayOfWeek = weekdays[weekdayIndex]
                let day = String(calendar.component(.day, from: date))
                days.append((dayOfWeek, day))
            }
        }
        
        dayCollectionView.reloadData()
        selectedIndexPath = IndexPath(item: 0, section: 0)
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.identifier, for: indexPath) as? DayCell else {
            return UICollectionViewCell()
        }
        
        let day = days[indexPath.item]
        cell.configure(dayOfWeek: day.dayOfWeek, day: day.date)
        
        if selectedIndexPath == indexPath {
            cell.configureSelectedStyle()
        } else {
            cell.configureUnselectedStyle()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard selectedIndexPath != indexPath else { return }
        
        if let previousIndexPath = selectedIndexPath,
           let previousCell = collectionView.cellForItem(at: previousIndexPath) as? DayCell {
            previousCell.configureUnselectedStyle()
        }
        
        selectedIndexPath = indexPath
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? DayCell {
            selectedCell.configureSelectedStyle()
        }
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
