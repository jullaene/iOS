import UIKit
import SnapKit

protocol CalendarViewDelegate: AnyObject {
    func didSelectDate(_ date: String)
}

class CalendarView: UIView {
    // MARK: - UI Components
    weak var delegate: CalendarViewDelegate?
    
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
        
        if let selectedDate = getSelectedDate() {
            delegate?.didSelectDate(selectedDate)
        }
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
    
    private func formatDate(_ components: DateComponents, with format: String) -> String? {
        guard let date = calendar.date(from: components) else {
            print("Failed to generate date from components: \(components)")
            return nil
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = format

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
    
    func getSelectedDate() -> String? {
        guard let indexPath = selectedIndexPath else {
            print("No selected index path")
            return nil
        }
        let day = days[indexPath.item]

        let currentYear = calendar.component(.year, from: today)
        let currentMonth = calendar.component(.month, from: today)

        guard let dayInt = Int(day.date) else {
            print("Failed to convert day.date (\(day.date)) to Int")
            return nil
        }

        let components = DateComponents(year: currentYear, month: currentMonth, day: dayInt)
        return formatDate(components, with: "MM. dd (EEE)")
    }
    
    func getSelectedDateWithFullFormat() -> String? {
        guard let indexPath = selectedIndexPath else {
            print("No selected index path")
            return nil
        }
        let day = days[indexPath.item]

        let currentYear = calendar.component(.year, from: today)
        let currentMonth = calendar.component(.month, from: today)

        guard let dayInt = Int(day.date) else {
            print("Failed to convert day.date (\(day.date)) to Int")
            return nil
        }

        let components = DateComponents(year: currentYear, month: currentMonth, day: dayInt)
        return formatDate(components, with: "yyyy년 MM월 dd일 (EEE)")
    }
}
