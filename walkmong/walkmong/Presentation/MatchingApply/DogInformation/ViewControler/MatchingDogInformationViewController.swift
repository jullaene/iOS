import UIKit
import Moya
import SnapKit

class MatchingDogInformationViewController: UIViewController {
    private var boardId: Int?
    
    // MARK: - Properties
    private var matchingData: BoardList?
    private let dogInfoView = MatchingDogInformationView()
    private var isLoading: Bool = false
    private var boardDetail: BoardDetail?
    private let boardService = BoardService()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavigationBar()
        setupUI()
        configureProfileDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        toggleTabBar(isHidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
                self.updateUI(with: response)
            } catch {
                print("🚨fetchBoardDetails error: \(error)")
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
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(52)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupCustomNavigationBar() {
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

    private func configureProfileDelegate() {
        dogInfoView.setProfileDelegate(self)
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

// MARK: - Helper Methods
extension MatchingDogInformationViewController {
    private func updateUI(with detail: BoardDetail) {
        let dogProfile = detail.dogProfile
        
        dogInfoView.configureImages(with: [dogProfile])
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
            walkRequest: detail.walkRequest,
            additionalRequest: detail.additionalRequest
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
