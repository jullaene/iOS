//
//  RegisterPetMessageViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/14/25.
//

import UIKit
import SnapKit

final class RegisterPetMessageViewController: UIViewController {
    
    private let mainView = RegisterPetMessageView()
    private var keyboardManager: KeyboardEventManager?
    private var containerBottomConstraint: Constraint?
    private var requestData: PostDogInfoRequest
    
    init(requestData: PostDogInfoRequest){
        self.requestData = requestData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setConstraints()
        addCustomNavigationBar(titleText: "반려견 등록하기", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        addProgressBar(currentStep: 3, totalSteps: 3)
        dismissKeyboardOnTap()
        mainView.delegate = self
        keyboardManager = KeyboardEventManager(delegate: self)
    }
    
    private func addSubview() {
        view.addSubview(mainView)
    }
    
    private func setConstraints() {
        mainView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(156)
            containerBottomConstraint = make.bottom.equalToSuperview().constraint
        }
    }

}

extension RegisterPetMessageViewController: KeyboardObserverDelegate {
    func keyboardWillShow(keyboardHeight: CGFloat) {
        containerBottomConstraint?.update(offset: -keyboardHeight)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func keyboardWillHide() {
        containerBottomConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

}

extension RegisterPetMessageViewController: RegisterPetMessageViewDelegate {
    func didTapNextButton(walkRequest: String, walkNote: String, additionalRequest: String) {
        self.requestData.walkRequest = walkRequest
        self.requestData.walkNote = walkNote
        self.requestData.additionalRequest = additionalRequest
        Task {
            //TODO: API 호출
            let prevVC = MatchingApplyWalkRequestDogProfileSelectionViewController()
            self.navigationController?.popToViewController(prevVC, animated: true)
        }
    }
}
