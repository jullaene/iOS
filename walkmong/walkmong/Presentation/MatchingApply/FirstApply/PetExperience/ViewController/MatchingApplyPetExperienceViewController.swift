//
//  MatchingApplyPetExperienceViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/10/25.
//

import UIKit

final class MatchingApplyPetExperienceViewController: UIViewController {
        
    private let matchingApplyPetExperienceView = MatchingApplyPetExperienceView()
    
    private var request = PostDogExperienceRequest()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func addSubview() {
        view.addSubview(matchingApplyPetExperienceView)
    }
    
    private func setConstraints() {
        matchingApplyPetExperienceView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(156)
        }
    }
    
    private func setUI() {
        addSubview()
        setConstraints()
        addCustomNavigationBar(titleText: "", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        addProgressBar(currentStep: 1, totalSteps: 7)
        matchingApplyPetExperienceView.delegate = self
    }
}

extension MatchingApplyPetExperienceViewController: MatchingApplyPetExperienceViewDelegate {
    func didSelectExperience(_ experienceYn: String) {
        request.dogOwnershipYn = experienceYn
        let nextVC = MatchingApplyPetWalkExperienceViewController(request: request)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
