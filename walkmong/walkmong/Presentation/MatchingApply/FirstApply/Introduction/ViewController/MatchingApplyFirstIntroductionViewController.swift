//
//  MatchingApplyFirstIntroductionViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/10/25.
//

import UIKit

final class MatchingApplyFirstIntroductionViewController: UIViewController {

    private let matchingApplyFirstIntroductionView = MatchingApplyFirstIntroductionView()
    private let service = MemberService()
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
        view.addSubview(matchingApplyFirstIntroductionView)
    }
    
    private func setConstraints() {
        matchingApplyFirstIntroductionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(156)
        }
    }
    
    private func setUI() {
        addSubview()
        setConstraints()
        addCustomNavigationBar(titleText: "", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        addProgressBar(currentStep: 3, totalSteps: 7)
        matchingApplyFirstIntroductionView.delegate = self
        dismissKeyboardOnTap()
    }
}

extension MatchingApplyFirstIntroductionViewController: MatchingApplyFirstIntroductionViewDelegate {
    func didTapNextButton(_ message: String) {
        showLoading()
        defer { hideLoading() }
        Task {
            do {
                request.introduction = message
                _ = try await service.postDogExperience(request: request)
                self.navigationController?.popToRootViewController(animated: true)
            }catch let error as NetworkError {
                hideLoading()
                CustomAlertViewController
                    .CustomAlertBuilder(viewController: self)
                    .setTitleState(.useTitleAndSubTitle)
                    .setTitleText("프로필 등록 실패")
                    .setSubTitleText(error.message)
                    .setButtonState(.singleButton)
                    .setSingleButtonTitle("돌아가기")
                    .showAlertView()
            }
        }
    }
}
