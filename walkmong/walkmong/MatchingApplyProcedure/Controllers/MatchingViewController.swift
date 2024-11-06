import UIKit
import SnapKit

class MatchingViewController: UIViewController {

    private var dimView: UIView!
    private var dropdownView: DropdownView!
    private var locationSelectView: UIView! // MatchingView의 locationSelectView에 접근하기 위한 변수

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 바 숨기기
        self.navigationController?.navigationBar.isHidden = true

        // 배경 색상 설정
        self.view.backgroundColor = .white

        // MatchingView 추가
        let matchingView = MatchingView()
        self.view.addSubview(matchingView)

        matchingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // MatchingView에서 locationSelectView 가져오기
        self.locationSelectView = matchingView.locationSelectView
        
        setupDimView()
        setupDropdownView()
        setupLocationSelectGesture()
    }
    
    private func setupDimView() {
        dimView = UIView()
        dimView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        dimView.isHidden = true
        self.view.addSubview(dimView)
        
        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideDropdownView))
        dimView.addGestureRecognizer(tapGesture)
    }
    
    private func setupDropdownView() {
        dropdownView = DropdownView()
        dropdownView.isHidden = true
        self.view.addSubview(dropdownView)
        
        dropdownView.snp.makeConstraints { make in
            make.width.equalTo(201)
            make.height.equalTo(130)
            make.leading.equalTo(locationSelectView.snp.leading)
            make.top.equalTo(locationSelectView.snp.bottom).offset(10)
        }
    }
    
    private func setupLocationSelectGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDropdownView))
        locationSelectView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func showDropdownView() {
        dimView.isHidden = false
        dropdownView.isHidden = false
    }
    
    @objc private func hideDropdownView() {
        dimView.isHidden = true
        dropdownView.isHidden = true
    }
}
