//
//  DogProfileViewController.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit
import SnapKit

class DogProfileViewController: BaseViewController {

    // MARK: - Properties
    private let dogProfileView = DogProfileView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavigationBar()
        setupUI()
        configureDogProfileImages()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(dogProfileView)
        dogProfileView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupCustomNavigationBar() {
        customNavigationBar.setTitle("프로필")
        customNavigationBar.addBackButtonAction(target: self, action: #selector(customBackButtonTapped))
    }

    private func configureDogProfileImages() {
        let imageNames = ["puppyImage01", "sampleImage"]
        dogProfileView.configureImages(with: imageNames)
    }

    // MARK: - Actions
    @objc private func customBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
