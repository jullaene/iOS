//
//  WalkRequestMainViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/8/25.
//

import UIKit

final class WalkRequestMainViewController: UIViewController {
    private let stepControllers: [UIViewController]
    private var currentStepIndex = 0
    
    init() {
        self.stepControllers = [
            DogProfileSelectionViewController(),
            InformationInputViewController(),
            TextInputViewController(),
            SummarizeViewController(),
            CautionViewController()
        ]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showStep(at: currentStepIndex)
    }
    
    private func showStep(at index: Int) {
        let currentVC = stepControllers[index]
        addChild(currentVC)
        view.addSubview(currentVC.view)
        currentVC.view.frame = view.bounds
        currentVC.didMove(toParent: self)
        
        if let stepVC = currentVC as? WalkRequestStepViewController {
            stepVC.onNextStep = { [weak self] in
                self?.goToNextStep()
            }
        }
    }
    
    private func goToNextStep() {
        let currentVC = stepControllers[currentStepIndex]
        currentVC.willMove(toParent: nil)
        currentVC.view.removeFromSuperview()
        currentVC.removeFromParent()
        
        currentStepIndex += 1
        if currentStepIndex < stepControllers.count {
            showStep(at: currentStepIndex)
        } else {
            print("모든 단계 완료!")
        }
    }
}
