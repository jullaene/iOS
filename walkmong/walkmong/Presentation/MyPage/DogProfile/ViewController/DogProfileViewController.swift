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
    private let networkManager = NetworkManager(useMockData: true)
    private var dogId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavigationBar()
        setupUI()
        fetchDogProfileIfNeeded()
    }

    // MARK: - Configure Method
    func configure(with dogId: Int) {
        self.dogId = dogId
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(dogProfileView)
        dogProfileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(52)
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

    private func fetchDogProfileIfNeeded() {
        guard let dogId = dogId else {
            print("Error: dogId is nil. Cannot fetch dog profile.")
            return
        }
        fetchDogProfile(dogId: dogId)
    }

    private func fetchDogProfile(dogId: Int) {
        networkManager.fetchDogProfile(dogId: dogId) { [weak self] result in
            switch result {
            case .success(let dogProfile):
                DispatchQueue.main.async {
                    self?.updateDogProfileView(with: dogProfile)
                }
            case .failure(let error):
                print("Error fetching dog profile for dogId \(dogId): \(error.localizedDescription)")
            }
        }
    }

    private func updateDogProfileView(with dogProfile: DogProfile) {
        dogProfileView.configureProfileImage(with: [dogProfile.dogProfile])
        dogProfileView.configureBasicInfo(
            dogName: dogProfile.dogName,
            dogGender: dogProfile.dogGender,
            dogAge: dogProfile.dogAge,
            breed: dogProfile.breed,
            weight: dogProfile.weight,
            neuteringYn: dogProfile.neuteringYn
        )
        dogProfileView.configureSocialInfo(
            bite: dogProfile.bite,
            friendly: dogProfile.friendly,
            barking: dogProfile.barking
        )
        dogProfileView.configureVaccinationStatus(rabiesYn: dogProfile.rabiesYn)
    }
}