import UIKit
import SnapKit

class MatchingView: UIView {

    private let customView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.303, green: 0.764, blue: 1, alpha: 1)
        return view
    }()
    
    private let locationSelectView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "공릉동"
        label.textColor = UIColor(red: 0.081, green: 0.081, blue: 0.076, alpha: 1)
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
    private let filterSelectView = FilterSelectView()  // 필터 선택 뷰 추가
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCustomView()
        setupLocationSelectView()
        setupCalendarView()
        setupFilterSelectView()  // 필터 선택 뷰 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCustomView() {
        self.addSubview(customView)
        
        customView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(280)
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        let path = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 280),
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: 30, height: 30)
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        customView.layer.mask = maskLayer
    }
    
    private func setupLocationSelectView() {
        self.addSubview(locationSelectView)
        
        locationSelectView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(83)
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
        self.addSubview(calendarView)
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(locationSelectView.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(361)
            make.height.equalTo(97)
        }
    }
    
    private func setupFilterSelectView() {
        self.addSubview(filterSelectView)
        
        filterSelectView.snp.makeConstraints { make in
            make.top.equalTo(customView.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(78)
        }
    }
}
