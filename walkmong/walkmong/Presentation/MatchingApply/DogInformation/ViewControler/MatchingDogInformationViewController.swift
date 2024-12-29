import UIKit
import SnapKit

class MatchingDogInformationViewController: UIViewController, ProfileViewDelegate, MatchingDogInformationViewDelegate {

    // MARK: - Properties
    private var matchingData: MatchingData?
    private let dogInfoView = MatchingDogInformationView()
    private var boardDetail: BoardDetail?
    private var isLoading: Bool = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavigationBar()
        setupUI()
        configureProfileDelegate()
        configureMatchingData()
        configureViewDelegate()

        guard let data = matchingData else {
            print("Error: matchingData is nil. Cannot fetch board details.")
            return
        }
        fetchBoardDetailData(boardId: data.boardId ?? 1)
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

    }

    private func updateUI(with detail: BoardDetail) {
        dogInfoView.configureImages(with: [detail.dogProfile ?? "defaultImage"])

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
            dogInfoView.configureImages(with: [dogProfile])
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
        guard let boardDetail = boardDetail else {
            print("Error: boardDetail is nil. Cannot navigate to dog profile.")
            return
        }

        let dogProfileVC = DogProfileViewController()
        dogProfileVC.configure(with: boardDetail.dogId)
        navigationController?.pushViewController(dogProfileVC, animated: true)
    }

    // MARK: - Error Handling
    private func handleDecodingError(_ error: Error, boardId: Int) {
        print("Error fetching BoardDetail for boardId \(boardId): \(error)")

        if let decodingError = error as? DecodingError {
            switch decodingError {
            case .dataCorrupted(let context):
                print("Decoding error: \(context.debugDescription)")
                print("Coding Path: \(context.codingPath)")
            case .keyNotFound(let key, let context):
                print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
                print("Coding Path: \(context.codingPath)")
            case .typeMismatch(let type, let context):
                print("Type '\(type)' mismatch: \(context.debugDescription)")
                print("Coding Path: \(context.codingPath)")
            case .valueNotFound(let value, let context):
                print("Value '\(value)' not found: \(context.debugDescription)")
                print("Coding Path: \(context.codingPath)")
            default:
                print("Unknown decoding error: \(error)")
            }
        }
    }
}
