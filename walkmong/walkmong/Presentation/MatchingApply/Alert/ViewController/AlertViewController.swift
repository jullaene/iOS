//
//  AlertViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit

class AlertViewController: UIViewController {
    
    private let alertView = AlertView()
    private let safeAreaBackgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSafeAreaBackground()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupSafeAreaBackground() {
        safeAreaBackgroundView.backgroundColor = .gray300
        self.view.addSubview(safeAreaBackgroundView)
        safeAreaBackgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    private func setupNavigationBar() {
        addCustomNavigationBar(
            titleText: "알림",
            showLeftBackButton: true,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false,
            backgroundColor: .gray300
        )
    }
}
