import UIKit

class DayCell: UICollectionViewCell {
    // MARK: - Identifier
    static let identifier = "DayCell"
    
    // MARK: - UI Components
    private let dayOfWeekLabel = SmallMainHighlightParagraphLabel(text: "")
    private let dayLabel = DayCell.createLabel(font: "Pretendard-Bold", fontSize: 16)
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUnselectedStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupLayout() {
        contentView.addSubview(dayOfWeekLabel)
        contentView.addSubview(dayLabel)
        
        dayOfWeekLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(dayOfWeekLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }
    }
    
    // MARK: - Configuration
    func configure(dayOfWeek: String, day: String) {
        dayOfWeekLabel.text = dayOfWeek
        dayLabel.text = day
    }
    
    func configureSelectedStyle() {
        applyStyle(backgroundColor: .black, textColor: .white, cornerRadius: 18.5)
    }
    
    func configureUnselectedStyle() {
        applyStyle(backgroundColor: .clear, textColor: UIColor.mainBlack, cornerRadius: 0)
    }
    
    // MARK: - Helpers
    private func applyStyle(backgroundColor: UIColor, textColor: UIColor, cornerRadius: CGFloat) {
        contentView.backgroundColor = backgroundColor
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        dayOfWeekLabel.textColor = textColor
        dayLabel.textColor = textColor
    }
    
    private static func createLabel(font: String, fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: font, size: fontSize)
        label.textColor = UIColor.mainBlack
        label.textAlignment = .center
        return label
    }
}
