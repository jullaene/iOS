//
//  SceneDelegate.swift
//  walkmong
//
//  Created by 신호연 on 11/2/24.
//

import UIKit
import Security

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let rootViewController = MatchingStatusApplicantDetailViewController()
        window?.rootViewController = rootViewController
        
        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
    }

    
    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
    
    func changeRootViewController(_ viewController: UIViewController, animated: Bool) {
        guard let window = window else { return }
        window.rootViewController = viewController
        
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        }
    }
    
    func logout() {
        do {
            try KeychainManager.deleteTokens()
        } catch {
            if let vc = window?.getViewController() {
                CustomAlertViewController.CustomAlertBuilder(viewController: vc)
                    .setButtonState(.singleButton)
                    .setTitleState(.useTitleAndSubTitle)
                    .setSingleButtonTitle("돌아가기")
                    .setTitleText("오류 발생")
                    .setSubTitleText("알 수 없는 오류가 발생했습니다.\n다시 시도해주세요.")
                    .showAlertView()
                return
            }
        }
        UserDefaults.standard.set(false, forKey: "KEEP_LOGIN")
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let loginViewController = LoginViewController()
            sceneDelegate.changeRootViewController(loginViewController, animated: true)
        }
    }
}
