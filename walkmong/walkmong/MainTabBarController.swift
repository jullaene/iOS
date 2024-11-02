//
//  MainTabBarController.swift
//  walkmong
//
//  Created by 황채웅 on 11/2/24.
//

import UIKit
final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers(configureTabBars(), animated: true)
        setUI()
    }
    
    private func configureTabBars() -> [UIViewController]{
        //TODO: 뷰와 탭바 아이템 이미지 추가
        return []
    }
    
    private func setUI() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
    }
}
