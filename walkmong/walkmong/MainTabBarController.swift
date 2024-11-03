import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CustomTabBar로 탭바 교체
        let customTabBar = CustomTabBar()
        self.setValue(customTabBar, forKey: "tabBar")
        
        self.setViewControllers(configureTabBars(), animated: true)
        setUI()
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
            
            // 탭바의 frame을 직접 설정
            var newFrame = self.frame
            newFrame.size.height = customHeight
            newFrame.origin.y = self.superview!.frame.height - customHeight
            self.frame = newFrame
        }
    }
    
    private func configureTabBars() -> [UIViewController] {
        let matchingVC = UIViewController()
        matchingVC.view.backgroundColor = .white
        matchingVC.tabBarItem = UITabBarItem(title: "산책 구하기", image: UIImage(named: "MatchingApplyProcedureIcon"), tag: 0)
        
        let matchingStateVC = UIViewController()
        matchingStateVC.view.backgroundColor = .white
        matchingStateVC.tabBarItem = UITabBarItem(title: "매칭 현황", image: UIImage(named: "MatchingStateIcon"), tag: 1)
        
        let talkVC = UIViewController()
        talkVC.view.backgroundColor = .white
        talkVC.tabBarItem = UITabBarItem(title: "워크멍톡", image: UIImage(named: "WalkMongTalkIcon"), tag: 2)
        
        let mypageVC = UIViewController()
        mypageVC.view.backgroundColor = .white
        mypageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "MypageIcon"), tag: 3)
        
        return [matchingVC, matchingStateVC, talkVC, mypageVC]
    }
    
    private func setUI() {
        tabBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
        tabBar.tintColor = UIColor(red: 0.081, green: 0.081, blue: 0.076, alpha: 1)
        tabBar.unselectedItemTintColor = UIColor(red: 0.719, green: 0.737, blue: 0.761, alpha: 1)
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        let border = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        border.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        tabBar.addSubview(border)
    }
}
