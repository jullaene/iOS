//
//  MatchingApplyFirstIntroductionViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/10/25.
//

import UIKit

final class MatchingApplyFirstIntroductionViewController: UIViewController {

    private let matchingApplyFirstIntroductionView = MatchingApplyFirstIntroductionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
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
        //TODO: 산책 추가 정보 등록 API 호출
        self.navigationController?.popToRootViewController(animated: true)
    }
}
