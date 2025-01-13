import Foundation
import UIKit
import SnapKit
import Moya

class MatchingViewController: UIViewController, MatchingCellDelegate {
    
    private let service = BoardService()
    private let provider = NetworkProvider<BoardAPI>()
    var selectedAddress: String?
    var selectedAddressId: String?
    
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
    private var matchingData: [BoardList] = []
    private var isNavigationBarHidden: Bool = true
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: animated)
        showLoading()
        defer { hideLoading() }
        _Concurrency.Task {
            await getBoardList()
        }
        _Concurrency.Task {
            await getAddressList()
        }
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
        
        matchingView.filterSelectView.delegate = self
        if let savedLocation = UserDefaults.standard.string(forKey: "selectedLocation") {
            matchingView.updateLocationLabel(with: savedLocation)
        }
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
    func didSelectMatchingCell(data: BoardList) {
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
        _Concurrency.Task {
            do {
                let dogList = try await DogService().getDogList()
                let hasDogs = !dogList.data.isEmpty
                
                DispatchQueue.main.async {
                    if hasDogs {
                        self.navigateToWalkRequestViewController()
                    } else {
                        self.showNoDogsAlert()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error fetching dog list: \(error.localizedDescription)")
                    self.showNoDogsAlert()
                }
            }
        }
    }
    
    private func navigateToWalkRequestViewController() {
        guard let dropdownView = dropdownView else { return }
        
        let selectedLocation = dropdownView.selectedLocation
        let selectedAddressId = dropdownView.selectedAddressId
        
        let walkRequestVC = MatchingApplyWalkRequestDogProfileSelectionViewController()
        walkRequestVC.selectedAddress = selectedLocation
        walkRequestVC.selectedAddressId = selectedAddressId
        
        navigationController?.pushViewController(walkRequestVC, animated: true)
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

extension MatchingViewController {
    func getBoardList() async {
        let parameters: [String: String] = [
            "date": "",
            "addressId": "",
            "distance": "",
            "dogSize": "",
            "matchingYn": ""
        ]
        
        do {
            let response = try await service.getBoardList(parameters: parameters)
            DispatchQueue.main.async {
                if response.data.isEmpty {
                    print("No data available.")
                } else {
                    self.matchingData = response.data
                    self.matchingView.updateMatchingCells(with: self.matchingData)
                    print("Data sent to MatchingView: \(self.matchingData)")
                }
            }
        } catch {
            DispatchQueue.main.async {
                print("Error fetching board list: \(error.localizedDescription)")
            }
        }
    }
    
    func getAddressList() async {
        do {
            let response = try await service.getAddressList()
            
            let addressList: [(dongAddress: String, addressId: String)] = response.data.map {
                (dongAddress: $0.dongAddress, addressId: String($0.addressId))
            }
            
            DispatchQueue.main.async {
                self.dropdownView?.updateLocations(locations: addressList)

                let savedLocation = UserDefaults.standard.string(forKey: "selectedLocation") ?? addressList.first?.dongAddress
                if let defaultLocation = savedLocation {
                    self.matchingView.updateLocationLabel(with: defaultLocation)
                    self.dropdownView?.updateSelection(selectedLocation: defaultLocation)
                }
            }
        } catch {
            DispatchQueue.main.async {
                print("Error fetching address list: \(error.localizedDescription)")
            }
        }
    }
}

extension MatchingViewController: FilterSelectViewDelegate {
    func didTapFilterButton() {
        showMatchingFilterView()
    }
}

extension MatchingViewController: DropdownViewDelegate {
    func didSelectLocation(_ location: String) {
        matchingView.updateLocationLabel(with: location)
        dropdownView?.updateSelection(selectedLocation: location)
        hideDropdownView()
        
        UserDefaults.standard.set(location, forKey: "selectedLocation")
    }
}
