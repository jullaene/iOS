//
//  MyPageViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/11/24.
//

import UIKit

class MyPageViewController: UIViewController {
    
    private let myPageView = MyPageView()
    private let dogService = DogService()
    
    override func loadView() {
        self.view = UIView()
        view.addSubview(myPageView)
        
        myPageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        myPageView.contentViewSection.petView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDogList()
    }
    
    private func fetchDogList() {
        Task {
            do {
                let response = try await dogService.getDogList()
                let petProfiles = response.data.map { item in
                    PetProfile(
                        dogId: item.dogId,
                        imageURL: item.dogProfile,
                        name: item.dogName,
                        details: "\(item.dogSize.localizedDogSize()) · \(item.breed) · \(Int(item.weight))kg",
                        gender: item.dogGender
                    )
                }
                updatePetView(with: petProfiles)
            } catch {
                print("Error fetching dog list: \(error)")
            }
        }
    }
    
    private func updatePetView(with petProfiles: [PetProfile]) {
        myPageView.contentViewSection.petView.update(with: petProfiles)
    }
}

extension MyPageViewController: MyPagePetViewDelegate {
    func didSelectPet(dogId: Int) {
        let dogProfileVC = DogProfileViewController()
        dogProfileVC.configure(with: dogId)
        navigationController?.pushViewController(dogProfileVC, animated: true)
    }
}
