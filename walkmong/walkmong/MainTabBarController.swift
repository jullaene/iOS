import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers(configureTabBars(), animated: true)
        setUI()
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
        talkVC.tabBarItem = UITabBarItem(title: "워크멍톡", image: UIImage(named: "WalkMongTalkIcon"), tag: 2)
        
        let mypageVC = UIViewController()
        mypageVC.view.backgroundColor = .white
        mypageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "MypageIcon"), tag: 3)
        
        return [matchingVC, matchingStateVC, talkVC, mypageVC]
    }
    
    private func setUI() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
    }
}
