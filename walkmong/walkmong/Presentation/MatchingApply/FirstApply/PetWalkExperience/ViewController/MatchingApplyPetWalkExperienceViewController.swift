//
//  MatchingApplyPetWalkExperienceViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/10/25.
//

import UIKit

final class MatchingApplyPetWalkExperienceViewController: UIViewController {
    
    private let matchingApplyPetWalkExperienceView = MatchingApplyPetWalkExperienceView()

    private var request: PostDogExperienceRequest!
    
    init(request: PostDogExperienceRequest) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        request.dogWalkingExperienceYn = experience ? "Y" : "N"
        request.availabilityWithSize = breed
        let nextVC = MatchingApplyFirstIntroductionViewController(request: request)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
