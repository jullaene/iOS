//
//  OtherUserProfileViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/7/25.
//

import UIKit

final class OtherUserProfileViewController: UIViewController {
    
    private let otherUserProfileView = OtherUserProfileView()
    
    override func loadView() {
        self.view = UIView()
        view.addSubview(otherUserProfileView)
        
        otherUserProfileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        otherUserProfileView.contentViewSection.petView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateReviewData()
    }
    
    private func updateReviewData() {
        otherUserProfileView.contentViewSection.reviewView.updateChartData(scores: [5.0, 5.0, 5.0, 5.0, 5.0])
    }
}

extension OtherUserProfileViewController: MyPagePetViewDelegate {
    func didSelectPet(dogId: Int) {
        let dogProfileVC = DogProfileViewController()
        dogProfileVC.configure(with: dogId)
        navigationController?.pushViewController(dogProfileVC, animated: true)
    }
}
