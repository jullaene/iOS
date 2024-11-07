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
        matchingStatusFrame.backgroundColor = .blue

        self.addSubview(distanceFrame)
        self.addSubview(breedFrame)
        self.addSubview(matchingStatusFrame)
        self.addSubview(buttonFrame)

        setupButtons()
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
