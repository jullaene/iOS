//
//  MatchingApplyWalkRequestCautionViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit
import SnapKit

final class MatchingApplyWalkRequestCautionViewController: UIViewController, StepConfigurable {

    private let cautionView = MatchingApplyWalkRequestCautionView()

    var stepTitle: String { "주의사항 확인" }
    var buttonTitle: String { "산책 지원하기" }
    var isButtonEnabled: Bool { true }
    var isWarningVisible: Bool { true }
    var buttonStateChanged: ((Bool) -> Void)?

    override func loadView() {
        self.view = cautionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
