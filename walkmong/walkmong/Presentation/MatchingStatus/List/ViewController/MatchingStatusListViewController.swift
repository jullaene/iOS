//
//  MatchingStatusListViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/11/25.
//

import UIKit

final class MatchingStatusListViewController: UIViewController {
    
    private let matchingStatusListView = MatchingStatusListView()
    private let service = ApplyService()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        view.addSubview(matchingStatusListView)
        addCustomNavigationBar(titleText: "매칭 현황", showLeftBackButton: false, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        matchingStatusListView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(52)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        matchingStatusListView.delegate = self
    }
}

extension MatchingStatusListViewController: MatchingStatusListViewDelegate {
    func didSelectMatchingCell(matchingResponseData: ApplyHistoryItem, record: Record, status: Status) {
        //TODO: 지원 정보 보기 / 지원한 산책자 보기 / 산책 정보 보기 - 화면 전환
        // APPLY + PENDING -> MatchingStatusMyApplicationViewController
        // BOARD + PENDING -> MatchingStatusApplicantListViewController
        // APPLY + BEFORE -> MatchingStatusWalkInfoForOwnerViewController
        // BOARD + BEFORE -> MatchingStatusWalkInfoForWalkerViewController
        if matchingResponseData.tabStatus == "APPLY" {
            if matchingResponseData.walkMatchingStatus == "PENDING" {
                self.tabBarController?.tabBar.isHidden = false
                let nextVC = MatchingStatusMyApplicationViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }else if matchingResponseData.walkMatchingStatus == "BEFORE"{
                self.tabBarController?.tabBar.isHidden = false
                let nextVC = MatchingStatusWalkInfoForOwnerViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }else if matchingResponseData.tabStatus == "BOARD" {
            if matchingResponseData.walkMatchingStatus == "PENDING" {
                self.tabBarController?.tabBar.isHidden = false
                let nextVC = MatchingStatusApplicantListViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }else if matchingResponseData.walkMatchingStatus == "BEFORE"{
                self.tabBarController?.tabBar.isHidden = false
                let nextVC = MatchingStatusWalkInfoForWalkerViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    func didSelectTabBarIndex(record: Record, status: Status) {
        Task {
            showLoading()
            defer { hideLoading() }
            do {
                let response = try await service.getApplyHistory(tabStatus: record, walkMatchingStatus: status)
                matchingStatusListView.setContent(with: response.data)
            }catch {
                
            }
        }
    }
}
