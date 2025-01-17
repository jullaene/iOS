//
//  MatchingStatusListViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/11/25.
//

import UIKit

final class MatchingStatusListViewController: UIViewController {
    
    private let matchingStatusListView = MatchingStatusListView()
    private lazy var soonView = MatchingStatusSoonView()
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
    
    private func setUI() {
        Task {
            showLoading()
            defer { hideLoading() }
            do {
                self.navigationController?.navigationBar.isHidden = true
                view.backgroundColor = .white
                let response = try await service.getApplyHistory(tabStatus: .ALL, walkMatchingStatus: .BEFORE)
                let sorted = sortMatchingDataByRecentTime(response.data)
                if let firstStart = sorted.first?.startTime {
                    if isStartTimeWithin24Hours(startTime: firstStart) {
                        let scrollView = UIScrollView()
                        let contentView = UIView()
                        scrollView.addSubview(contentView)
                        view.addSubview(scrollView)
                        contentView.addSubviews(soonView, matchingStatusListView)
                        matchingStatusListView.layer.cornerRadius = 20
                        matchingStatusListView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                        soonView.snp.makeConstraints { make in
                            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(52)
                            make.horizontalEdges.equalToSuperview()
                            make.height.equalTo(317)
                        }
                        matchingStatusListView.snp.makeConstraints { make in
                            make.top.equalTo(soonView.snp.top).offset(-20)
                            make.horizontalEdges.equalToSuperview()
                            make.height.equalToSuperview()
                        }
                        if let first = sorted.first {
                            soonView.setContent(startDate: first.startTime, endDate: first.endTime, dogName: first.dogName, dogProfileURL: first.dogProfile)
                        }
                        addCustomNavigationBar(titleText: "매칭 현황", showLeftBackButton: false, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false, backgroundColor: .clear)
                    }else {
                        view.addSubview(matchingStatusListView)
                        addCustomNavigationBar(titleText: "매칭 현황", showLeftBackButton: false, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
                        matchingStatusListView.snp.makeConstraints { make in
                            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(52)
                            make.horizontalEdges.equalToSuperview()
                            make.bottom.equalToSuperview().offset(-86)
                        }
                    }
                }else {
                    view.addSubview(matchingStatusListView)
                    addCustomNavigationBar(titleText: "매칭 현황", showLeftBackButton: false, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
                    matchingStatusListView.snp.makeConstraints { make in
                        make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(52)
                        make.horizontalEdges.equalToSuperview()
                        make.bottom.equalToSuperview().offset(-86)
                    }
                    matchingStatusListView.delegate = self
                }
            }catch {
                
            }
        }
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
                let nextVC = MatchingStatusMyApplicationViewController(applyId: matchingResponseData.applyId)
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

extension MatchingStatusListViewController {
    private func sortMatchingDataByRecentTime(_ data: [ApplyHistoryItem]) -> [ApplyHistoryItem] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return data.sorted { first, second in
            guard let firstDate = dateFormatter.date(from: first.startTime),
                  let secondDate = dateFormatter.date(from: second.startTime) else {
                return false
            }
            return firstDate > secondDate // 내림차순
        }
    }
    func isStartTimeWithin24Hours(startTime: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone.current
        
        // 현재 시간
        let now = Date()
        
        // startTime을 Date로 변환
        guard let startDate = dateFormatter.date(from: startTime) else {
            print("시간 형식 오류")
            return false
        }
        
        // 현재 시간으로부터 24시간 뒤
        let twentyFourHoursLater = Calendar.current.date(byAdding: .hour, value: 24, to: now)!
        
        // 비교
        return startDate <= twentyFourHoursLater
    }
}
