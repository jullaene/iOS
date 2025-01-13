//
//  RegisterPetSocialityViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/14/25.
//

import UIKit
import SnapKit

final class RegisterPetSocialityViewController: UIViewController {

    private let mainView = RegisterPetSocialityView()
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
        addProgressBar(currentStep: 2, totalSteps: 3)
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

extension RegisterPetSocialityViewController: KeyboardObserverDelegate {
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

extension RegisterPetSocialityViewController: RegisterPetSocialityViewDelegate {
    func didTapNextButton(barking: String, bite: String, friendly: String) {
        self.requestData.barking = barking
        self.requestData.bite = bite
        self.requestData.friendly = friendly
        let nextVC = RegisterPetMessageViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
