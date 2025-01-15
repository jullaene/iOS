//
//  MatchingApplyFinalViewController.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit

class MatchingApplyFinalViewController: UIViewController {

    private let finalView = MatchingApplyFinalView()
    private var matchingApplyRequest: WalkRequestData!
    private var boardDetailData: BoardDetail!
    private var boardId: Int!
    private var checked: Bool = false
    
    init(matchingApplyRequest: WalkRequestData, boardDetailData: BoardDetail, boardId: Int){
        self.boardDetailData = boardDetailData
        self.matchingApplyRequest = matchingApplyRequest
        self.finalView.setUI(boardDetail: boardDetailData, requestData: matchingApplyRequest)
        self.boardId = boardId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray100
        setUI()
    }
    
    private func setUI() {
        addSubView()
        setConstraints()
        finalView.delegate = self
        addCustomNavigationBar(titleText: "산책 지원하기", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false, backgroundColor: .gray100)
        addProgressBar(currentStep: 3, totalSteps: 3, backgroundColor: .gray100)
    }
    
    private func addSubView() {
        self.view.addSubview(finalView)
    }
    
    private func setConstraints() {
        finalView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(156)
            make.bottom.equalToSuperview()
        }
    }
}

extension MatchingApplyFinalViewController: MatchingApplyFinalViewDelegate {
    func didCheckedInformation(button: UIButton) {
        self.checked = button.isSelected
    }
    
    func didTapApplyButton() {
        if checked {
            Task {
                let service = ApplyService()
                do {
                    _ = try await service.applyWalk(boardId: boardId, request: matchingApplyRequest)
                    CustomAlertViewController
                        .CustomAlertBuilder(viewController: self)
                        .setTitleState(.useTitleOnly)
                        .setTitleText("산책 지원 성공")
                        .setButtonState(.singleButton)
                        .setSingleButtonTitle("확인")
                        .showAlertView()
                    self.navigationController?.popToRootViewController(animated: true)
                }catch {
                    CustomAlertViewController
                        .CustomAlertBuilder(viewController: self)
                        .setTitleState(.useTitleAndSubTitle)
                        .setTitleText("산책 지원 실패")
                        .setSubTitleText("네트워크 상태를 확인해주세요.")
                        .setButtonState(.singleButton)
                        .setSingleButtonTitle("돌아가기")
                        .showAlertView()
                }
            }
        }
    }
    
    func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
