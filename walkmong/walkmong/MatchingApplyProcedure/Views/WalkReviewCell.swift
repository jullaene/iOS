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
    private let circleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    private let photoFrame = UIView()
    private let reviewTextFrame = UIView()
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
        configureCircleItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        circleStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        configureCircleItems()
    }
    
    // MARK: - Setup View
    private func setupView() {
        backgroundColor = .white
        contentView.backgroundColor = .white

        photoFrame.backgroundColor = .blue
        reviewTextFrame.backgroundColor = .yellow

        [profileFrame, circleStackView, photoFrame, reviewTextFrame].forEach {
            contentView.addSubview($0)
        }
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        let margin: CGFloat = 20
        let spacing: CGFloat = 24

        profileFrame.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(margin)
            make.height.equalTo(50)
        }

        circleStackView.snp.makeConstraints { make in
            make.top.equalTo(profileFrame.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(margin)
            make.height.equalTo(116)
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
    
    // MARK: - Configure Circle Items
    private func configureCircleItems() {
        guard circleStackView.arrangedSubviews.isEmpty else { return }
        addCircleItem(title: "사회성", tag: "#낯가림 있어요")
        addCircleItem(title: "활동량", tag: "#활발해요")
        addCircleItem(title: "공격성", tag: "#안짖어요")
    }
    
    private func addCircleItem(title: String, tag: String) {
        let circleView = CircleTagView(title: title, tag: tag)
        circleStackView.addArrangedSubview(circleView)
    }
}
