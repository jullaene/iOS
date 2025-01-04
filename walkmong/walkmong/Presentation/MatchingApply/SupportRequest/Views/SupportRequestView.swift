//
//  SupportRequestView.swift
//  walkmong
//
//  Created by 신호연 on 1/4/25.
//

import UIKit
import SnapKit

class SupportRequestView: UIView {

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
        addSubview(actionButton)

        actionButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(54)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-7)
        }
    }
}
