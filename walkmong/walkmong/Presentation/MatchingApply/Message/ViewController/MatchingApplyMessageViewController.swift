//
//  MatchingApplyMessageViewController.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit

class MatchingApplyMessageViewController: UIViewController {
    
    let messageView = MatchingApplyMessageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapTextView(_:)))
        view.addGestureRecognizer(tapGesture)
        addCustomNavigationBar(titleText: "산책 지원하기", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        addProgressBar(currentStep: 2, totalSteps: 3)
        addSubviews()
        setConstraints()
        messageView.delegate = self
    }
    
    private func addSubviews(){
        self.view.addSubview(messageView)
    }
    
    private func setConstraints(){
        messageView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(152)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
    @objc private func didTapTextView(_ sender: Any) {
        view.endEditing(true)
    }
}
extension MatchingApplyMessageViewController: MatchingApplyMessageViewDelegate {
    func didTapNextButton() {
        let nextVC = MatchingApplyFinalViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
