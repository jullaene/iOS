import UIKit
import SnapKit

class CalendarView: UIView {
    // MARK: - UI Components
    private let monthLabel = MainHighlightParagraphLabel(text: "", textColor: .gray600)
    
    lazy var dayCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 37, height: 63)
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: DayCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Properties
    var selectedIndexPath: IndexPath?
    private var days: [(dayOfWeek: String, date: String)] = []
    private let calendar = Calendar.current
    private let today = Date()
    
    var selectedDate: String? {
        guard let indexPath = selectedIndexPath else { return nil }
        let day = days[indexPath.item]
        return "\(day.date). \(day.dayOfWeek)"
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateMonthLabel()
        generateDays()
        dayCollectionView.reloadData()
        selectedIndexPath = IndexPath(item: 0, section: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        addSubview(monthLabel)
        addSubview(dayCollectionView)
        
        monthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(22)
        }
        
        dayCollectionView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(63)
        }
    }
    
    // MARK: - Update Methods
    private func updateMonthLabel() {
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "M월"
        monthLabel.text = "\(calendar.component(.year, from: today))년 \(monthFormatter.string(from: today))"
    }
    
    private func generateDays() {
        days = calculateDays(for: 14)
    }
    
    private func calculateDays(for count: Int) -> [(dayOfWeek: String, date: String)] {
        let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
        var result: [(dayOfWeek: String, date: String)] = []

        for offset in 0..<count {
            if let date = calendar.date(byAdding: .day, value: offset, to: today) {
                let weekdayIndex = calendar.component(.weekday, from: date) - 1
                let dayOfWeek = weekdays[weekdayIndex]
                let day = String(calendar.component(.day, from: date))
                result.append((dayOfWeek, day))
            }
        }

        return result
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
        selectedIndexPath == indexPath ? cell.configureSelectedStyle() : cell.configureUnselectedStyle()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard selectedIndexPath != indexPath else { return }
        
        updateSelection(from: selectedIndexPath, to: indexPath)
        selectedIndexPath = indexPath
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    // MARK: - Selection Update
    private func updateSelection(from previous: IndexPath?, to current: IndexPath) {
        if let previousIndexPath = previous,
           let previousCell = dayCollectionView.cellForItem(at: previousIndexPath) as? DayCell {
            previousCell.configureUnselectedStyle()
        }
        
        if let currentCell = dayCollectionView.cellForItem(at: current) as? DayCell {
            currentCell.configureSelectedStyle()
        }
    }
}

extension CalendarView {
    func getSelectedDate() -> String? {
        guard let indexPath = selectedIndexPath else {
            print("No selected index path")
            return nil
        }
        let day = days[indexPath.item]

        // 현재 연도와 월 가져오기
        let currentYear = calendar.component(.year, from: today)
        let currentMonth = calendar.component(.month, from: today)

        // 선택된 날짜(day.date)를 정수로 변환
        guard let dayInt = Int(day.date) else {
            print("Failed to convert day.date (\(day.date)) to Int")
            return nil
        }

        // 날짜 컴포넌트 생성
        let components = DateComponents(year: currentYear, month: currentMonth, day: dayInt)
        guard let date = calendar.date(from: components) else {
            print("Failed to generate date from components: \(components)")
            return nil
        }

        // 포맷터 설정
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM. dd (EEE)" // "11. 14 (목)" 형식
        
        return formatter.string(from: date)
    }
    
    func reloadCalendar() {
        generateDays()
        dayCollectionView.reloadData()
    }
    
    func updateSectionInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        if let layout = dayCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        }
    }
}
