import UIKit
import SnapKit

class MatchingDogInformationViewController: UIViewController, ProfileViewDelegate, MatchingDogInformationViewDelegate {

    // MARK: - Properties
    private var matchingData: MatchingData?
    private let dogInfoView = MatchingDogInformationView()
    private var boardDetail: BoardDetail?
    private let networkManager = NetworkManager()
    private var isLoading: Bool = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavigationBar()
        setupUI()
        configureProfileDelegate()
        configureMatchingData()
        configureViewDelegate()
        
        if let data = matchingData {
            fetchBoardDetailData(boardId: data.boardId)
        } else {
            print("Error: matchingData is nil. Cannot fetch board details.")
        }
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
    func configure(with data: MatchingData) {
        self.matchingData = data
        fetchBoardDetailData(boardId: data.boardId)
    }

    private func fetchBoardDetailData(boardId: Int) {

        isLoading = true

        networkManager.fetchBoardDetail(boardId: boardId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let detail):
                    print("Successfully fetched details for boardId: \(boardId)")
                    self?.boardDetail = detail
                    self?.updateUI(with: detail)
                case .failure(let error):
                    print("Error fetching BoardDetail for boardId \(boardId): \(error)")
                }
            }
        }
    }

    private func updateUI(with detail: BoardDetail) {

        dogInfoView.configureImages(with: [detail.dogProfile ?? "defaultImage"])

        dogInfoView.setWalkInfoDelegate(
            date: detail.date,
            startTime: detail.startTime,
            endTime: detail.endTime,
            locationNegotiationYn: detail.locationNegotiationYn,
            suppliesProvidedYn: detail.suppliesProvidedYn,
            preMeetAvailableYn: detail.preMeetAvailableYn
        )
        print("Configured walk info delegate")

        dogInfoView.setRelatedInfoDetails(
            walkNote: detail.walkNote,
            walkRequest: detail.walkRequest,
            additionalRequest: detail.additionalRequest
        )
        print("Configured related info details")

        dogInfoView.setOwnerInfoDetails(
            ownerProfile: detail.ownerProfile ?? "defaultProfileImage",
            ownerName: detail.ownerName,
            ownerAge: detail.ownerAge,
            ownerGender: detail.ownerGender,
            ownerRate: detail.ownerRate,
            dongAddress: detail.dongAddress,
            distance: detail.distance
        )
        print("Configured owner info details")
    }
    
    // MARK: - UI Setup
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
    
    // MARK: - Private Methods
    private func configureProfileDelegate() {
        dogInfoView.setProfileDelegate(self)
    }

    private func configureViewDelegate() {
        dogInfoView.delegate = self
    }
    
    private func configureMatchingData() {
        if let data = matchingData {
            let dogProfile = data.dogProfile ?? "defaultImage"
            dogInfoView.configureImages(with: [dogProfile, "sampleImage"])
        }
    }
    
    private func toggleTabBar(isHidden: Bool) {
        tabBarController?.tabBar.isHidden = isHidden
    }

    // MARK: - ProfileViewDelegate
    func profileButtonTapped() {
        navigateToDogProfile()
    }

    // MARK: - MatchingDogInformationViewDelegate
    func applyWalkButtonTapped() {
        let detailSelectVC = MatchingApplyDetailSelectViewController()
        navigationController?.pushViewController(detailSelectVC, animated: true)
    }

    // MARK: - Navigation
    private func navigateToDogProfile() {
        print("Attempting to navigate to DogProfileViewController")
        guard let boardDetail = boardDetail else {
            print("Error: boardDetail is nil. Cannot navigate to dog profile.")
            return
        }

        print("Navigating to DogProfileViewController with dogId: \(boardDetail.dogId)")
        let dogProfileVC = DogProfileViewController()
        dogProfileVC.configure(with: boardDetail.dogId)
        navigationController?.pushViewController(dogProfileVC, animated: true)
    }
}
