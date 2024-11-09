//
//  AppDelegate.swift
//  walkmong
//
//  Created by 신호연 on 11/2/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // 앱 종료 시 UserDefaults에 저장된 필터 데이터 삭제
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "MatchingFilter")
        userDefaults.removeObject(forKey: "BreedFilter")
    }


}

