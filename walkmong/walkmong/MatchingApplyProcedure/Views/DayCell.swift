import UIKit

class DayCell: UICollectionViewCell {
    static let identifier = "DayCell"
    
    private let dayOfWeekLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label.textColor = UIColor.mainBlack
        label.textAlignment = .center
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textColor = UIColor.mainBlack
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUnselectedStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func configure(dayOfWeek: String, day: String) {
        dayOfWeekLabel.text = dayOfWeek
        dayLabel.text = day
    }
    
    func configureSelectedStyle() {
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 18.5
        contentView.layer.masksToBounds = true
        dayOfWeekLabel.textColor = .white
        dayLabel.textColor = .white
    }
    
    func configureUnselectedStyle() {
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 0
        contentView.layer.masksToBounds = true
        dayOfWeekLabel.textColor = UIColor.mainBlack
        dayLabel.textColor = UIColor.mainBlack
    }
}
