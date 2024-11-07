import UIKit
import SnapKit

class MatchingViewController: UIViewController {

    private var matchingFilterView: MatchingFilterView?
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
        matchingView.filterButtonAction = { [weak self] in
            self?.showMatchingFilterView()
        }
        
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

    private func showMatchingFilterView() {
        guard matchingFilterView == nil else { return } // 이미 뷰가 있다면 추가하지 않음

        let filterView = MatchingFilterView()
        filterView.layer.cornerRadius = 30
        filterView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.view.addSubview(filterView)
        self.matchingFilterView = filterView
        
        // 초기 위치: 화면 아래쪽
        filterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(605)
            make.bottom.equalToSuperview().offset(605) // 화면 아래에 위치
        }
        
        // 레이아웃 강제 업데이트 (초기 상태 적용)
        self.view.layoutIfNeeded()
        
        // 애니메이션으로 스르륵 올라오는 효과
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
            filterView.snp.updateConstraints { make in
                make.bottom.equalToSuperview() // 화면 하단에 위치
            }
            self.view.layoutIfNeeded() // 레이아웃 변경 즉시 반영
        })
    }
    
    private func hideMatchingFilterView() {
        guard let filterView = matchingFilterView else { return }
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn], animations: {
            filterView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(605) // 다시 화면 아래로 내려감
            }
            self.view.layoutIfNeeded()
        }, completion: { _ in
            filterView.removeFromSuperview()
            self.matchingFilterView = nil
        })
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
