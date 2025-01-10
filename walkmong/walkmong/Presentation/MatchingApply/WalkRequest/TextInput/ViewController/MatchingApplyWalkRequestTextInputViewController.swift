//
//  MatchingApplyWalkRequestTextInputViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit

final class MatchingApplyWalkRequestTextInputViewController: UIViewController, StepConfigurable {

    private let textInputView = MatchingApplyWalkRequestTextInputView()
    private var allRequiredFieldsFilled: Bool = false {
        didSet {
            buttonStateChanged?(allRequiredFieldsFilled)
        }
    }

    var stepTitle: String { "산책자에게 전달할 메시지" }
    var buttonTitle: String { "다음으로" }
    var isButtonEnabled: Bool { allRequiredFieldsFilled }
    var isWarningVisible: Bool { false }
    var buttonStateChanged: ((Bool) -> Void)?

    override func loadView() {
        self.view = textInputView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        textInputView.textViewDidUpdate = { [weak self] isAllFilled in
            self?.allRequiredFieldsFilled = isAllFilled
        }
    }
}
