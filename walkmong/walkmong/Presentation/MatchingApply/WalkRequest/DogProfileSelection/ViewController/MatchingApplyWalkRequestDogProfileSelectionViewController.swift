//
//  MatchingApplyWalkRequestDogProfileSelectionViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit

final class MatchingApplyWalkRequestDogProfileSelectionViewController: UIViewController, StepConfigurable {

    private let dogProfileSelectionView = MatchingApplyWalkRequestDogProfileSelectionView()
    private var isDogSelected: Bool = false {
        didSet {
            buttonStateChanged?(isDogSelected)
        }
    }

    var stepTitle: String { "산책이 필요한 반려견을 선택해요." }
    var buttonTitle: String { "다음으로" }
    var isButtonEnabled: Bool { isDogSelected }
    var isWarningVisible: Bool { false }
    var buttonStateChanged: ((Bool) -> Void)?

    override func loadView() {
        self.view = dogProfileSelectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dogProfileSelectionView.onDogSelected = { [weak self] isSelected in
            self?.isDogSelected = isSelected
            if !isSelected {
                let profileVC = DogProfileViewController()
                self?.navigationController?.pushViewController(profileVC, animated: true)
            }
        }
    }
}
