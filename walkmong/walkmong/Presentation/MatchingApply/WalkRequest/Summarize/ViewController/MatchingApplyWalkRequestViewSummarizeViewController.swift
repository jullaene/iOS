//
//  MatchingApplyWalkRequestViewSummarizeViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit

final class MatchingApplyWalkRequestViewSummarizeViewController: UIViewController {
    var selectionTexts: [String] = []
    var startTime: String = ""
    var endTime: String = ""
    var receivedTexts: [String] = ["", "", ""]
    var selectedDogId: Int?
    
    private let containerView = MatchingApplyWalkRequestView()
    private let summarizeView = MatchingApplyWalkRequestViewSummarizeView()
    
    override func loadView() {
        self.view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAndDisplayDogProfile(dogId: selectedDogId)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addProgressBar(currentStep: 4, totalSteps: 5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }

    private func setupUI() {
        view.backgroundColor = .gray100

        addCustomNavigationBar(
            titleText: "산책 지원 요청",
            showLeftBackButton: true,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false,
            backgroundColor: .clear
        )
        
        containerView.middleTitleLabel.text = "산책 요청 최종 확인"
        containerView.actionButton.setTitle("다음으로", for: .normal)
        containerView.updateContentView(with: summarizeView)
        containerView.actionButton.addTarget(self, action: #selector(handleNextButtonTapped), for: .touchUpInside)
        containerView.updateWarningText("산책 지원 요청 내용을 확인했습니다.")
        containerView.showWarningSection()
        
        updateSummaryView()
    }

    @objc private func handleNextButtonTapped() {
        let nextVC = MatchingApplyWalkRequestCautionViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    private func updateSummaryView() {
        summarizeView.updateSectionView(texts: receivedTexts)

        if let formattedStartTime = formatISO8601Date(startTime) {
            summarizeView.planStartDateLabel.text = formattedStartTime
        } else {
            summarizeView.planStartDateLabel.text = "날짜 정보가 없습니다."
            print("Start time is empty or invalid: \(startTime)")
        }

        if let formattedEndTime = formatISO8601Date(endTime) {
            summarizeView.planEndDateLabel.text = formattedEndTime
        } else {
            summarizeView.planEndDateLabel.text = "날짜 정보가 없습니다."
            print("End time is empty or invalid: \(endTime)")
        }

        if selectionTexts.count > 0 {
            summarizeView.updateLocationText(for: summarizeView.setView1, with: selectionTexts[0])
        }
        if selectionTexts.count > 1 {
            summarizeView.updateLocationText(for: summarizeView.setView3, with: selectionTexts[1])
        }
    }
    
    private func formatISO8601Date(_ isoString: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime]
        isoFormatter.timeZone = TimeZone.current // 로컬 시간대 설정

        guard let date = isoFormatter.date(from: isoString) else {
            print("Failed to parse date: \(isoString)")
            return nil
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy.MM.dd (EEE)nㅜHH:mm"
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.timeZone = TimeZone.current

        return outputFormatter.string(from: date)
    }
    
    private func fetchAndDisplayDogProfile(dogId: Int?) {
        guard let dogId = dogId else {
            print("선택된 강아지 ID가 없습니다.")
            return
        }

        Task {
            do {
                let response = try await DogService().getDogProfile(dogId: dogId)
                DispatchQueue.main.async {
                    self.summarizeView.updateWithDogInfo(response.data)
                }
            } catch {
                print("Failed to fetch dog profile: \(error)")
            }
        }
    }
}
