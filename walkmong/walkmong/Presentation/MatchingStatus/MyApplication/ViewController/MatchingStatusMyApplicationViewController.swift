//
//  MatchingStatusMyApplicationViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit
import SnapKit

final class MatchingStatusMyApplicationViewController: UIViewController, MatchingStatusMyApplicationViewDelegate {
    func didTapWalkTalkButton() {
        self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.selectedIndex = 2
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
                Task {
                    do{
                        if let id = self.applyId {
                            _ = try await self.service.deleteApplyCancel(applyId: id)
                        }
                        self.navigationController?.popToRootViewController(animated: true)
                    }catch {
                        CustomAlertViewController.CustomAlertBuilder(viewController: self)
                            .setButtonState(.singleButton)
                            .setTitleState(.useTitleAndSubTitle)
                            .setTitleText("지원 취소 실패")
                            .setSubTitleText("네트워크 상태를 확인해주세요.")
                            .setSingleButtonTitle("돌아가기")
                            .showAlertView()
                    }
                }
            })
            .showAlertView()
    }
    
    
    // MARK: - Properties
    private let matchingStatusMyApplicationView = MatchingStatusMyApplicationView()
    private var applyId: Int?
    private let service = ApplyService()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        if let applyId = self.applyId {
            Task {
                await getApplyMyForm(applyId: applyId)
            }
        }
    }
    
    init(applyId: Int) {
        self.applyId = applyId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupView() {
        view.backgroundColor = .gray100
        view.addSubview(matchingStatusMyApplicationView)
        matchingStatusMyApplicationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(52)
            make.leading.trailing.bottom.equalToSuperview()
        }
        matchingStatusMyApplicationView.delegate = self
    }
    
    private func setupNavigationBar() {
        addCustomNavigationBar(
            titleText: "산책 지원서",
            showLeftBackButton: true,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false,
            backgroundColor: .clear
        )
    }
 
    func getApplyMyForm(applyId: Int) async {
        Task {
            showLoading()
            defer { hideLoading() }
            do {
                let response = try await service.getApplyMyForm(applyId: applyId)
                matchingStatusMyApplicationView.updateDogProfile(with: response.data)
            } catch {
                print("Error fetching or decoding ApplyMyForm: \(error)")
            }
        }
    }
}
