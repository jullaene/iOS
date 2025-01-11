//
//  MatchingStatusListViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/11/25.
//

import UIKit

final class MatchingStatusListViewController: UIViewController {
    
    private let matchingStatusListView = MatchingStatusListView()

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
    func didSelectTabBarIndex(record: Record, status: Status) {
        //TODO: API 호출
        let dummyData: [MatchingStatusListResponseData] = [
            MatchingStatusListResponseData(
                dogName: "Buddy",
                dogGender: "MALE",
                dogProfile: "profile1",
                dongAddress: "청담동",
                addressDetail: "스타벅스 앞",
                startTime: "2024-11-30 14:00:00.000000",
                endTime: "2024-11-30 15:00:00.000000",
                distance: 0.5785,
                walkerNickname: "Walker1",
                walkerProfile: "profile1"
            ),
            MatchingStatusListResponseData(
                dogName: "Lucy",
                dogGender: "FEMALE",
                dogProfile: "profile2",
                dongAddress: "압구정동",
                addressDetail: "카페 뒤",
                startTime: "2024-12-01 10:00:00.000000",
                endTime: "2024-12-01 11:00:00.000000",
                distance: 1.2345,
                walkerNickname: "Walker2",
                walkerProfile: "profile2"
            ),
            MatchingStatusListResponseData(
                dogName: "Max",
                dogGender: "MALE",
                dogProfile: "profile3",
                dongAddress: "삼성동",
                addressDetail: "편의점 옆",
                startTime: "2024-12-02 16:00:00.000000",
                endTime: "2024-12-02 17:00:00.000000",
                distance: 0.8765,
                walkerNickname: "Walker3",
                walkerProfile: "profile3"
            ),
            MatchingStatusListResponseData(
                dogName: "Bella",
                dogGender: "FEMALE",
                dogProfile: "profile4",
                dongAddress: "강남구",
                addressDetail: "도서관 앞",
                startTime: "2024-12-03 08:00:00.000000",
                endTime: "2024-12-03 09:00:00.000000",
                distance: 0.4567,
                walkerNickname: "Walker4",
                walkerProfile: "profile4"
            ),
            MatchingStatusListResponseData(
                dogName: "Charlie",
                dogGender: "MALE",
                dogProfile: "profile5",
                dongAddress: "역삼동",
                addressDetail: "공원 입구",
                startTime: "2024-12-04 18:00:00.000000",
                endTime: "2024-12-04 19:00:00.000000",
                distance: 1.6789,
                walkerNickname: "Walker5",
                walkerProfile: "profile5"
            ),
            MatchingStatusListResponseData(
                dogName: "Molly",
                dogGender: "FEMALE",
                dogProfile: "profile6",
                dongAddress: "서초동",
                addressDetail: "식당 앞",
                startTime: "2024-12-05 13:00:00.000000",
                endTime: "2024-12-05 14:00:00.000000",
                distance: 0.3245,
                walkerNickname: "Walker6",
                walkerProfile: "profile6"
            ),
            MatchingStatusListResponseData(
                dogName: "Daisy",
                dogGender: "FEMALE",
                dogProfile: "profile7",
                dongAddress: "논현동",
                addressDetail: "마트 앞",
                startTime: "2024-12-06 09:00:00.000000",
                endTime: "2024-12-06 10:00:00.000000",
                distance: 0.2456,
                walkerNickname: "Walker7",
                walkerProfile: "profile7"
            ),
            MatchingStatusListResponseData(
                dogName: "Rocky",
                dogGender: "MALE",
                dogProfile: "profile8",
                dongAddress: "이태원",
                addressDetail: "버스정류장 앞",
                startTime: "2024-12-07 20:00:00.000000",
                endTime: "2024-12-07 21:00:00.000000",
                distance: 0.7894,
                walkerNickname: "Walker8",
                walkerProfile: "profile8"
            ),
            MatchingStatusListResponseData(
                dogName: "Coco",
                dogGender: "FEMALE",
                dogProfile: "profile9",
                dongAddress: "잠실동",
                addressDetail: "놀이공원 근처",
                startTime: "2024-12-08 12:00:00.000000",
                endTime: "2024-12-08 13:00:00.000000",
                distance: 0.9876,
                walkerNickname: "Walker9",
                walkerProfile: "profile9"
            ),
            MatchingStatusListResponseData(
                dogName: "Jack",
                dogGender: "MALE",
                dogProfile: "profile10",
                dongAddress: "송파동",
                addressDetail: "헬스장 옆",
                startTime: "2024-12-09 17:00:00.000000",
                endTime: "2024-12-09 18:00:00.000000",
                distance: 0.6543,
                walkerNickname: "Walker10",
                walkerProfile: "profile10"
            )
        ]

        matchingStatusListView.setContent(with: dummyData)
    }
    
    func didSelectMatchingCell(matchingResponseData: MatchingStatusListResponseData, record: Record, status: Status) {
        //TODO: 지원 정보 보기 / 지원한 산책자 보기 / 산책 정보 보기 - 화면 전환
    }
}
