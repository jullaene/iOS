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
    private let memberService = MemberService()
    
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
        fetchUserProfile()
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
    
    private func fetchUserProfile() {
        Task {
            do {
                let response = try await memberService.getMemberWalking()
                let memberWalking = response.data
                DispatchQueue.main.async {
                    self.myPageView.updateProfileName(memberWalking.name)
                    self.myPageView.updateProfileImage(memberWalking.profile)
                    
                    self.myPageView.updateWalkInfo(
                        dogOwnership: memberWalking.dogOwnership,
                        dogWalkingExperience: memberWalking.dogWalkingExperience,
                        availabilityWithSize: memberWalking.availabilityWithSize
                    )
                }
            } catch {
                print("Error fetching user profile: \(error)")
            }
        }
    }
}

extension MyPageViewController: MyPagePetViewDelegate {
    func didSelectPet(dogId: Int) {
        let dogProfileVC = DogProfileViewController()
        dogProfileVC.configure(with: dogId)
        navigationController?.pushViewController(dogProfileVC, animated: true)
    }
}
