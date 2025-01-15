//
//  MatchingApplyPetExperienceViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/10/25.
//

import UIKit

final class MatchingApplyPetExperienceViewController: UIViewController {
    
    private var boardDetail: BoardDetail?
    
    private let matchingApplyPetExperienceView = MatchingApplyPetExperienceView()
    
    func configure(with boardDetail: BoardDetail) {
        self.boardDetail = boardDetail
    }

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
        let nextVC = MatchingApplyPetWalkExperienceViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
