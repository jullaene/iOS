//
//  MatchingApplyPetExperienceViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/10/25.
//

import UIKit

final class MatchingApplyPetExperienceViewController: UIViewController {
    
    private let matchingApplyPetExperienceView = MatchingApplyPetExperienceView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
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
        print(experienceYn)
    }
}
