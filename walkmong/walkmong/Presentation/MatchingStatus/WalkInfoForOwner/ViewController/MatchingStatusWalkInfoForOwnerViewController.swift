//
//  MatchingStatusWalkInfoForOwnerViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit
import SnapKit

final class MatchingStatusWalkInfoForOwnerViewController: UIViewController, MatchingStatusWalkInfoForOwnerViewDelegate {
    func didTapWalkTalkButton() {
        if let id = self.matchingData?.boardId {
            createChatroom(boardId: id)
        }
    }
    
    func didTapApplyButton() {
        CustomAlertViewController.CustomAlertBuilder(viewController: self)
            .setButtonState(.doubleButton)
            .setTitleState(.useTitleAndSubTitle)
            .setTitleText("지원 취소")
            .setSubTitleText("정말 지원을 취소하시겠습니까?")
            .setLeftButtonTitle("아니요")
            .setRightButtonTitle("네")
            .setRightButtonAction({
//                applyId가 없음...
//                Task {
//                    do{
//                        if let id = self.matchingData?.boardId {
//                            _ = try await self.service.deleteApplyCancel(applyId: id)
//                        }
//                        self.navigationController?.popToRootViewController(animated: true)
//                    }catch {
//                        CustomAlertViewController.CustomAlertBuilder(viewController: self)
//                            .setButtonState(.singleButton)
//                            .setTitleState(.useTitleAndSubTitle)
//                            .setTitleText("지원 취소 실패")
//                            .setSubTitleText("네트워크 상태를 확인해주세요.")
//                            .setSingleButtonTitle("돌아가기")
//                            .showAlertView()
//                    }
//                }
            })
            .showAlertView()

    }
    
    
    // MARK: - Properties
    private let matchingStatusWalkInfoForOwnerView = MatchingStatusWalkInfoForOwnerView()
    private var matchingData: BoardList?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupView() {
        view.backgroundColor = .gray100
        view.addSubview(matchingStatusWalkInfoForOwnerView)
        matchingStatusWalkInfoForOwnerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(52)
            make.leading.trailing.bottom.equalToSuperview()
        }
        matchingStatusWalkInfoForOwnerView.delegate = self
    }
    
    private func setupNavigationBar() {
        addCustomNavigationBar(
            titleText: "산책 정보",
            showLeftBackButton: true,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false,
            backgroundColor: .clear
        )
    }
    
    // MARK: - Data Management
    private func loadData() {
        let dogProfileData = BoardList(
            boardId: 1,
            startTime: "2025-01-03T00:32:40",
            endTime: "2025-01-03T14:32:30",
            matchingYn: "Y",
            dogName: "봄별이",
            dogProfile: "https://vetmed.tamu.edu/news/wp-content/uploads/sites/9/2023/05/AdobeStock_472713009-1024x768.jpeg",
            dogGender: "FEMALE",
            breed: "말티즈",
            weight: 4,
            dogSize: "SMALL",
            content: "Helloworld",
            dongAddress: "마포구 공덕동",
            distance: 1000,
            createdAt: "2025-01-02T00:32:40"
        )
        matchingStatusWalkInfoForOwnerView.updateDogProfile(with: dogProfileData)
        
        let applicant = MatchingStatusApplicantInfo(
            ownerProfile: "https://img.freepik.com/free-photo/expressive-asian-girl-posing-indoor_344912-1234.jpg?semt=ais_hybrid",
            ownerName: "홍길동",
            ownerAge: 32,
            ownerGender: "MALE",
            dongAddress: "서울시 강남구",
            distance: 500
        )
        matchingStatusWalkInfoForOwnerView.configureApplicantsList(with: applicant)
    }
    
}
