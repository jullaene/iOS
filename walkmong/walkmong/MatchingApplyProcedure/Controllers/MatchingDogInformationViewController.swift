import UIKit
import SnapKit

class MatchingDogInformationViewController: UIViewController, ProfileViewDelegate, MatchingDogInformationViewDelegate {

    // MARK: - Properties
    private var matchingData: MatchingData?
    private let dogInfoView = MatchingDogInformationView()
    private var boardDetail: BoardDetail?
    private let networkManager = NetworkManager()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavigationBar()
        setupUI()
        configureProfileDelegate()
        configureMatchingData()
        configureViewDelegate()
        fetchBoardDetailData(boardId: 1)
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
        matchingData = data
    }

    private func fetchBoardDetailData(boardId: Int) {
        let networkManager = NetworkManager()
        networkManager.fetchBoardDetail(boardId: boardId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    print("Fetched BoardDetail: \(detail)") // 데이터 전체 확인

                    if detail.startTime.isEmpty || detail.endTime.isEmpty {
                        print("Warning: Start or End Time is missing!")
                    }

                    self?.dogInfoView.getProfileView().updateProfileView(
                        dogName: detail.dogName,
                        dogSize: detail.dogSize,
                        breed: detail.breed,
                        weight: detail.weight,
                        dogAge: detail.dogAge,
                        dongAddress: detail.dongAddress,
                        distance: detail.distance,
                        dogGender: detail.dogGender
                    )
                    self?.updateUI(with: detail)
                    
                case .failure(let error):
                    print("Error fetching BoardDetail: \(error)")
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
            ownerRate: detail.ownerRate,
            dongAddress: detail.dongAddress,
            distance: detail.distance
        )
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
        let dogProfileVC = DogProfileViewController()
        navigationController?.pushViewController(dogProfileVC, animated: true)
    }
}
