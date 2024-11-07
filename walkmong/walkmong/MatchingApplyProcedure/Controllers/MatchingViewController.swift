import UIKit
import SnapKit

class MatchingViewController: UIViewController {

    private var dimView: UIView!
    private var dropdownView: DropdownView!
    private var locationSelectView: UIView! // MatchingView의 locationSelectView에 접근하기 위한 변수
    private var locationLabel: UILabel! // MatchingView의 locationLabel 접근 변수

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

        // MatchingView에서 locationSelectView와 locationLabel 가져오기
        self.locationSelectView = matchingView.locationSelectView
        self.locationLabel = matchingView.locationLabel
        
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
        dropdownView.delegate = self
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

// DropdownViewDelegate를 통해 선택된 동네를 업데이트합니다.
extension MatchingViewController: DropdownViewDelegate {
    func didSelectLocation(_ location: String) {
        locationLabel.text = location // 선택된 동네를 locationLabel에 업데이트
        dropdownView.updateSelection(selectedLocation: location) // DropdownView의 상태 업데이트
        hideDropdownView()
    }
}
