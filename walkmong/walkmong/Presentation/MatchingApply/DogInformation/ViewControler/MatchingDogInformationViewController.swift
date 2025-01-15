import UIKit
import Moya
import SnapKit

class MatchingDogInformationViewController: UIViewController {
    private var boardId: Int?
    private var boardDetail: BoardDetail?
    private let dogInfoView = MatchingDogInformationView()
    private let boardService = BoardService()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupProfileDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        toggleTabBar(isHidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        toggleTabBar(isHidden: false)
    }
    
    // MARK: - Public Methods
    func configure(with boardId: Int) {
        self.boardId = boardId
        fetchBoardDetails(for: boardId)
    }
}

// MARK: - Network Calls
extension MatchingDogInformationViewController {
    private func fetchBoardDetails(for boardId: Int) {
        showLoading()
        _Concurrency.Task {
            do {
                let response = try await boardService.getBoardDetail(boardId: boardId)
                self.boardDetail = response
                DispatchQueue.main.async { [weak self] in
                    self?.updateUI()
                }
            } catch {
                print("🚨Failed to fetch board details error: \(error)")
            }
            hideLoading()
        }
    }
}

// MARK: - UI Setup
extension MatchingDogInformationViewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(dogInfoView)
        dogInfoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(52)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupNavigationBar() {
        addCustomNavigationBar(
            titleText: nil,
            showLeftBackButton: true,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false
        )
    }

    private func toggleTabBar(isHidden: Bool) {
        tabBarController?.tabBar.isHidden = isHidden
    }

    private func setupProfileDelegate() {
        dogInfoView.setProfileDelegate(self)
    }
}

// MARK: - UI Updates
extension MatchingDogInformationViewController {
    private func updateUI() {
        guard let detail = boardDetail else { return }
        configureDogInfoView(with: detail)
    }

    private func configureDogInfoView(with detail: BoardDetail) {
        dogInfoView.configureImages(with: [detail.dogProfile])
        
        dogInfoView.getProfileFrame().updateProfileView(
            dogName: detail.dogName,
            dogSize: detail.dogSize,
            breed: detail.breed,
            weight: detail.weight,
            dogAge: detail.dogAge,
            dongAddress: detail.dongAddress,
            distance: detail.distance,
            dogGender: detail.dogGender
        )
        
        dogInfoView.setWalkInfoDelegate(
            date: detail.date ?? "",
            startTime: detail.startTime,
            endTime: detail.endTime,
            locationNegotiationYn: detail.locationNegotiationYn,
            suppliesProvidedYn: "Y",
            preMeetAvailableYn: detail.preMeetAvailableYn
        )
        
        dogInfoView.setRelatedInfoDetails(
            walkNote: detail.walkNote,
            walkRequest: detail.walkRequest ?? "N/A",
            additionalRequest: detail.additionalRequest ?? ""
        )
        
        dogInfoView.setOwnerInfoDetails(
            ownerProfile: detail.ownerProfile,
            ownerName: detail.ownerName,
            ownerAge: detail.ownerAge,
            ownerGender: detail.ownerGender,
            ownerRate: detail.ownerRate ?? 0.0,
            dongAddress: detail.dongAddress,
            distance: detail.distance
        )
    }
}

// MARK: - ProfileViewDelegate
extension MatchingDogInformationViewController: ProfileViewDelegate {
    func profileButtonTapped() {
        navigateToDogProfile()
    }
}

// MARK: - Navigation
extension MatchingDogInformationViewController {
    private func navigateTo(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func navigateToDogProfile() {
        guard let boardDetail = boardDetail else { return }
        let dogProfileVC = DogProfileViewController()
        dogProfileVC.configure(with: boardDetail.dogId)
        navigateTo(dogProfileVC)
    }
}
