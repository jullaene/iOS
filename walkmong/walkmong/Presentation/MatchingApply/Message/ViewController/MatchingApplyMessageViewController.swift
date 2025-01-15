//
//  MatchingApplyMessageViewController.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit

class MatchingApplyMessageViewController: UIViewController {
    
    let messageView = MatchingApplyMessageView()
    private var matchingApplyRequest = WalkRequestData()
    private var boardDetail: BoardDetail!
    private var boardId: Int!
    
    init(matchingApplyRequest: WalkRequestData, boardDetail: BoardDetail, boardId: Int) {
        self.boardId = boardId
        self.boardDetail = boardDetail
        self.matchingApplyRequest = matchingApplyRequest
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapTextView(_:)))
        view.addGestureRecognizer(tapGesture)
        addCustomNavigationBar(titleText: "산책 지원하기", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        addProgressBar(currentStep: 2, totalSteps: 3)
        addSubviews()
        setConstraints()
        messageView.delegate = self
    }
    
    private func addSubviews(){
        self.view.addSubview(messageView)
    }
    
    private func setConstraints(){
        messageView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(152)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
    @objc private func didTapTextView(_ sender: Any) {
        view.endEditing(true)
    }
}
extension MatchingApplyMessageViewController: MatchingApplyMessageViewDelegate {
    func didTapNextButton(message: String) {
        matchingApplyRequest.memoToOwner = message
        let nextVC = MatchingApplyFinalViewController(matchingApplyRequest: self.matchingApplyRequest, boardDetailData: boardDetail, boardId: boardId)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
