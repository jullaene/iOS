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
        static let descriptionFont = UIFont(name: "Pretendard-SemiBold", size: 16)!
        static let titleFont = UIFont(name: "Pretendard-SemiBold", size: 20)!
    }

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        label.attributedText = NSAttributedString(
            string: "강아지 예방접종",
            attributes: [
                .kern: -0.32,
                .paragraphStyle: paragraphStyle
            ]
        )
        label.textColor = UIColor.mainBlack
        label.font = Constants.titleFont
        return label
    }()

    private let vaccinationFrame: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.913, green: 1, blue: 0.948, alpha: 1)
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "VaccinationCompletedIcon") // 기본 아이콘 이름
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        label.attributedText = NSAttributedString(
            string: "광견병 예방접종을 완료했어요.",
            attributes: [
                .kern: -0.32,
                .paragraphStyle: paragraphStyle
            ]
        )
        label.textColor = UIColor.mainGreen
        label.font = Constants.descriptionFont
        return label
    }()

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
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
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
            make.width.height.equalTo(Constants.iconSize)
        }

        // Description Label Layout
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(Constants.iconSpacing)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-Constants.spacing)
        }
    }

    // MARK: - Public Methods
    func updateVaccinationStatus(rabiesYn: Bool) {
        if rabiesYn {
            vaccinationFrame.backgroundColor = UIColor(red: 0.913, green: 1, blue: 0.948, alpha: 1)
            iconView.image = UIImage(named: "VaccinationCompletedIcon")
            descriptionLabel.textColor = UIColor.mainGreen
            descriptionLabel.text = "광견병 예방접종을 완료했어요."
        } else {
            vaccinationFrame.backgroundColor = UIColor(red: 0.957, green: 0.929, blue: 0.902, alpha: 1)
            iconView.image = UIImage(named: "VaccinationIncompleteIcon")
            descriptionLabel.textColor = UIColor(red: 0.929, green: 0.529, blue: 0.471, alpha: 1)
            descriptionLabel.text = "광견병 예방접종이 필요합니다."
        }
    }
}
