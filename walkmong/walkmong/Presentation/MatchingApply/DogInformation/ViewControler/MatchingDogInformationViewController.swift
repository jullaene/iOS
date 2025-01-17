import UIKit
import Moya
import SnapKit

class MatchingDogInformationViewController: UIViewController {
    private var boardId: Int?
    private var boardDetail: BoardDetail?
    private let dogInfoView = MatchingDogInformationView()
    private let boardService = BoardService()
    private let memberService = MemberService()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupProfileDelegate()
        setupApplyWalkDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    private func setupApplyWalkDelegate() {
        dogInfoView.delegate = self
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
            walkRequest: detail.walkRequest ?? "",
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

extension MatchingDogInformationViewController: MatchingDogInformationViewDelegate {
    func applyWalkButtonTapped() {
        print("🚀 applyWalkButtonTapped called")
        guard let boardDetail = boardDetail else {
            print("❌ boardDetail is nil")
            return
        }

        _Concurrency.Task {
            do {
                if let memberWalkingResponse = try await fetchMemberWalkingResponse() {
                    print("✅ User profile: \(memberWalkingResponse)")
                    guard let boardId = boardId else { return }
                    let detailSelectVC = MatchingApplyDetailSelectViewController(boardDetail: boardDetail, boardId: boardId)
                    detailSelectVC.configure(with: boardDetail)
                    navigateTo(detailSelectVC)
                } else {
                    showAlertForProfileRegistration()
                }
            } catch {
                print("🚨 Error fetching MemberWalkingResponse: \(error)")
                showAlertForProfileRegistration()
            }
        }
    }
    
    private func isUserProfileRegistered() -> Bool {
        let memberService = MemberService()
        var isRegistered = false
        let semaphore = DispatchSemaphore(value: 0)
        
        _Concurrency.Task {
            do {
                let response = try await memberService.getMemberWalking()
                isRegistered = response.data.dogOwnership != .none
            } catch {
                print("🚨 Error fetching MemberWalkingResponse: \(error)")
            }
            semaphore.signal()
        }
        semaphore.wait()
        
        return isRegistered
    }
    
    private func fetchMemberWalkingResponse() async throws -> MemberWalkingItem? {
        do {
            let response = try await memberService.getMemberWalking()
            return response.data
        } catch {
            throw error
        }
    }
    
    private func showAlertForProfileRegistration() {
        let alertBuilder = CustomAlertViewController.CustomAlertBuilder(viewController: self)
        alertBuilder
            .setTitleState(.useTitleAndSubTitle)
            .setButtonState(.doubleButton)
            .setTitleText("내 프로필이 없어요")
            .setSubTitleText("산책 지원 전에 먼저\n본인 프로필을 등록하시겠어요?")
            .setLeftButtonTitle("취소")
            .setRightButtonTitle("등록하기")
            .setRightButtonAction { [weak self] in
                guard let self = self else { return }
                let petExperienceVC = MatchingApplyPetExperienceViewController()
                self.navigateTo(petExperienceVC)
            }
            .showAlertView()
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
