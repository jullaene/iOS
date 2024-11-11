import UIKit
import SnapKit

class MatchingDogInformationViewController: BaseViewController, ProfileViewDelegate {
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupCustomNavigationBar() {
        customNavigationBar.setTitle("")
        customNavigationBar.addBackButtonAction(target: self, action: #selector(customBackButtonTapped))
    }
    
    // MARK: - Private Methods
    private func configureProfileDelegate() {
        dogInfoView.setProfileDelegate(self)
    }
    
    private func configureMatchingData() {
        if let data = matchingData {
            dogInfoView.configureImages(with: [data.dogProfile, "sampleImage"])
        }
    }
    
    private func toggleTabBar(isHidden: Bool) {
        tabBarController?.tabBar.isHidden = isHidden
    }

    // MARK: - ProfileViewDelegate
    func profileButtonTapped() {
        navigateToDogProfile()
    }

    // MARK: - Navigation
    private func navigateToDogProfile() {
        let dogProfileVC = DogProfileViewController()
        navigationController?.pushViewController(dogProfileVC, animated: true)
    }
    
    // MARK: - Actions
    @objc private func customBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
