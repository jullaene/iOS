//
//  WalkReviewCell.swift
//  walkmong
//
//  Created by 신호연 on 12/7/24.
//

import UIKit
import SnapKit

class WalkReviewCell: UITableViewCell {
    
    // MARK: - Subviews
    private let profileFrame = ProfileFrameView()
    private let circleStackView = WalkReviewCell.makeCircleStackView()
    private let photoFrame = UIView()
    private let reviewTextFrame = UIView()
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCircleStackView()
    }
    
    // MARK: - Configuration
    private func configureCell() {
        configureAppearance()
        addSubviews()
        setupConstraints()
        configureCircleItems()
    }
    
    private func configureAppearance() {
        backgroundColor = .white
        contentView.backgroundColor = .white
        
        photoFrame.backgroundColor = .blue
        reviewTextFrame.backgroundColor = .yellow
    }
    
    private func addSubviews() {
        [profileFrame, circleStackView, photoFrame, reviewTextFrame].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func resetCircleStackView() {
        circleStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        configureCircleItems()
    }
    
    private func configureCircleItems() {
        let circleData = [
            ("사회성", "#낯가림 있어요"),
            ("활동량", "#활발해요"),
            ("공격성", "#안짖어요")
        ]
        
        circleData.forEach { title, tag in
            let circleView = CircleTagView(title: title, tag: tag)
            circleStackView.addArrangedSubview(circleView)
        }
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        let margin: CGFloat = 20
        let spacing: CGFloat = 24

        profileFrame.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(margin)
            make.leading.trailing.equalToSuperview().inset(margin)
            make.height.equalTo(50)
        }

        circleStackView.snp.makeConstraints { make in
            make.top.equalTo(profileFrame.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(margin)
            make.height.equalTo(96)
        }

        photoFrame.snp.makeConstraints { make in
            make.top.equalTo(circleStackView.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(margin)
            make.height.equalTo(147)
        }

        reviewTextFrame.snp.makeConstraints { make in
            make.top.equalTo(photoFrame.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(margin)
            make.bottom.equalToSuperview().offset(-margin)
        }
    }
    
    // MARK: - Factory Methods
    private static func makeCircleStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }
}
