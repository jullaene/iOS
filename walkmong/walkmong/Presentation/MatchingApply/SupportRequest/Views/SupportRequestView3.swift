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

    private let planTitleLabel = SmallTitleLabel(text: "산책 일정")
    private let planStartInformationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    private let planStartLabel = CaptionLabel(text: "산책 시작", textColor: .gray400)
    private let planStartDateLabel: UILabel = {
        let label = MainHighlightParagraphLabel(
            text: "2024.10.25 (금)\n16:00",
            textColor: .mainBlue
        )
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    private let planEndInformationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    private let planEndLabel = CaptionLabel(text: "산책 종료", textColor: .gray400)
    private let planEndDateLabel: UILabel = {
        let label = MainHighlightParagraphLabel(
            text: "2024.10.25 (금)\n16:40",
            textColor: .mainBlue
        )
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    
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
        addSubviews(profileContainerView,
                    planTitleLabel,
                    planStartInformationView,
                    planEndInformationView)
        planStartInformationView.addSubviews(planStartLabel, planStartDateLabel)
        planEndInformationView.addSubviews(planEndLabel, planEndDateLabel)
        profileContainerView.addSubview(profileInformationView)
    }

    private func setupConstraints() {
        profileContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(-20)
            make.top.trailing.equalToSuperview()
            make.height.equalTo(150)
        }

        profileInformationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        planTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileContainerView.snp.bottom).offset(48)
            make.leading.equalToSuperview()
        }
        
        planStartInformationView.snp.makeConstraints { make in
            make.top.equalTo(planTitleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.height.equalTo(89)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-4)
        }
        
        planStartLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalTo(planStartDateLabel.snp.leading)
        }
        
        planStartDateLabel.snp.makeConstraints { make in
            make.top.equalTo(planStartLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
        }
        
        planEndInformationView.snp.makeConstraints { make in     make.top.equalTo(planTitleLabel.snp.bottom).offset(16)
            make.trailing.equalToSuperview()
            make.height.equalTo(89)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-4)
        }
        
        planEndLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalTo(planEndDateLabel.snp.leading)
        }
        
        planEndDateLabel.snp.makeConstraints { make in
            make.top.equalTo(planStartLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
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
