//
//  SupportRequestView3.swift
//  walkmong
//
//  Created by 신호연 on 1/4/25.
//

import UIKit
import SnapKit

final class SupportRequestView3: UIView {

    private let profileContainerView = UIView()
    private let profileInformationView = DogProfileInformationView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(profileContainerView)
        profileContainerView.addSubview(profileInformationView)
    }

    private func setupConstraints() {
        profileContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(-20)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        profileInformationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func configureView() {
        profileInformationView.configure(
            isFemale: true,
            name: "봄별이",
            informationText: "소형견 · 말티즈 · 4kg",
            location: "노원구 공릉동",
            profileImage: UIImage(named: "puppyImage01") ?? UIImage()
        )
    }
}
