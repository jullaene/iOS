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
            fetchBoardDetailData(boardId: data.boardId ?? 1)
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
        fetchBoardDetailData(boardId: data.boardId ?? 1)
    }

    private func fetchBoardDetailData(boardId: Int) {

        isLoading = true

        networkManager.fetchBoardDetail(boardId: boardId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let detail):
                    self?.boardDetail = detail
                    print("BoardDetail fetched successfully: \(detail)")
                    self?.updateUI(with: detail)
                case .failure(let error):
                    print("Error fetching BoardDetail for boardId \(boardId): \(error)")
                    
                    if case let DecodingError.dataCorrupted(context) = error {
                        print("Decoding error: \(context.debugDescription)")
                        print("Coding Path: \(context.codingPath)")
                    } else if case let DecodingError.keyNotFound(key, context) = error {
                        print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
                        print("Coding Path: \(context.codingPath)")
                    } else if case let DecodingError.typeMismatch(type, context) = error {
                        print("Type '\(type)' mismatch: \(context.debugDescription)")
                        print("Coding Path: \(context.codingPath)")
                    } else if case let DecodingError.valueNotFound(value, context) = error {
                        print("Value '\(value)' not found: \(context.debugDescription)")
                        print("Coding Path: \(context.codingPath)")
                    } else {
                        print("Unknown decoding error: \(error)")
                    }
                }
            }
        }
    }

    private func updateUI(with detail: BoardDetail) {
        print("Updating UI with fetched data:")
        print("dogProfile: \(detail.dogProfile ?? "defaultImage")")
        print("ownerProfile: \(detail.ownerProfile ?? "defaultProfileImage")")

        dogInfoView.configureImages(with: [detail.dogProfile ?? "defaultImage"])

        // 공개 메소드를 통해 profileFrame 업데이트
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
            date: detail.date ?? "00",
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
            ownerProfile: detail.ownerProfile ?? "defaultProfileImage",
            ownerName: detail.ownerName,
            ownerAge: detail.ownerAge,
            ownerGender: detail.ownerGender,
            ownerRate: detail.ownerRate ?? 1.0,
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
