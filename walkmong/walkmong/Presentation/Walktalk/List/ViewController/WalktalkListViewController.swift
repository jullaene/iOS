//
//  WalktalkListViewController.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit

class WalktalkListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func setUI() {
        addCustomNavigationBar(titleText: "워크톡", showLeftBackButton: false, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
    }
}
