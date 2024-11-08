//
//  MatchingFilterView.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit
import SnapKit

class MatchingFilterView: UIView {

    private let distanceFrame = UIView()
    private let breedFrame = UIView()
    private let matchingStatusFrame = UIView()
    private let buttonFrame = UIView()

    private let resetButton = UIView()
    private let resetLabel = UILabel()
    private let applyButton = UIView()
    private let applyLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 30
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        distanceFrame.backgroundColor = .red
        breedFrame.backgroundColor = .green
        matchingStatusFrame.backgroundColor = .clear

        self.addSubview(distanceFrame)
        self.addSubview(breedFrame)
        self.addSubview(matchingStatusFrame)
        self.addSubview(buttonFrame)

        setupMatchingStatus()
        setupButtons()
    }

    private func setupMatchingStatus() {
        // "매칭여부" 라벨
        let statusLabel = UILabel()
        statusLabel.textColor = UIColor(red: 0.081, green: 0.081, blue: 0.076, alpha: 1)
        statusLabel.font = UIFont(name: "Pretendard-Bold", size: 20)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        paragraphStyle.alignment = .left

        statusLabel.attributedText = NSMutableAttributedString(
            string: "매칭여부",
            attributes: [
                NSAttributedString.Key.kern: -0.32,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        )
        matchingStatusFrame.addSubview(statusLabel)

        // 버튼 프레임
        let buttonContainer = UIView()
        matchingStatusFrame.addSubview(buttonContainer)

        // 매칭중 버튼
        let matchingButton = UIView()
        matchingButton.backgroundColor = UIColor(red: 0.276, green: 0.754, blue: 1, alpha: 1)
        matchingButton.layer.cornerRadius = 19
        buttonContainer.addSubview(matchingButton)

        let matchingLabel = UILabel()
        matchingLabel.text = "매칭중"
        matchingLabel.textColor = .white
        matchingLabel.font = UIFont(name: "Pretendard-Medium", size: 16)
        matchingLabel.textAlignment = .center
        matchingButton.addSubview(matchingLabel)

        // 매칭확정 버튼
        let confirmedButton = UIView()
        confirmedButton.backgroundColor = UIColor(red: 0.978, green: 0.978, blue: 0.978, alpha: 1)
        confirmedButton.layer.cornerRadius = 19
        buttonContainer.addSubview(confirmedButton)

        let confirmedLabel = UILabel()
        confirmedLabel.text = "매칭확정"
        confirmedLabel.textColor = UIColor(red: 0.365, green: 0.373, blue: 0.404, alpha: 1)
        confirmedLabel.font = UIFont(name: "Pretendard-Medium", size: 16)
        confirmedLabel.textAlignment = .center
        confirmedButton.addSubview(confirmedLabel)

        // 레이아웃 설정
        statusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(28)
        }

        buttonContainer.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(353)
            make.height.equalTo(38)
        }

        matchingButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(73)
            make.height.equalTo(38)
        }

        matchingLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        confirmedButton.snp.makeConstraints { make in
            make.leading.equalTo(matchingButton.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(87)
            make.height.equalTo(38)
        }

        confirmedLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupButtons() {
        // 초기화 버튼
        resetButton.backgroundColor = UIColor(red: 0.978, green: 0.978, blue: 0.978, alpha: 1)
        resetButton.layer.cornerRadius = 15
        buttonFrame.addSubview(resetButton)

        resetLabel.text = "초기화"
        resetLabel.textColor = UIColor(red: 0.365, green: 0.373, blue: 0.404, alpha: 1)
        resetLabel.font = UIFont(name: "Pretendard-Medium", size: 16)
        let resetParagraphStyle = NSMutableParagraphStyle()
        resetParagraphStyle.lineHeightMultiple = 1.17
        resetLabel.attributedText = NSMutableAttributedString(string: "초기화", attributes: [NSAttributedString.Key.kern: -0.32, NSAttributedString.Key.paragraphStyle: resetParagraphStyle])
        resetButton.addSubview(resetLabel)

        // 적용하기 버튼
        applyButton.backgroundColor = UIColor(red: 0.198, green: 0.203, blue: 0.222, alpha: 1)
        applyButton.layer.cornerRadius = 15
        buttonFrame.addSubview(applyButton)

        applyLabel.text = "적용하기"
        applyLabel.textColor = UIColor(red: 0.978, green: 0.978, blue: 0.978, alpha: 1)
        applyLabel.font = UIFont(name: "Pretendard-Medium", size: 16)
        let applyParagraphStyle = NSMutableParagraphStyle()
        applyParagraphStyle.lineHeightMultiple = 1.17
        applyLabel.attributedText = NSMutableAttributedString(string: "적용하기", attributes: [NSAttributedString.Key.kern: -0.32, NSAttributedString.Key.paragraphStyle: applyParagraphStyle])
        applyButton.addSubview(applyLabel)
    }

    private func setupLayout() {
        distanceFrame.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(145)
        }

        breedFrame.snp.makeConstraints { make in
            make.top.equalTo(distanceFrame.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(156)
        }

        matchingStatusFrame.snp.makeConstraints { make in
            make.top.equalTo(breedFrame.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(114)
        }

        buttonFrame.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(38)
            make.width.equalTo(356)
            make.height.equalTo(54)
        }

        // 초기화 버튼 레이아웃
        resetButton.snp.makeConstraints { make in
            make.leading.equalTo(buttonFrame.snp.leading)
            make.centerY.equalTo(buttonFrame.snp.centerY)
            make.width.equalTo(93)
            make.height.equalTo(54)
        }

        resetLabel.snp.makeConstraints { make in
            make.center.equalTo(resetButton)
            make.width.equalTo(41)
            make.height.equalTo(22)
        }

        // 적용하기 버튼 레이아웃
        applyButton.snp.makeConstraints { make in
            make.trailing.equalTo(buttonFrame.snp.trailing)
            make.centerY.equalTo(buttonFrame.snp.centerY)
            make.width.equalTo(251)
            make.height.equalTo(54)
        }

        applyLabel.snp.makeConstraints { make in
            make.center.equalTo(applyButton)
            make.width.equalTo(55)
            make.height.equalTo(22)
        }
    }
}
