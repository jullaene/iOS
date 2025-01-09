//
//  MatchingApplyWalkRequestInformationInputViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit

final class MatchingApplyWalkRequestInformationInputViewController: UIViewController, StepConfigurable {

    private let informationInputView = MatchingApplyWalkRequestInformationInputView()
    private var allFieldsFilled: Bool = true {
        didSet {
            buttonStateChanged?(allFieldsFilled)
        }
    }

    var stepTitle: String { "산책 정보 작성하기" }
    var buttonTitle: String { "다음으로" }
    var isButtonEnabled: Bool { allFieldsFilled }
    var isWarningVisible: Bool { false }
    var buttonStateChanged: ((Bool) -> Void)?

    override func loadView() {
        self.view = informationInputView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        informationInputView.delegate = self
    }
}

extension MatchingApplyWalkRequestInformationInputViewController: MatchingApplyWalkRequestInformationInputViewDelegate {
    func updateActionButtonState(isEnabled: Bool) {
        allFieldsFilled = isEnabled
    }
}
