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
    private var dogId: Int?
    private let dogService = DogService()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavigationBar()
        setupUI()
        fetchDogProfileIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = false
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
        guard let dogId = dogId else { return }
        Task {
            do {
                let response = try await dogService.getDogProfile(dogId: dogId)
                DispatchQueue.main.async {
                    self.updateDogProfileView(with: response.data)
                }
            } catch {
                print("Failed to fetch dog profile: \(error)")
            }
        }
    }


    private func updateDogProfileView(with dogProfile: DogInfo) {
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
