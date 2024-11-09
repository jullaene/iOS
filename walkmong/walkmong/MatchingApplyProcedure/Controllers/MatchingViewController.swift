import UIKit
import SnapKit

class MatchingViewController: UIViewController {
    
    private var matchingFilterView: MatchingFilterView?
    private var dropdownView: DropdownView! {
        let view = (self.tabBarController as? MainTabBarController)?.dropdownView
        view?.delegate = self // 델리게이트 설정
        return view
    }
    private var locationSelectView: UIView!
    private var locationLabel: UILabel!
    private var matchingView: MatchingView!
    
    var dimView: UIView? {
        return (self.tabBarController as? MainTabBarController)?.dimView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white

        matchingView = MatchingView()
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
    
    // MARK: - DropdownView 표시
    @objc private func showDropdownView() {
        guard let dropdownView = dropdownView else { return }
        hideMatchingFilterView() // 다른 뷰가 표시 중이면 숨김
        
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
        dimView?.isHidden = matchingFilterView == nil // 다른 뷰가 없으면 dimView 숨김
    }

    @objc func hideFilterAndDropdown() {
        hideDropdownView()
        hideMatchingFilterView()
    }

    // MARK: - MatchingFilterView 표시
    private func showMatchingFilterView() {
        guard matchingFilterView == nil else { return }
        hideDropdownView()
        
        let parentView = self.tabBarController?.view ?? self.view
        
        let filterView = MatchingFilterView()
        filterView.layer.cornerRadius = 30
        filterView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        filterView.delegate = self // 델리게이트 설정
        
        parentView?.addSubview(filterView)
        self.matchingFilterView = filterView
        
        filterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(605)
            make.bottom.equalToSuperview().offset(605)
        }
        
        parentView?.layoutIfNeeded()
        
        dimView?.isHidden = false
        dimView?.superview?.bringSubviewToFront(dimView!)
        parentView?.bringSubviewToFront(filterView)
        
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

// MARK: - DropdownViewDelegate 구현
extension MatchingViewController: DropdownViewDelegate {
    func didSelectLocation(_ location: String) {
        locationLabel.text = location
        dropdownView?.updateSelection(selectedLocation: location)
        hideDropdownView()
    }
}

// MARK: - MatchingFilterViewDelegate 구현
extension MatchingViewController: MatchingFilterViewDelegate {
    func didApplyFilter(selectedBreeds: [String], matchingStatus: [String]) {
        hideMatchingFilterView()
        
        // MatchingView의 FilterSelectView 상태 업데이트
        let filterSelectView = matchingView.filterSelectView
        
        // 견종 버튼 상태 업데이트
        let hasSelectedBreeds = !selectedBreeds.isEmpty
        updateButtonState(filterSelectView.breedButton, isSelected: hasSelectedBreeds)
        
        // 매칭 여부 버튼 상태 업데이트
        let hasSelectedMatchingStatus = !matchingStatus.isEmpty
        updateButtonState(filterSelectView.matchStatusButton, isSelected: hasSelectedMatchingStatus)
    }
    
    private func updateButtonState(_ button: UIButton, isSelected: Bool) {
        if isSelected {
            button.backgroundColor = UIColor.gray600
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = UIColor.gray100
            button.setTitleColor(UIColor.gray500, for: .normal)
        }
    }
}
