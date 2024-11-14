//
//  MatchingApplyFinalViewController.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit

class MatchingApplyFinalViewController: UIViewController {

    private let finalView = MatchingApplyFinalView()
    private var checked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray100
        setUI()
    }
    
    private func setUI() {
        addSubView()
        setConstraints()
        finalView.delegate = self
        addCustomNavigationBar(titleText: "산책 지원하기", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false, backgroundColor: .gray100)
        addProgressBar(currentStep: 3, totalSteps: 3, backgroundColor: .gray100)
    }
    
    private func addSubView() {
        self.view.addSubview(finalView)
    }
    
    private func setConstraints() {
        finalView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(156)
            make.bottom.equalToSuperview()
        }
    }
}

extension MatchingApplyFinalViewController: MatchingApplyFinalViewDelegate {
    func didCheckedInformation(button: UIButton) {
        self.checked = button.isSelected
    }
    
    func didTapApplyButton() {
        if checked {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
