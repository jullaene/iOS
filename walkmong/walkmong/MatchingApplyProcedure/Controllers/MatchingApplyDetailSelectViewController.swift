//
//  MatchingApplyDetailSelectViewController.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit

final class MatchingApplyDetailSelectViewController: UIViewController {

    let detailSelectView = MatchingApplyDetailSelectView()
    var detailSelectModel = MatchingApplyDetailSelectModel(dogInformationChecked: false, dateChecked: false, nextButtonEnabled: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    private func setUpViews(){
        view.backgroundColor = .white
        addCustomNavigationBar(titleText: "산책 지원하기", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        addProgressBar(currentStep: 1, totalSteps: 3)
        
        self.view.addSubview(detailSelectView)
        self.detailSelectView.delegate = self
        
        detailSelectView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(156)
            make.bottom.equalToSuperview()
        }
    }
}

extension MatchingApplyDetailSelectViewController: MatchingApplyDetailSelectViewDelegate {
    func buttonTapped(buttonType: ButtonType, value: Bool) {
        switch buttonType {
        case .dogInformationChecked:
            self.detailSelectModel.dogInformationChecked = value
            self.detailSelectView.updateSelectButtons(buttonType: .dogInformationChecked, value: value)
        case .dateChecked:
            self.detailSelectModel.dateChecked = value
            self.detailSelectView.updateSelectButtons(buttonType: .dateChecked, value: value)
        case .selectPlace:
            let nextVC = MatchingApplyMapViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
            self.detailSelectModel.placeSelected = "address"
            // 주소 가져오기 성공 시에만 value: true
            self.detailSelectView.updateSelectButtons(buttonType: .selectPlace, value: true)
        case .envelopeNeeded:
            self.detailSelectModel.envelopeNeeded = value
            self.detailSelectView.updateSelectButtons(buttonType: .envelopeNeeded, value: value)
        case .mouthCoverNeeded:
            self.detailSelectModel.mouthCoverNeeded = value
            self.detailSelectView.updateSelectButtons(buttonType: .mouthCoverNeeded, value: value)
        case .leadStringeNeeded:
            self.detailSelectModel.leadStringeNeeded = value
            self.detailSelectView.updateSelectButtons(buttonType: .leadStringeNeeded, value: value)
        case .preMeetingNeeded:
            self.detailSelectModel.preMeetingNeeded = value
            self.detailSelectView.updateSelectButtons(buttonType: .preMeetingNeeded, value: value)
        case .next:
            if self.detailSelectModel.nextButtonEnabled {
                let nextVC = MatchingApplyMessageViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
        updateNextButtonState()
    }
    
    func updateNextButtonState() {
        if self.detailSelectModel.dogInformationChecked &&
            self.detailSelectModel.dateChecked &&
            self.detailSelectModel.placeSelected != nil &&
            self.detailSelectModel.envelopeNeeded != nil &&
            self.detailSelectModel.mouthCoverNeeded != nil &&
            self.detailSelectModel.leadStringeNeeded != nil &&
            self.detailSelectModel.preMeetingNeeded != nil {
            self.detailSelectModel.nextButtonEnabled = true
            detailSelectView.updateSelectButtons(buttonType: .next, value: true)
        }else {
            self.detailSelectModel.nextButtonEnabled = false
            detailSelectView.updateSelectButtons(buttonType: .next, value: false)
        }
    }
}
