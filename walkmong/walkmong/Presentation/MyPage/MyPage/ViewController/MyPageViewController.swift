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
                    
                    let radarScores: [CGFloat] = [
                        CGFloat(memberWalking.photoSharing),
                        CGFloat(memberWalking.attitude),
                        CGFloat(memberWalking.communication),
                        CGFloat(memberWalking.timePunctuality),
                        CGFloat(memberWalking.taskCompletion)
                    ]
                    self.myPageView.contentViewSection.reviewView.updateWalkerReviewCount(memberWalking.walkerReviewCount)
                    self.myPageView.contentViewSection.reviewView.updateWalkerParticipantCount(memberWalking.walkerReviewCount)
                    self.myPageView.contentViewSection.reviewView.updateOwnerParticipantCount(memberWalking.ownerReviewCount)
                    self.myPageView.contentViewSection.reviewView.updateChartData(scores: radarScores)
                    let averageScore = radarScores.reduce(0, +) / CGFloat(radarScores.count)
                    self.myPageView.contentViewSection.reviewView.updateStarRating(averageScore: averageScore)
                    self.myPageView.contentViewSection.reviewView.configureKeywords(
                        name: memberWalking.name,
                        tags: memberWalking.tags
                    )
                    self.myPageView.contentViewSection.reviewView.updateOwnerReviewSection(goodPercent: CGFloat(memberWalking.goodPercent) / 100, participantCount: memberWalking.ownerReviewCount)
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
