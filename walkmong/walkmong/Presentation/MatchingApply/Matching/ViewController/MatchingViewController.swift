import Foundation
import UIKit
import SnapKit
import Moya

class MatchingViewController: UIViewController, MatchingCellDelegate {

    // MARK: - Properties
    private var matchingFilterView: MatchingFilterView?
    private var locationSelectView: UIView!
    private var matchingView: MatchingView!
    private var dropdownView: DropdownView? {
        let view = (self.tabBarController as? MainTabBarController)?.dropdownView
        view?.delegate = self
        return view
    }
    private var dimView: UIView? {
        return (self.tabBarController as? MainTabBarController)?.dimView
    }
    private var matchingData: [MatchingData] = []
    private var isNavigationBarHidden: Bool = true

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: animated)
        updateUILayout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        setupUI()
        setupGestures()
        fetchMatchingData()
        fetchAddressList()
        updateMatchingView()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        matchingView = MatchingView()
        matchingView.filterButtonAction = { [weak self] in
            self?.showMatchingFilterView()
        }
        view.addSubview(matchingView)
        updateUILayout()
        locationSelectView = matchingView.locationSelectView
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDropdownView))
        locationSelectView.addGestureRecognizer(tapGesture)
    }

    private func updateUILayout() {
        matchingView.snp.remakeConstraints { make in
            if isNavigationBarHidden {
                make.edges.equalToSuperview()
            } else {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
    }

    // MARK: - Fetch Data
    private func fetchMatchingData() {
    }

    private func fetchAddressList() {
    }

    private func updateMatchingView() {
        guard let selectedDate = matchingView.selectedDate else {
            print("No selected date available")
            return
        }
        matchingView.updateMatchingCells(with: matchingData)
        for cell in matchingView.matchingCells {
            cell.delegate = self
            if let data = cell.matchingData {
                cell.configureDateLabel(
                    selectedDate: selectedDate,
                    startTime: data.startTime,
                    endTime: data.endTime
                )
            }
        }
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

        let filterView = MatchingFilterView()
        filterView.delegate = self
        matchingFilterView = filterView

        if let window = UIApplication.shared.connectedScenes.first(where: { $0 is UIWindowScene }) as? UIWindowScene,
           let rootWindow = window.windows.first {
            rootWindow.addSubview(filterView)
        }

        filterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(572)
            make.bottom.equalToSuperview().offset(572)
        }
        
        updateDimViewVisibility(isHidden: false)
        filterView.animateShow(withDuration: 0.4, offset: 0, cornerRadius: 30)
    }

    private func hideMatchingFilterView() {
        guard let filterView = matchingFilterView else { return }
        
        filterView.animateHide(withDuration: 0.4, offset: 572) { [weak self] finished in
            if finished {
                filterView.removeFromSuperview()
                self?.matchingFilterView = nil
                self?.updateDimViewVisibility(isHidden: true)
            }
        }
    }

    // MARK: - MatchingCellDelegate
    func didSelectMatchingCell(data: MatchingData) {
        let detailViewController = MatchingDogInformationViewController()
        detailViewController.configure(with: data)
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    @objc func hideFilterAndDropdown() {
        hideDropdownView()
        hideMatchingFilterView()
    }

    // MARK: - UI Helpers
    private func updateDimViewVisibility(isHidden: Bool) {
        dimView?.isHidden = isHidden
        if !isHidden {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideFilterAndDropdown))
            dimView?.addGestureRecognizer(tapGesture)
        } else {
            dimView?.gestureRecognizers?.forEach { dimView?.removeGestureRecognizer($0) }
        }
    }

    private func bringViewToFront(_ views: [UIView?]) {
        views.forEach { $0?.superview?.bringSubviewToFront($0!) }
    }

    private func animateConstraints(_ animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: animations, completion: completion)
    }
    
    func navigateToWalkRequestView() {
        // 서버에서 반려견 조회 (현재 주석 처리)
        // 예: let hasDogs = fetchDogProfiles() > 0
        let hasDogs = true // 서버가 동작하지 않으므로 임시값 사용

        if hasDogs {
            let walkRequestVC = WalkRequestViewController()
            navigationController?.pushViewController(walkRequestVC, animated: true)
        } else {
            showNoDogsAlert()
        }
    }
    
    private func showNoDogsAlert() {
        let alertBuilder = CustomAlertViewController.CustomAlertBuilder(viewController: self)
            .setTitleState(.useTitleAndSubTitle)
            .setButtonState(.doubleButton)
            .setTitleText("등록된 반려견이 없어요")
            .setSubTitleText("산책 지원 요청을 위해 반려견 프로필을 먼저 등록하시겠어요?")
            .setLeftButtonTitle("취소")
            .setRightButtonTitle("등록하기")
            .setRightButtonAction {
                self.navigateToDogProfileRegistration()
            }
        
        alertBuilder.showAlertView()
    }
    
    private func navigateToDogProfileRegistration() {
        /// 반려견 등록하기 페이지
//        let dogProfileVC = DogProfileRegistrationViewController()
//        navigationController?.pushViewController(dogProfileVC, animated: true)
    }
}

extension MatchingViewController: MatchingFilterViewDelegate {
    func didApplyFilter(selectedBreeds: [String], matchingStatus: [String]) {
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

extension MatchingViewController: DropdownViewDelegate {
    func didSelectLocation(_ location: String) {
        matchingView.updateLocationLabel(with: location)
        dropdownView?.updateSelection(selectedLocation: location)
        hideDropdownView()
    }
}
