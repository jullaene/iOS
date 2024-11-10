import UIKit
import SnapKit

class MatchingViewController: UIViewController, MatchingFilterViewDelegate {
    // MARK: - Properties
    private var matchingFilterView: MatchingFilterView?
    private var locationSelectView: UIView!
    private var matchingView: MatchingView!
    
    private var dropdownView: DropdownView! {
        let view = (self.tabBarController as? MainTabBarController)?.dropdownView
        view?.delegate = self
        return view
    }
    
    private var dimView: UIView? {
        return (self.tabBarController as? MainTabBarController)?.dimView
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
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
        
        locationSelectView = matchingView.locationSelectView
        
        // 프로토콜을 통해 locationText 가져오기
        let currentLocation = (matchingView as MatchingViewLocationProvider).locationText
        print("Current Location: \(currentLocation)")
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDropdownView))
        locationSelectView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - DropdownView Logic
    @objc private func showDropdownView() {
        guard let dropdownView = dropdownView else { return }
        hideMatchingFilterView()
        
        updateDimViewVisibility(isHidden: false)
        dropdownView.isHidden = false
        bringViewToFront([dimView, dropdownView])
        
        dropdownView.snp.remakeConstraints { make in
            make.width.equalTo(201)
            make.height.equalTo(130)
            make.leading.equalTo(locationSelectView.snp.leading)
            make.top.equalTo(locationSelectView.snp.bottom).offset(10)
        }
    }
    
    @objc private func hideDropdownView() {
        dropdownView?.isHidden = true
        updateDimViewVisibility(isHidden: matchingFilterView == nil)
    }
    
    // MARK: - MatchingFilterView Logic
    private func showMatchingFilterView() {
        guard matchingFilterView == nil else { return }
        hideDropdownView()
        
        let parentView = self.tabBarController?.view ?? self.view
        let filterView = MatchingFilterView()
        filterView.layer.cornerRadius = 30
        filterView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        filterView.delegate = self
        
        parentView?.addSubview(filterView)
        self.matchingFilterView = filterView
        
        filterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(605)
            make.bottom.equalToSuperview().offset(605)
        }
        
        parentView?.layoutIfNeeded()
        updateDimViewVisibility(isHidden: false)
        bringViewToFront([dimView, filterView])
        
        animateConstraints {
            filterView.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
            }
        }
    }
    
    private func hideMatchingFilterView() {
        guard let filterView = matchingFilterView else { return }
        guard let tabBarView = self.tabBarController?.view else { return }
        
        animateConstraints {
            filterView.snp.updateConstraints { make in
                make.bottom.equalTo(tabBarView.snp.bottom).offset(605)
            }
        } completion: { _ in
            filterView.removeFromSuperview()
            self.matchingFilterView = nil
            self.updateDimViewVisibility(isHidden: true)
        }
    }
    
    @objc func hideFilterAndDropdown() {
        hideDropdownView()
        hideMatchingFilterView()
    }
    
    // MARK: - UI Helpers
    private func updateDimViewVisibility(isHidden: Bool) {
        dimView?.isHidden = isHidden
    }
    
    private func bringViewToFront(_ views: [UIView?]) {
        views.forEach { view in
            view?.superview?.bringSubviewToFront(view!)
        }
    }
    
    private func animateConstraints(_ animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: animations, completion: completion)
    }
}

// MARK: - DropdownViewDelegate
extension MatchingViewController: DropdownViewDelegate {
    func didSelectLocation(_ location: String) {
        print("Selected Location: \(location)")
        matchingView.updateLocationLabel(with: location)
        dropdownView?.updateSelection(selectedLocation: location)
        hideDropdownView()
    }
}

// MARK: - MatchingFilterViewDelegate
extension MatchingViewController {
    func didApplyFilter(selectedBreeds: [String], matchingStatus: [String]) {
        print("Selected Breeds: \(selectedBreeds)")
        print("Selected Matching Status: \(matchingStatus)")
        
        // FilterSelectView 업데이트
        let filterView = matchingView.filterSelectView
        updateFilterButtonState(filterView.breedButton, isSelected: !selectedBreeds.isEmpty)
        updateFilterButtonState(filterView.matchStatusButton, isSelected: !matchingStatus.isEmpty)
        
        hideMatchingFilterView()
    }
    
    private func updateFilterButtonState(_ button: UIButton, isSelected: Bool) {
        button.backgroundColor = isSelected ? .gray600 : .gray100
        button.setTitleColor(isSelected ? .white : .gray500, for: .normal)
    }
}
