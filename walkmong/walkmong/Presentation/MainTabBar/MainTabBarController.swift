import UIKit
import SnapKit

final class MainTabBarController: UITabBarController {
    
    var dimView: UIView!
    var dropdownView: DropdownView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDimView()
        setupDropdownView()
        self.view.bringSubviewToFront(dimView)
        configureCustomTabBar()
        setViewControllers(configureTabBars(), animated: true)
        setTabBarUI()
    }
    
    private func setupDimView() {
        dimView = UIView()
        dimView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        dimView.isHidden = true
        view.addSubview(dimView)
        dimView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideFilterAndDropdown))
        dimView.addGestureRecognizer(tapGesture)
    }
    
    private func setupDropdownView() {
        dropdownView = DropdownView()
        dropdownView.isHidden = true
        view.addSubview(dropdownView)
    }
    
    @objc private func hideFilterAndDropdown() {
        (selectedViewController as? MatchingViewController)?.hideFilterAndDropdown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func configureCustomTabBar() {
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
    }
    
    private func configureTabBars() -> [UIViewController] {
        return [
            createMatchingViewController(),
            createMatchingStateViewController(),
            createTalkViewController(),
            createMypageViewController()
        ]
    }
    
    private func createMatchingViewController() -> UIViewController {
        let vc = MatchingViewController()
        vc.view.backgroundColor = .white
        vc.tabBarItem = UITabBarItem(title: "산책 구하기", image: UIImage(named: "MatchingApplyProcedureIcon"), tag: 0)
        return UINavigationController(rootViewController: vc)
    }
    
    private func createMatchingStateViewController() -> UIViewController {
        let vc = MatchingStatusListViewController()
        vc.view.backgroundColor = .white
        vc.tabBarItem = UITabBarItem(title: "매칭 현황", image: UIImage(named: "MatchingStateIcon"), tag: 1)
        return vc
    }
    
    private func createTalkViewController() -> UIViewController {
        let vc = WalktalkListViewController()
        vc.view.backgroundColor = .white
        vc.tabBarItem = UITabBarItem(title: "워크톡", image: UIImage(named: "WalkMongTalkIcon"), tag: 2)
        return vc
    }
    
    private func createMypageViewController() -> UIViewController {
        let vc = MyPageViewController()
        vc.view.backgroundColor = .white
        vc.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "MypageIcon"), tag: 3)
        return vc
    }
    
    private func setTabBarUI() {
        tabBar.backgroundColor = UIColor(white: 1, alpha: 0.75)
        tabBar.tintColor = UIColor.mainBlack
        tabBar.unselectedItemTintColor = UIColor(red: 0.719, green: 0.737, blue: 0.761, alpha: 1)
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurEffectView.alpha = 0.9
        blurEffectView.frame = tabBar.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBar.insertSubview(blurEffectView, at: 0)

        let border = UIView()
        border.backgroundColor = UIColor(white: 0, alpha: 0.05)
        tabBar.addSubview(border)
        border.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    private class CustomTabBar: UITabBar {
        var customHeight: CGFloat = 86
        
        override var intrinsicContentSize: CGSize {
            var size = super.intrinsicContentSize
            size.height = customHeight
            return size
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            guard let superview = self.superview else { return }
            var newFrame = frame
            newFrame.size.height = customHeight
            newFrame.origin.y = superview.frame.height - customHeight
            frame = newFrame
        }
    }
}
