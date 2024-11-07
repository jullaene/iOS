import UIKit
import SnapKit

class MatchingViewController: UIViewController {

    private var matchingFilterView: MatchingFilterView?
    private var dimView: UIView!
    private var dropdownView: DropdownView!
    private var locationSelectView: UIView!
    private var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white

        let matchingView = MatchingView()
        matchingView.filterButtonAction = { [weak self] in
            self?.showMatchingFilterView()
        }
        
        self.view.addSubview(matchingView)

        matchingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.locationSelectView = matchingView.locationSelectView
        self.locationLabel = matchingView.locationLabel
        
        setupDimView()
        setupDropdownView()
        setupLocationSelectGesture()
    }
    
    private func setupDimView() {
        let parentView = self.tabBarController?.view ?? self.view // TabBarController가 없으면 self.view 사용

        dimView = UIView()
        dimView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        dimView.isHidden = true
        parentView?.addSubview(dimView) // TabBarController의 view 또는 self.view에 추가
        
        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideFilterAndDropdown))
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
        dropdownView.isHidden = true
        dimView.isHidden = matchingFilterView == nil // 필터 뷰가 없으면 dimView 숨김
    }
    
    @objc private func hideFilterAndDropdown() {
        hideDropdownView()
        hideMatchingFilterView()
    }

    private func showMatchingFilterView() {
        guard matchingFilterView == nil else { return }
        
        let parentView = self.tabBarController?.view ?? self.view // TabBarController가 없으면 self.view 사용

        let filterView = MatchingFilterView()
        filterView.layer.cornerRadius = 30
        filterView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        parentView?.addSubview(filterView) // TabBarController의 view 또는 self.view에 추가
        self.matchingFilterView = filterView
        
        filterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(605)
            make.bottom.equalToSuperview().offset(605) // TabBar와 연결, TabBar가 없어도 동일하게 동작
        }
        
        parentView?.layoutIfNeeded()

        dimView.isHidden = false
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
            filterView.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
            }
            parentView?.layoutIfNeeded()
        })
    }
    
    private func hideMatchingFilterView() {
        guard let filterView = matchingFilterView else { return }
        guard let tabBarView = self.tabBarController?.view else { return }
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn], animations: {
            filterView.snp.updateConstraints { make in
                make.bottom.equalTo(tabBarView.snp.bottom).offset(605)
            }
            tabBarView.layoutIfNeeded()
        }, completion: { _ in
            filterView.removeFromSuperview()
            self.matchingFilterView = nil
            self.dimView.isHidden = true
        })
    }
}

// DropdownViewDelegate를 통해 선택된 동네를 업데이트합니다.
extension MatchingViewController: DropdownViewDelegate {
    func didSelectLocation(_ location: String) {
        locationLabel.text = location
        dropdownView.updateSelection(selectedLocation: location)
        hideDropdownView()
    }
}
