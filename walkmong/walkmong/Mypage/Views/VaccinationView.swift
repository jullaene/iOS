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
        static let completedBackgroundColor = UIColor(red: 0.913, green: 1, blue: 0.948, alpha: 1)
        static let incompleteBackgroundColor = UIColor(red: 0.957, green: 0.929, blue: 0.902, alpha: 1)
        static let completedTextColor = UIColor.mainGreen
        static let incompleteTextColor = UIColor(red: 0.929, green: 0.529, blue: 0.471, alpha: 1)

        // Icon Names
        static let completedIcon = "VaccinationCompletedIcon"
        static let incompleteIcon = "VaccinationIncompleteIcon"
    }

    // MARK: - UI Components
    private let titleLabel = VaccinationView.createLabel(
        text: "강아지 예방접종",
        font: Constants.titleFont,
        color: UIColor.mainBlack
    )
    
    private let vaccinationFrame: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.backgroundColor = Constants.completedBackgroundColor
        return view
    }()

    private let iconView = VaccinationView.createImageView(iconName: Constants.completedIcon)
    
    private let descriptionLabel = VaccinationView.createLabel(
        text: "광견병 예방접종을 완료했어요.",
        font: Constants.descriptionFont,
        color: Constants.completedTextColor
    )

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
        addSubview(titleLabel)
        addSubview(vaccinationFrame)
        vaccinationFrame.addSubview(iconView)
        vaccinationFrame.addSubview(descriptionLabel)
    }

    private func setupLayout() {
        // Title Label Layout
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.titleHeight)
        }

        // Vaccination Frame Layout
        vaccinationFrame.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.vaccinationFrameHeight)
        }

        // Icon View Layout
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.spacing)
            make.centerY.equalToSuperview()
            make.size.equalTo(Constants.iconSize)
        }

        // Description Label Layout
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(Constants.iconSpacing)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-Constants.spacing)
        }
    }

    // MARK: - Public Methods
    func updateVaccinationStatus(rabiesYn: String) {
        let isVaccinated = rabiesYn == "Y"
        vaccinationFrame.backgroundColor = isVaccinated ? Constants.completedBackgroundColor : Constants.incompleteBackgroundColor
        iconView.image = UIImage(named: isVaccinated ? Constants.completedIcon : Constants.incompleteIcon)
        descriptionLabel.textColor = isVaccinated ? Constants.completedTextColor : Constants.incompleteTextColor
        descriptionLabel.text = isVaccinated ? "광견병 예방접종을 완료했어요." : "광견병 예방접종이 필요합니다."
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

    private static func createImageView(iconName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: iconName)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}
