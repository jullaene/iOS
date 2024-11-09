import UIKit
import SnapKit

class FilterSelectView: UIView {

    // filterButton을 외부에서 접근 가능하도록 public으로 설정
    public let filterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.978, green: 0.978, blue: 0.978, alpha: 1)
        button.layer.cornerRadius = 18.5
        button.setImage(UIImage(named: "filterIcon"), for: .normal)
        return button
    }()
    
    private let distanceButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.198, green: 0.203, blue: 0.222, alpha: 1)   // 선택된 상태 배경색
        button.layer.cornerRadius = 18.5
        button.setTitle("거리", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)  // 선택된 상태 글씨 색상
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return button
    }()
    
    let breedButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.978, green: 0.978, blue: 0.978, alpha: 1)
        button.layer.cornerRadius = 18.5
        button.setTitle("견종", for: .normal)
        button.setTitleColor(UIColor(red: 0.365, green: 0.373, blue: 0.404, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return button
    }()
    
    let matchStatusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.978, green: 0.978, blue: 0.978, alpha: 1)
        button.layer.cornerRadius = 18.5
        button.setTitle("매칭여부", for: .normal)
        button.setTitleColor(UIColor(red: 0.365, green: 0.373, blue: 0.404, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        // 버튼 추가
        addSubview(filterButton)
        addSubview(distanceButton)
        addSubview(breedButton)
        addSubview(matchStatusButton)
        
        // filterButton 레이아웃 설정
        filterButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(34)
            make.height.equalTo(36)
            make.centerY.equalToSuperview()
        }
        
        // distanceButton 레이아웃 설정
        distanceButton.snp.makeConstraints { make in
            make.leading.equalTo(filterButton.snp.trailing).offset(8)
            make.width.equalTo(60)
            make.height.equalTo(38)
            make.centerY.equalToSuperview()
        }
        
        // breedButton 레이아웃 설정
        breedButton.snp.makeConstraints { make in
            make.leading.equalTo(distanceButton.snp.trailing).offset(8)
            make.width.equalTo(60)
            make.height.equalTo(38)
            make.centerY.equalToSuperview()
        }
        
        // matchStatusButton 레이아웃 설정
        matchStatusButton.snp.makeConstraints { make in
            make.leading.equalTo(breedButton.snp.trailing).offset(8)
            make.width.equalTo(87)
            make.height.equalTo(38)
            make.centerY.equalToSuperview()
        }
    }
}
