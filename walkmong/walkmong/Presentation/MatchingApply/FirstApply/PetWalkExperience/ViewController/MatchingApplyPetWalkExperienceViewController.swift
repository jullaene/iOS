//
//  MatchingApplyPetWalkExperienceViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/10/25.
//

import UIKit

final class MatchingApplyPetWalkExperienceViewController: UIViewController {
    
    private let matchingApplyPetWalkExperienceView = MatchingApplyPetWalkExperienceView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
    }
    private func addSubview() {
        view.addSubview(matchingApplyPetWalkExperienceView)
    }
    
    private func setConstraints() {
        matchingApplyPetWalkExperienceView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(156)
        }
    }
    
    private func setUI() {
        addSubview()
        setConstraints()
        addCustomNavigationBar(titleText: "", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        addProgressBar(currentStep: 2, totalSteps: 7)
        matchingApplyPetWalkExperienceView.delegate = self
    }
}

extension MatchingApplyPetWalkExperienceViewController: MatchingApplyPetWalkExperienceViewDelegate {
    func didTapNextButton(_ experience: Bool, _ breed: String) {
        let nextVC = MatchingApplyFirstIntroductionViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
