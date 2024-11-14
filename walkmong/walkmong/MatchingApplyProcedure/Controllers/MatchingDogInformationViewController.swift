import UIKit
import SnapKit

class MatchingDogInformationViewController: UIViewController, ProfileViewDelegate, MatchingDogInformationViewDelegate {

    // MARK: - Properties
    private var matchingData: MatchingData?
    private let dogInfoView = MatchingDogInformationView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavigationBar()
        setupUI()
        configureProfileDelegate()
        configureMatchingData()
        configureViewDelegate()
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
