import UIKit
import SnapKit

class MatchingViewController: UIViewController {

    private var matchingFilterView: MatchingFilterView?
    private var dropdownView: DropdownView! {
        return (self.tabBarController as? MainTabBarController)?.dropdownView
    }
    private var locationSelectView: UIView!
    private var locationLabel: UILabel!
    
    var dimView: UIView? {
        return (self.tabBarController as? MainTabBarController)?.dimView
    }
    
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
        
        setupLocationSelectGesture()
    }
    
    private func setupLocationSelectGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDropdownView))
        locationSelectView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func showDropdownView() {
        guard let dropdownView = dropdownView else { return }
        
        dimView?.isHidden = false
        dropdownView.isHidden = false

        dimView?.superview?.bringSubviewToFront(dimView!)
        dimView?.superview?.bringSubviewToFront(dropdownView)
        
        dropdownView.snp.remakeConstraints { make in
            make.width.equalTo(201)
            make.height.equalTo(130)
            make.leading.equalTo(locationSelectView.snp.leading)
            make.top.equalTo(locationSelectView.snp.bottom).offset(10)
        }
    }
    
    @objc private func hideDropdownView() {
        dropdownView?.isHidden = true
        dimView?.isHidden = matchingFilterView == nil // 다른 요소가 없으면 dimView 숨김
    }

    @objc func hideFilterAndDropdown() {
        hideDropdownView()
        hideMatchingFilterView()
    }

    private func showMatchingFilterView() {
        guard matchingFilterView == nil else { return }
        
        let parentView = self.tabBarController?.view ?? self.view

        let filterView = MatchingFilterView()
        filterView.layer.cornerRadius = 30
        filterView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        parentView?.addSubview(filterView)
        self.matchingFilterView = filterView
        
        filterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(605)
            make.bottom.equalToSuperview().offset(605)
        }
        
        parentView?.layoutIfNeeded()

        dimView?.isHidden = false
        dimView?.superview?.bringSubviewToFront(dimView!) // dimView를 최상단으로 위치시키기
        parentView?.bringSubviewToFront(filterView)       // matchingFilterView를 dimView 위로 가져오기
        
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
            self.dimView?.isHidden = true
        })
    }
}

// DropdownViewDelegate를 통해 선택된 동네 업데이트
extension MatchingViewController: DropdownViewDelegate {
    func didSelectLocation(_ location: String) {
        locationLabel.text = location
        dropdownView?.updateSelection(selectedLocation: location)
        hideDropdownView()
    }
}
