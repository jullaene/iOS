//
//  DogProfileViewController.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit
import SnapKit

class DogProfileViewController: UIViewController {

    // MARK: - Properties
    private let dogProfileView = DogProfileView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavigationBar()
        setupUI()
        configureDogProfileView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(dogProfileView)
        dogProfileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(121) // 네비게이션 바 높이만큼 아래로
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupCustomNavigationBar() {
        addCustomNavigationBar(
            titleText: "프로필",
            showLeftBackButton: true,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false
        )
    }

    private func configureDogProfileView() {
        let imageNames = ["puppyImage01", "sampleImage"]
        dogProfileView.configure(with: imageNames)
    }
}
