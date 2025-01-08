//
//  WalkRequestViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/4/25.
//

import UIKit

struct StepData {
    let middleTitle: String
    let buttonText: String
    let additionalView: UIView
    let backgroundColor: UIColor
}

final class WalkRequestViewController: UIViewController {

    private let walkRequestView = WalkRequestView()
    private var currentStep: Int = 1
    private let totalSteps: Int = 5
    
    private let stepData: [StepData] = [
        StepData(
            middleTitle: "산책이 필요한 반려견을 선택해요.",
            buttonText: "다음으로",
            additionalView: WalkRequestDogProfileSelectionView(),
            backgroundColor: .white
        ),
        StepData(
            middleTitle: "산책 정보 작성하기",
            buttonText: "다음으로",
            additionalView: WalkRequestInformationInputView(),
            backgroundColor: .white
        ),
        StepData(
            middleTitle: "산책자에게 전달할 메시지",
            buttonText: "다음으로",
            additionalView: WalkRequestTextInputView(),
            backgroundColor: .white
        ),
        StepData(
            middleTitle: "산책 요청 최종 확인",
            buttonText: "다음으로",
            additionalView: WalkRequestViewSummarizeView(),
            backgroundColor: .gray100
        ),
        StepData(
            middleTitle: "주의사항 확인",
            buttonText: "산책 지원하기",
            additionalView: WalkRequestCautionView(),
            backgroundColor: .gray100
        )
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? MainTabBarController {
            tabBarController.tabBar.isHidden = false
        }
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func loadView() {
        super.loadView()
        self.view = walkRequestView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        updateViewForCurrentStep()
        configureActionsForStep(currentStep)
        setupDismissKeyboardGesture()
        walkRequestView.scrollView.delegate = self
        if let step1View = stepData[0].additionalView as? WalkRequestDogProfileSelectionView {
            step1View.delegate = self
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        addCustomNavigationBar(
            titleText: "산책 지원 요청하기",
            showLeftBackButton: true,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false,
            backgroundColor: .clear
        )
        
        addProgressBar(currentStep: currentStep, totalSteps: totalSteps)
    }
    
    private func setupActions() {
        walkRequestView.actionButton.addTarget(self, action: #selector(handleActionButtonTapped), for: .touchUpInside)
        updateActionButtonState(isEnabled: false, style: .light)
    }
    
    // MARK: - Button Actions
    @objc private func handleActionButtonTapped() {
        guard walkRequestView.actionButton.isEnabled else {
            return
        }
        
        if currentStep < totalSteps {
            currentStep += 1
            updateViewForCurrentStep()
            configureActionsForStep(currentStep)
        } else {
            print("완료 처리")
        }
    }
    
    // MARK: - Step Updates
    private func updateViewForCurrentStep() {
        guard currentStep <= totalSteps else { return }
        let data = stepData[currentStep - 1]
        
        view.backgroundColor = data.backgroundColor
        walkRequestView.middleTitleLabel.text = data.middleTitle
        walkRequestView.actionButton.setTitle(data.buttonText, for: .normal)
        
        walkRequestView.updateContentView(with: data.additionalView)
        addProgressBar(currentStep: currentStep, totalSteps: totalSteps)
        
        if currentStep == 4 {
            walkRequestView.showWarningSection()
            walkRequestView.updateWarningText("산책 지원 요청 내용을 확인했습니다.")
            walkRequestView.actionButton.isEnabled = false
            walkRequestView.actionButton.setStyle(.light, type: .large)
        } else if currentStep == 5 {
            walkRequestView.showWarningSection()
            walkRequestView.updateWarningText("주의사항을 모두 확인했습니다.")
            walkRequestView.actionButton.isEnabled = false
            walkRequestView.actionButton.setStyle(.light, type: .large)
        } else {
            walkRequestView.hideWarningSection()
        }
    }
    
    private func updateContentView(with additionalView: UIView) {
        walkRequestView.contentView.subviews.forEach {
            if $0 != walkRequestView.middleTitleLabel && !$0.isKind(of: UICollectionView.self) {
                $0.removeFromSuperview()
            }
        }
        
        walkRequestView.contentView.addSubview(additionalView)
        
        additionalView.snp.makeConstraints { make in
            make.top.equalTo(walkRequestView.middleTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualToSuperview()
        }

    }
    
    private func configureActionsForStep(_ step: Int) {
        switch step {
        case 1:
            configureStep1Actions()
        case 2:
            configureStep2Actions()
        case 3:
            configureStep3Actions()
        default:
            break
        }
    }
    
    private func configureStep1Actions() {
        guard let step1View = stepData[0].additionalView as? WalkRequestDogProfileSelectionView else { return }

        step1View.onDogSelected = { [weak self] isDogSelected in
            guard let self = self else { return }
            
            if isDogSelected {
                print("반려견이 선택되었습니다.")
                self.updateActionButtonState(isEnabled: true, style: .dark)
            } else {
                print("DogProfileViewController로 이동합니다.")
                let profileVC = DogProfileViewController()
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
        }
    }
    
    private func configureStep2Actions() {
        guard let step2View = stepData[1].additionalView as? WalkRequestInformationInputView else { return }
        
        step2View.calendarView.reloadCalendar()
        step2View.delegate = self
    }
    
    private func configureStep3Actions() {
        guard let step3View = stepData[2].additionalView as? WalkRequestTextInputView else { return }

        updateActionButtonState(isEnabled: false, style: .light)

        step3View.textViewDidUpdate = { [weak self] isAllRequiredFieldsFilled in
            guard let self = self else { return }
            self.updateActionButtonState(isEnabled: isAllRequiredFieldsFilled, style: isAllRequiredFieldsFilled ? .dark : .light)
        }
    }
    
    private func configurePetCellActions(for petCell: PetProfileCell) {
        petCell.didTapProfileButton = { [weak self] in
            guard let self = self else { return }
            print("프로필 버튼 클릭")
            let profileVC = DogProfileViewController()
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
        
        petCell.didTapAddPetCell = { [weak self] in
            guard let self = self else { return }
            print("반려견 등록하기 셀 클릭")
            // let registerVC = RegisterPetViewController()
            // self.navigationController?.pushViewController(registerVC, animated: true)
        }
        
    }
    
    func didTapProfileButton(for profile: PetProfile) {
        print("프로필 버튼 클릭: \(profile.name)")
        let profileVC = DogProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    // MARK: - Action Button Updates
    private func updateActionButtonState(isEnabled: Bool, style: UIButton.ButtonStyle) {
        walkRequestView.actionButton.isEnabled = isEnabled
        walkRequestView.actionButton.setStyle(style, type: .large)
        walkRequestView.actionButton.setStyle(isEnabled ? .dark : .light, type: .large)
    }
    
    func updateActionButtonState(isEnabled: Bool) {
        walkRequestView.actionButton.isEnabled = isEnabled
        walkRequestView.actionButton.setStyle(isEnabled ? .dark : .light, type: .large)
    }
    
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismisskeyboard))
        walkRequestView.scrollView.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }

    @objc private func dismisskeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let keyboardHeight = keyboardFrame.height

        walkRequestView.scrollView.contentInset.bottom = keyboardHeight + 20
        walkRequestView.scrollView.scrollIndicatorInsets.bottom = keyboardHeight + 20
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        walkRequestView.scrollView.contentInset.bottom = 0
        walkRequestView.scrollView.scrollIndicatorInsets.bottom = 0
    }
}

// MARK: - WalkRequestDogProfileSelectionViewDelegate
extension WalkRequestViewController: WalkRequestDogProfileSelectionViewDelegate {
    func onDogSelected(isDogSelected: Bool) {
        if isDogSelected {
            print("반려견이 선택되었습니다.")
            updateActionButtonState(isEnabled: true, style: .dark)
        } else {
            print("DogProfileViewController로 이동합니다.")
            let profileVC = DogProfileViewController()
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

// MARK: - WalkRequestInformationInputViewDelegate
extension WalkRequestViewController: WalkRequestInformationInputViewDelegate {
    func didUpdateWalkInfo() {
        print("산책 정보가 업데이트되었습니다.")
        updateActionButtonState(isEnabled: true, style: .dark)
    }
}

// MARK: - UIScrollViewDelegate
extension WalkRequestViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
