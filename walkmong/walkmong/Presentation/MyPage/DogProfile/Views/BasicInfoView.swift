//
//  BasicInfoView.swift
//  walkmong
//
//  Created by 신호연 on 11/12/24.
//

import UIKit
import SnapKit

class BasicInfoView: UIView {

    // MARK: - UI Components
    private let titleLabel = UILabel()
    private let container = UIView()
    private var infoLabels: [(title: UILabel, content: UILabel)] = []

    private struct Fonts {
        static let title = UIFont(name: "Pretendard-Bold", size: 20)
        static let infoTitle = UIFont(name: "Pretendard-Medium", size: 16)
        static let infoContent = UIFont(name: "Pretendard-SemiBold", size: 16)
    }

    private struct Spacing {
        static let titleTop: CGFloat = 20
        static let titleLeading: CGFloat = 24
        static let contentGap: CGFloat = 8
        static let betweenTitleContent: CGFloat = 48
        static let betweenItems: CGFloat = 12
        static let cornerRadius: CGFloat = 20
    }

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLayout()
    }

    // MARK: - Setup Methods
    private func setupView() {
        // Title Label
        titleLabel.text = "기본정보"
        titleLabel.textColor = UIColor.gray600
        titleLabel.font = Fonts.title
        titleLabel.textAlignment = .left
        addSubview(titleLabel)

        // Container
        container.backgroundColor = UIColor.gray100
        container.layer.cornerRadius = Spacing.cornerRadius
        addSubview(container)

        // Info Labels
        let titles = ["이름", "성별", "나이", "견종", "몸무게", "중성화"]
        titles.forEach { title in
            let titleLabel = createInfoTitleLabel(text: title)
            let contentLabel = createInfoContentLabel(text: "")
            container.addSubview(titleLabel)
            container.addSubview(contentLabel)
            infoLabels.append((title: titleLabel, content: contentLabel))
        }
    }

    private func setupLayout() {
        // Title Label Layout
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(353)
            make.height.equalTo(28)
        }

        // Container Layout
        container.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(212)
        }

        // Info Labels Layout
        for (index, labels) in infoLabels.enumerated() {
            labels.title.snp.makeConstraints { make in
                if index == 0 {
                    make.top.equalToSuperview().offset(Spacing.titleTop)
                } else {
                    make.top.equalTo(infoLabels[index - 1].title.snp.bottom).offset(Spacing.betweenItems)
                }
                make.leading.equalToSuperview().offset(Spacing.titleLeading)
            }

            if index == 0 {
                // 첫 번째 항목의 contentLabel leading을 기준으로 고정
                labels.content.snp.makeConstraints { make in
                    make.centerY.equalTo(labels.title)
                    make.leading.equalTo(labels.title.snp.trailing).offset(Spacing.betweenTitleContent)
                }
            } else {
                // 나머지는 첫 번째 contentLabel의 leading을 기준으로 동일하게 설정
                labels.content.snp.makeConstraints { make in
                    make.centerY.equalTo(labels.title)
                    make.leading.equalTo(infoLabels[0].content.snp.leading)
                }
            }
        }
    }

    // MARK: - Helper Methods
    private func createInfoTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.gray500
        label.font = Fonts.infoTitle
        label.textAlignment = .left
        return label
    }

    private func createInfoContentLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.mainBlue
        label.font = Fonts.infoContent
        label.textAlignment = .left
        return label
    }

    // MARK: - Public Methods
    func configure(
        with dogName: String?,
        dogGender: String?,
        dogAge: String?,
        breed: String?,
        weight: String?,
        neuteringYn: String?
    ) {
        let contentData = [dogName, dogGender, dogAge, breed, weight, neuteringYn]

        for (index, content) in contentData.enumerated() {
            guard index < infoLabels.count else { continue }
            infoLabels[index].content.text = content ?? "정보 없음"
        }
    }
}
