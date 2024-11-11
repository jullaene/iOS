import UIKit
import SnapKit

class MatchingDogInformationViewController: BaseViewController {
    
    // MARK: - Properties
    private var matchingData: MatchingData?
    private let dogInfoView = MatchingDogInformationView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavigationBar()
        setupUI()
        if let data = matchingData {
            dogInfoView.configureImages(with: [data.dogProfile, "sampleImage"])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
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
    
    // MARK: - 화면 전환 메서드
    func navigateToMatchingApplyDetailSelect() {
        let detailViewController = MatchingApplyDetailSelectViewController()
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: - Actions
    @objc private func customBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
