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

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(matchingStatusListView)
        matchingStatusListView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(52)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        addCustomNavigationBar(titleText: "매칭 현황", showLeftBackButton: false, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
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
                let nextVC = MatchingStatusMyApplicationViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }else if matchingResponseData.walkMatchingStatus == "BEFORE"{
                let nextVC = MatchingStatusWalkInfoForOwnerViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }else if matchingResponseData.tabStatus == "BOARD" {
            if matchingResponseData.walkMatchingStatus == "PENDING" {
                let nextVC = MatchingStatusApplicantListViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }else if matchingResponseData.walkMatchingStatus == "BEFORE"{
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
