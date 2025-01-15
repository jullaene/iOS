//
//  VaccinationView.swift
//  walkmong
//
//  Created by 신호연 on 11/12/24.
//

import UIKit
import SnapKit

class VaccinationView: UIView {

    // MARK: - Constants
    private struct Constants {
        static let frameWidth: CGFloat = 353
        static let titleHeight: CGFloat = 28
        static let vaccinationFrameHeight: CGFloat = 46
        static let cornerRadius: CGFloat = 5
        static let iconSize: CGFloat = 20
        static let spacing: CGFloat = 12
        static let iconSpacing: CGFloat = 6

        static let titleFont = UIFont(name: "Pretendard-SemiBold", size: 20)!
        static let descriptionFont = UIFont(name: "Pretendard-SemiBold", size: 16)!

        // Colors
        struct Colors {
            static let completedBackground = UIColor(red: 0.913, green: 1, blue: 0.948, alpha: 1)
            static let incompleteBackground = UIColor(red: 0.957, green: 0.929, blue: 0.902, alpha: 1)
            static let completedText = UIColor.mainGreen
            static let incompleteText = UIColor(red: 0.929, green: 0.529, blue: 0.471, alpha: 1)
            static let titleText = UIColor.mainBlack
        }

        // Icon Names
        struct Icons {
            static let completed = "VaccinationCompletedIcon"
            static let incomplete = "VaccinationIncompleteIcon"
        }

        // Texts
        struct Texts {
            static let title = "강아지 예방접종"
            static let completed = "광견병 예방접종을 완료했어요."
            static let incomplete = "광견병 예방접종이 필요합니다."
        }
    }

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        return createLabel(
            text: Constants.Texts.title,
            font: Constants.titleFont,
            color: Constants.Colors.titleText
        )
    }()

    private let vaccinationFrame: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()

    private let iconView = UIImage.createImageView(named: Constants.Icons.completed)

    private let descriptionLabel: UILabel = {
        return createLabel(
            text: Constants.Texts.completed,
            font: Constants.descriptionFont,
            color: Constants.Colors.completedText
        )
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupView() {
        addSubview(titleLabel)
        addSubview(vaccinationFrame)
        vaccinationFrame.addSubview(iconView)
        vaccinationFrame.addSubview(descriptionLabel)
    }

    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.titleHeight)
        }

        vaccinationFrame.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.vaccinationFrameHeight)
        }

        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.spacing)
            make.centerY.equalToSuperview()
            make.size.equalTo(Constants.iconSize)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(Constants.iconSpacing)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-Constants.spacing)
        }
    }

    // MARK: - Public Methods
    func updateVaccinationStatus(rabiesYn: String?) {
        let isVaccinated = (rabiesYn == "Y")
        
        vaccinationFrame.backgroundColor = isVaccinated
            ? Constants.Colors.completedBackground
            : Constants.Colors.incompleteBackground

        iconView.image = UIImage(named: isVaccinated
            ? Constants.Icons.completed
            : Constants.Icons.incomplete)

        descriptionLabel.textColor = isVaccinated
            ? Constants.Colors.completedText
            : Constants.Colors.incompleteText

        descriptionLabel.text = isVaccinated
            ? Constants.Texts.completed
            : Constants.Texts.incomplete
    }

    // MARK: - Helper Methods
    private static func createLabel(text: String, font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17

        label.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .kern: -0.32,
                .paragraphStyle: paragraphStyle
            ]
        )
        label.font = font
        label.textColor = color
        return label
    }

}
