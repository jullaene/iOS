//
//  MatchingApplyPetWalkExperienceViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/10/25.
//

import UIKit

final class MatchingApplyPetWalkExperienceViewController: UIViewController {
    
    private let matchingApplyPetWalkExperienceView = MatchingApplyPetWalkExperienceView()

    private let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("건너뛰기", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.mainBlack, for: .normal)
        button.backgroundColor = .clear
        return button
    }()

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
        view.addSubview(skipButton)
        skipButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(22)
            make.centerY.equalTo(view.safeAreaLayoutGuide.snp.top).offset(26)
        }
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    }
    
    @objc private func skipButtonTapped() {
        let nextVC = UIViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension MatchingApplyPetWalkExperienceViewController: MatchingApplyPetWalkExperienceViewDelegate {
    func didTapNextButton(_ experience: Bool, _ breed: String) {
        let nextVC = MatchingApplyFirstIntroductionViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
