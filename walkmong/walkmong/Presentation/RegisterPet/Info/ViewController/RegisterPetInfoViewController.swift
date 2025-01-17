//
//  RegisterPetInfoViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/14/25.
//

import UIKit
import SnapKit

final class RegisterPetInfoViewController: UIViewController {

    private let mainView = RegisterPetInfoView()
    private var keyboardManager: KeyboardEventManager?
    private var containerBottomConstraint: Constraint?
    private var requestData = PostDogInfoRequest()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setConstraints()
        addCustomNavigationBar(titleText: "반려견 등록하기", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        addProgressBar(currentStep: 1, totalSteps: 3)
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

extension RegisterPetInfoViewController: KeyboardObserverDelegate {
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

extension RegisterPetInfoViewController: RegisterPetInfoViewDelegate {
    func didTapNextButton(name: String, dogSize: String, profile: UIImage, gender: String, birthYear: String, breed: String, weight: String, neuteringYn: String, rabiesYn: String, adultYn: String) {
        self.requestData.name = name
        self.requestData.dogSize = dogSize
        self.requestData.profile = profile
        self.requestData.gender = gender
        self.requestData.birthYear = birthYear
        self.requestData.breed = breed
        self.requestData.weight = weight
        self.requestData.neuteringYn = neuteringYn
        self.requestData.rabiesYn = rabiesYn
        self.requestData.adultYn = adultYn
        let nextVC = RegisterPetSocialityViewController(requestData: self.requestData)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
