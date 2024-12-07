//
//  WalkReviewFrame.swift
//  walkmong
//
//  Created by 신호연 on 12/7/24.
//

import UIKit

class WalkReviewFrame: UIView {
    private let titleLabel = SmallTitleLabel(text: "산책 후기")
    private let countLabel = MainHighlightParagraphLabel(text: "3개", textColor: .gray600)
    private let arrowButton = UIButton()
    private let circleStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .gray100
        layer.cornerRadius = 20

        // Title Label
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        // Count Label
        addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(4)
            make.centerY.equalTo(titleLabel)
        }

        // Arrow Button
        arrowButton.setImage(UIImage(named: "arrowIcon"), for: .normal)
        addSubview(arrowButton)
        arrowButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(24)
        }
        arrowButton.addTarget(self, action: #selector(navigateToReviewController), for: .touchUpInside)

        // Circle Stack View
        addSubview(circleStackView)
        circleStackView.axis = .horizontal
        circleStackView.alignment = .center
        circleStackView.distribution = .equalSpacing
        circleStackView.spacing = 8
        circleStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-28)
            make.height.greaterThanOrEqualTo(100)
        }

        // Add Circle Items
        addCircleItem(title: "사회성", tag: "#낯가림 있어요")
        addCircleItem(title: "활동량", tag: "#활발해요")
        addCircleItem(title: "공격성", tag: "#안짖어요")
    }
    
    private func addCircleItem(title: String, tag: String) {
        let circleView = CircleTagView(title: title, tag: tag)
        circleStackView.addArrangedSubview(circleView)
    }

    @objc private func navigateToReviewController() {
        // TODO: 산책 후기 뷰컨트롤러로 이동
        print("Navigate to Walk Review Controller")
    }
}
