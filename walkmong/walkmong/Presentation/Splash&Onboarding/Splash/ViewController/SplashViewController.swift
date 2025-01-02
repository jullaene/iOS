//
//  SplashViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/2/25.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Properties
    private let splashView = SplashView()
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = splashView
        view.backgroundColor = .mainBlue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
