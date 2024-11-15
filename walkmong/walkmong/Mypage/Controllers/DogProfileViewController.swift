//
//  DogProfileViewController.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit
import SnapKit

class DogProfileViewController: UIViewController {

    private let dogProfileView = DogProfileView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavigationBar()
        setupUI()

        let networkManager = NetworkManager()
        networkManager.fetchDogProfile(dogId: 1) { [weak self] result in
            switch result {
            case .success(let dogProfile):
                DispatchQueue.main.async {
                    self?.dogProfileView.configure(with: [dogProfile.dogProfile])
                    self?.dogProfileView.configureBasicInfo(
                        dogName: dogProfile.dogName,
                        dogGender: dogProfile.dogGender,
                        dogAge: dogProfile.dogAge,
                        breed: dogProfile.breed,
                        weight: dogProfile.weight,
                        neuteringYn: dogProfile.neuteringYn
                    )
                    self?.dogProfileView.configureSocialInfo(
                                       bite: dogProfile.bite,
                                       friendly: dogProfile.friendly,
                                       barking: dogProfile.barking
                                   )
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(dogProfileView)
        dogProfileView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(52)
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
}
