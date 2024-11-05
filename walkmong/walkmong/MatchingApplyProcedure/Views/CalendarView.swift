
import UIKit
import SnapKit

class CalendarView: UIView {
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "2024년 11월"
        label.textColor = UIColor(red: 0.198, green: 0.203, blue: 0.222, alpha: 1)
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        label.attributedText = NSMutableAttributedString(string: "2024년 11월", attributes: [
            .kern: -0.32,
            .paragraphStyle: paragraphStyle
        ])
        return label
    }()
    
    private lazy var dayCollectionView: UICollectionView = {
        let cellWidth: CGFloat = 37
        let leadingTrailingInset: CGFloat = 4
        let totalWidth = UIScreen.main.bounds.width - 32 // 기기 너비에 맞추기 위해 32를 빼고 설정
        
        // 간격 계산: 전체 너비에서 셀의 너비와 양쪽의 여백을 뺀 후 6으로 나눔
        let interItemSpacing = (totalWidth - (leadingTrailingInset * 2) - (cellWidth * 7)) / 6

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(cellWidth), heightDimension: .absolute(63))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(63))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(interItemSpacing)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: leadingTrailingInset, bottom: 0, trailing: leadingTrailingInset)
            return section
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: DayCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(monthLabel)
        self.addSubview(dayCollectionView)
        
        monthLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.equalTo(84)
            make.height.equalTo(22)
        }
        
        dayCollectionView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(63)
        }
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.identifier, for: indexPath) as? DayCell else {
            return UICollectionViewCell()
        }
        
        let days = [("일", "3"), ("월", "4"), ("화", "5"), ("수", "6"), ("목", "7"), ("금", "8"), ("토", "9")]
        cell.configure(dayOfWeek: days[indexPath.item].0, day: days[indexPath.item].1)
        
        // 첫 번째 셀의 디자인 설정
        if indexPath.item == 0 {
            cell.configureSelectedStyle()
        }
        
        return cell
    }
}
