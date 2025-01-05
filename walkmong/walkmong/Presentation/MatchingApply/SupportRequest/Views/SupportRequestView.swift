//
//  SupportRequestView.swift
//  walkmong
//
//  Created by 신호연 on 1/4/25.
//

import UIKit
import SnapKit

final class SupportRequestView: UIView {

    let scrollView = UIScrollView()
    let contentView = UIView()

    let middleTitleLabel = MiddleTitleLabel(text: "중제목")

    let actionButton: UIButton = UIButton.createStyledButton(
        type: .large,
        style: .light,
        title: "다음으로"
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubviews(scrollView, actionButton)

        scrollView.addSubview(contentView)

        contentView.addSubview(middleTitleLabel)
        
        setupLayout()
    }

    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(140)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(actionButton.snp.top).offset(-12)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview()
        }

        middleTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(39)
            make.leading.equalToSuperview().offset(18)
        }

        actionButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(54)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-7)
        }
    }
}
