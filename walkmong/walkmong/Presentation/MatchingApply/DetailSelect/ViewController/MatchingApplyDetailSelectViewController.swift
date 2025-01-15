//
//  MatchingApplyDetailSelectViewController.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit

final class MatchingApplyDetailSelectViewController: UIViewController {
    
    private var boardDetail: BoardDetail?

    let detailSelectView = MatchingApplyDetailSelectView()
    var detailSelectModel = MatchingApplyDetailSelectModel(dogInformationChecked: false, dateChecked: false, nextButtonEnabled: false)
    
    func configure(with boardDetail: BoardDetail) {
        self.boardDetail = boardDetail
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
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
    func updatePlaceSelected(_ view: MatchingApplyDetailSelectView, _ model: MatchingApplyMapModel) {
        view.updateSelectButtons(buttonType: .selectPlace, value: true, model)
        self.detailSelectModel.placeSelected = model
        updateNextButtonState()
    }
    
    func buttonTapped(buttonType: ButtonType, value: Bool) {
        switch buttonType {
        case .dogInformationChecked:
            self.detailSelectModel.dogInformationChecked = value
            self.detailSelectView.updateSelectButtons(buttonType: .dogInformationChecked, value: value, nil)
        case .dateChecked:
            self.detailSelectModel.dateChecked = value
            self.detailSelectView.updateSelectButtons(buttonType: .dateChecked, value: value, nil)
        case .selectPlace:
            let nextVC = MatchingApplyPlaceSearchViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        case .envelopeNeeded:
            self.detailSelectModel.envelopeNeeded = value
            self.detailSelectView.updateSelectButtons(buttonType: .envelopeNeeded, value: value, nil)
        case .mouthCoverNeeded:
            self.detailSelectModel.mouthCoverNeeded = value
            self.detailSelectView.updateSelectButtons(buttonType: .mouthCoverNeeded, value: value, nil)
        case .leadStringeNeeded:
            self.detailSelectModel.leadStringNeeded = value
            self.detailSelectView.updateSelectButtons(buttonType: .leadStringeNeeded, value: value, nil)
        case .preMeetingNeeded:
            self.detailSelectModel.preMeetingNeeded = value
            self.detailSelectView.updateSelectButtons(buttonType: .preMeetingNeeded, value: value, nil)
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
            self.detailSelectModel.leadStringNeeded != nil &&
            self.detailSelectModel.preMeetingNeeded != nil {
            self.detailSelectModel.nextButtonEnabled = true
            detailSelectView.updateSelectButtons(buttonType: .next, value: true, nil)
        }else {
            self.detailSelectModel.nextButtonEnabled = false
            detailSelectView.updateSelectButtons(buttonType: .next, value: false, nil)
        }
    }
}
