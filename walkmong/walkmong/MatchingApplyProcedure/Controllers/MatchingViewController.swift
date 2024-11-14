import Foundation
import UIKit
import SnapKit
import Moya

class MatchingViewController: UIViewController, MatchingFilterViewDelegate, MatchingCellDelegate {

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
    fileprivate var matchingData: [MatchingData] = []
    private var isNavigationBarHidden: Bool = true
    private let boardProvider = MoyaProvider<BoardAPI>()

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: animated)
        updateUILayout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        setupUI()
        setupGestures()
        fetchMatchingData()
        fetchAddressList()
    }

    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .white
        matchingView = MatchingView()
        matchingView.filterButtonAction = { [weak self] in
            self?.showMatchingFilterView()
        }
        self.view.addSubview(matchingView)
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
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
    }

    // MARK: - Fetch Data
    private func fetchMatchingData() {
        
        boardProvider.request(.getBoardList(date: nil, addressId: nil, distance: nil, dogSize: nil, matchingYn: nil)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    
                    // keyDecodingStrategy 설정 (필요 시 사용)
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    // null 값을 안전하게 처리
                    let boardResponse = try decoder.decode(BoardResponse.self, from: response.data)
                    self?.matchingData = boardResponse.data
                    
                    DispatchQueue.main.async {
                        self?.updateMatchingView()
                    }
                } catch {
                    print("디코딩 실패: \(error)")
                }
            case .failure(let error):
                print("API 호출 실패: \(error.localizedDescription)")
            }
        }
    }

    private func fetchAddressList() {
        boardProvider.request(.getAddressList) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let addressResponse = try JSONDecoder().decode(AddressResponse.self, from: response.data)
                    let locations = addressResponse.data.map { $0.dongAddress }
                    DispatchQueue.main.async {
                        self?.dropdownView?.updateLocations(locations: locations)
                    }
                } catch {
                    print("디코딩 실패: \(error)")
                }
            case .failure(let error):
                print("API 호출 실패: \(error.localizedDescription)")
            }
        }
    }

    private func updateMatchingView() {
        guard let selectedDate = matchingView.selectedDate else { return }
        
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
        filterView.layer.cornerRadius = 30
        filterView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        filterView.delegate = self
        self.view.addSubview(filterView)
        self.matchingFilterView = filterView
        filterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(605)
            make.bottom.equalToSuperview().offset(605)
        }
        self.view.layoutIfNeeded()
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
        animateConstraints {
            filterView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(605)
            }
        } completion: { _ in
            filterView.removeFromSuperview()
            self.matchingFilterView = nil
            self.updateDimViewVisibility(isHidden: true)
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
        matchingView.updateLocationLabel(with: location)
        dropdownView?.updateSelection(selectedLocation: location)
        hideDropdownView()
    }
}

// MARK: - MatchingFilterViewDelegate
extension MatchingViewController {
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
