//
//  MatchingApplyWalkRequestViewSummarizeViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit

final class MatchingApplyWalkRequestViewSummarizeViewController: UIViewController, StepConfigurable {

    private let summarizeView = MatchingApplyWalkRequestViewSummarizeView()

    var stepTitle: String { "산책 요청 최종 확인" }
    var buttonTitle: String { "다음으로" }
    var isButtonEnabled: Bool { true }
    var isWarningVisible: Bool { true }
    var buttonStateChanged: ((Bool) -> Void)?

    override func loadView() {
        self.view = summarizeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
