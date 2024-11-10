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

        let customTabBar = CustomTabBar()
        self.setValue(customTabBar, forKey: "tabBar")
        
        self.setViewControllers(configureTabBars(), animated: true)
        setUI()
    }
    
    private func setupDimView() {
        dimView = UIView()
        dimView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        dimView.isHidden = true
        self.view.addSubview(dimView)
        
        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideFilterAndDropdown))
        dimView.addGestureRecognizer(tapGesture)
    }
    
    private func setupDropdownView() {
        dropdownView = DropdownView()
        dropdownView.isHidden = true
        self.view.addSubview(dropdownView)
    }
    
    @objc private func hideFilterAndDropdown() {
        if let matchingVC = self.selectedViewController as? MatchingViewController {
            matchingVC.hideFilterAndDropdown()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private class CustomTabBar: UITabBar {
        var customHeight: CGFloat = 96
        
        override var intrinsicContentSize: CGSize {
            var size = super.intrinsicContentSize
            size.height = customHeight
            return size
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            var newFrame = self.frame
            newFrame.size.height = customHeight
            newFrame.origin.y = self.superview!.frame.height - customHeight
            self.frame = newFrame
        }
    }
    
    private func configureTabBars() -> [UIViewController] {
        let matchingVC = MatchingViewController()
        matchingVC.view.backgroundColor = .white
        matchingVC.tabBarItem = UITabBarItem(title: "산책 구하기", image: UIImage(named: "MatchingApplyProcedureIcon"), tag: 0)
        
        let matchingStateVC = UIViewController()
        matchingStateVC.view.backgroundColor = .white
        matchingStateVC.tabBarItem = UITabBarItem(title: "매칭 현황", image: UIImage(named: "MatchingStateIcon"), tag: 1)
        
        let talkVC = UIViewController()
        talkVC.view.backgroundColor = .white
        talkVC.tabBarItem = UITabBarItem(title: "워크톡", image: UIImage(named: "WalkMongTalkIcon"), tag: 2)
        
        let mypageVC = UIViewController()
        mypageVC.view.backgroundColor = .white
        mypageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "MypageIcon"), tag: 3)
        
        return [matchingVC, matchingStateVC, talkVC, mypageVC]
    }
    
    private func setUI() {
        tabBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
        tabBar.tintColor = UIColor.mainBlack
        tabBar.unselectedItemTintColor = UIColor(red: 0.719, green: 0.737, blue: 0.761, alpha: 1)
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.9
        blurEffectView.frame = tabBar.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        tabBar.insertSubview(blurEffectView, at: 0)

        let border = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        border.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        tabBar.addSubview(border)
    }
}
