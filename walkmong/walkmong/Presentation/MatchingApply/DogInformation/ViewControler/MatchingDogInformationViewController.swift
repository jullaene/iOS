import UIKit
import Moya
import SnapKit

class MatchingDogInformationViewController: UIViewController, ProfileViewDelegate, MatchingDogInformationViewDelegate {
    private var boardId: Int?
    
    // MARK: - Properties
    private var matchingData: BoardList?
    private let dogInfoView = MatchingDogInformationView()
    private var isLoading: Bool = false
    private var boardDetail: BoardDetail?

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
        showLoading()
        defer { hideLoading() }
        _Concurrency.Task {
            do {
                let service = BoardService()
                let response = try await service.getBoardDetail(boardId: boardId)
                print("✅ API Response: \(response)")
                boardDetail = response
                self.updateUI(with: response)
            } catch {
                print("❌ 게시글 상세 정보 조회 실패: \(error.localizedDescription)")
                if let apiError = error as? MoyaError {
                    switch apiError {
                    case .statusCode(let response):
                        print("❌ Status Code Error: \(response.statusCode)")
                    case .underlying(let nsError, _):
                        print("❌ Underlying Error: \(nsError.localizedDescription)")
                    default:
                        print("❌ Unknown API Error")
                    }
                } else {
                    print("❌ Other Error: \(error)")
                }
            }
        }
    }

    private func updateUI(with detail: BoardDetail) {
        guard let dogProfile = detail.dogProfile else {
            print("❌ Dog profile 이미지가 없음")
            return
        }

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
            ownerRate: detail.ownerRate ?? 0.0,
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
        showLoading()
        defer { hideLoading() }
        _Concurrency.Task {
            let service = MemberService()
            do {
                let response = try await service.getMemberWalking()
                if response.data.dogOwnership.rawValue == "NONE" {
                    let nextVC = MatchingApplyPetExperienceViewController()
                    navigationController?.pushViewController(nextVC, animated: true)
                }else {
                    let detailSelectVC = MatchingApplyDetailSelectViewController()
                    navigationController?.pushViewController(detailSelectVC, animated: true)
                }
            }catch {
                CustomAlertViewController
                    .CustomAlertBuilder(viewController: self)
                    .setTitleState(.useTitleAndSubTitle)
                    .setTitleText("산책 관련 정보 조회 실패")
                    .setSubTitleText("네트워크 상태를 확인해주세요.")
                    .setButtonState(.singleButton)
                    .setSingleButtonTitle("돌아가기")
                    .showAlertView()
            }
        }
    }

    // MARK: - Navigation
    private func navigateToDogProfile() {
        let dogProfileVC = DogProfileViewController()
//        dogProfileVC.configure(with: boardDetail.dogId)
        dogProfileVC.configure(with: 1)
        navigationController?.pushViewController(dogProfileVC, animated: true)
    }
}
