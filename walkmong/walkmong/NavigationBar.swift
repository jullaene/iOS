//
//  NavigationBar.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit
extension UIViewController {
    // MARK: - Custom Navigation Bar
    func addNavigationBar(titleText: String = "", showLeftBarButton: Bool, showCloseBarButton: Bool, showRefreshBarButton: Bool) {
        
        let navigationBarView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 76))

        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = titleText
            label.font = .systemFont(ofSize: 20, weight: .semibold)
            label.textColor = .black
            label.textAlignment = .center
            return label
        }()
        //TODO: 버튼 이미지 설정
        navigationBarView.addSubview(titleLabel)
        if showLeftBarButton{
            let leftBarButton: UIButton = {
                let button = UIButton()
                button.setImage(UIImage(), for: .normal)
                return button
            }()
            navigationBarView.addSubview(leftBarButton)
        }
        if showCloseBarButton{
            let closeBarButton: UIButton = {
                let button = UIButton()
                button.setImage(UIImage(), for: .normal)
                return button
            }()
            navigationBarView.addSubview(closeBarButton)
        }else if showRefreshBarButton{
            let refreshBarButton: UIButton = {
                let button = UIButton()
                button.setImage(UIImage(), for: .normal)
                return button
            }()
            navigationBarView.addSubview(refreshBarButton)
        }

        self.navigationItem.titleView = navigationBarView
        self.navigationController?.navigationBar.backgroundColor = .white
      }
}
