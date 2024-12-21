//
//  WalktalkListViewController.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit

class WalktalkListViewController: UIViewController {
    
    private let walktalkListView = WalktalkListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(walktalkListView)
        walktalkListView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(52)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        addCustomNavigationBar(titleText: "워크톡", showLeftBackButton: false, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
    }
}
