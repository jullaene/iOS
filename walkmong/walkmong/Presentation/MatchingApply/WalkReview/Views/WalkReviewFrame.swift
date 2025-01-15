//
//  WalkReviewFrame.swift
//  walkmong
//
//  Created by 신호연 on 12/7/24.
//

import UIKit

class WalkReviewFrame: UIView {
    
    // MARK: - Properties
    
    private let titleLabel = SmallTitleLabel(text: "산책 후기")
    private let countLabel = MainHighlightParagraphLabel(text: "3개", textColor: .gray600)
    private let arrowButton: UIButton = {
        let button = ExpandableButton(touchAreaPadding: 10)
        button.setImage(UIImage(named: "arrowIcon"), for: .normal)
        return button
    }()
    private let circleStackView = UIStackView()
    
    // UI Constants
    private enum UIConstants {
        static let cornerRadius: CGFloat = 20
        static let titleTopOffset: CGFloat = 20
        static let titleLeadingOffset: CGFloat = 20
        static let countLabelSpacing: CGFloat = 4
        static let arrowButtonSize: CGFloat = 20
        static let arrowButtonTrailingOffset: CGFloat = -24
        static let circleStackViewTopOffset: CGFloat = 20
        static let circleStackViewBottomOffset: CGFloat = -28
        static let circleStackViewHeight: CGFloat = 100
        static let circleStackViewSpacing: CGFloat = 8
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setupButtonTargets()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Configuration
    
    private func configureView() {
        setupAppearance()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupAppearance() {
        backgroundColor = .gray100
        layer.cornerRadius = UIConstants.cornerRadius
    }
    
    private func setupSubviews() {
        // Add subviews
        addSubview(titleLabel)
        addSubview(countLabel)
        addSubview(arrowButton)
        addSubview(circleStackView)
        
        // Configure Circle Stack View
        circleStackView.axis = .horizontal
        circleStackView.alignment = .center
        circleStackView.distribution = .equalSpacing
        circleStackView.spacing = UIConstants.circleStackViewSpacing
        
        // Add Circle Items
        addCircleItems()
    }
    
    private func setupConstraints() {
        // Title Label Constraints
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIConstants.titleTopOffset)
            make.leading.equalToSuperview().offset(UIConstants.titleLeadingOffset)
        }
        
        // Count Label Constraints
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(UIConstants.countLabelSpacing)
            make.centerY.equalTo(titleLabel)
        }
        
        // Arrow Button Constraints
        arrowButton.snp.makeConstraints { make in
            make.width.height.equalTo(UIConstants.arrowButtonSize)
            make.trailing.equalToSuperview().offset(UIConstants.arrowButtonTrailingOffset)
            make.top.equalToSuperview().offset(UIConstants.titleTopOffset)
        }
        
        // Circle Stack View Constraints
        circleStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(UIConstants.circleStackViewTopOffset)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(UIConstants.circleStackViewBottomOffset)
            make.height.greaterThanOrEqualTo(UIConstants.circleStackViewHeight)
        }
    }
    
    // MARK: - Circle Items
    
    private func addCircleItems() {
        let circleItems = [
            (title: "사회성", tag: "#낯가림 있어요"),
            (title: "활동량", tag: "#활발해요"),
            (title: "공격성", tag: "#안짖어요")
        ]
        
        circleItems.forEach { item in
            let circleView = CircleTagView(title: item.title, tag: item.tag)
            circleStackView.addArrangedSubview(circleView)
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapArrowButton() {
        guard let currentVC = self.getViewController() else {
            print("Error: Cannot find the current view controller.")
            return
        }
        
        let reviewVC = WalkReviewViewController()
        currentVC.navigationController?.pushViewController(reviewVC, animated: true)
    }
    
    private func setupButtonTargets() {
        arrowButton.addTarget(self, action: #selector(didTapArrowButton), for: .touchUpInside)
    }
}

private class ExpandableButton: UIButton {
    private let touchAreaPadding: CGFloat

    init(touchAreaPadding: CGFloat) {
        self.touchAreaPadding = touchAreaPadding
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let largerArea = bounds.insetBy(dx: -touchAreaPadding, dy: -touchAreaPadding)
        return largerArea.contains(point)
    }
}
