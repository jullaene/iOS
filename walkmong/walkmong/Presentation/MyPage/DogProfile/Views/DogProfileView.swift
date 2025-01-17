//
//  DogProfileView.swift
//  walkmong
//
//  Created by 신호연 on 11/12/24.
//

import UIKit
import SnapKit
import Kingfisher

class DogProfileView: UIView, UIScrollViewDelegate {

    // MARK: - Constants
    private struct Constants {
        static let imageSize: CGFloat = 220
        static let imageTopMargin: CGFloat = 15
        static let contentStartMargin: CGFloat = 16
        static let frameSpacing: CGFloat = 52
        static let bottomPadding: CGFloat = 40
    }

    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceVertical = true
        return view
    }()

    private let contentView = UIView()
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.imageSize / 2
        return imageView
    }()
    private let basicInfoFrame = BasicInfoView()
    private let socialInfoFrame = SocialInfoView()
    private let vaccinationFrame = VaccinationView()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(profileImageView, basicInfoFrame, socialInfoFrame, vaccinationFrame)
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        profileImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.imageSize)
            $0.top.equalToSuperview().offset(Constants.imageTopMargin)
            $0.centerX.equalToSuperview()
        }

        basicInfoFrame.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(Constants.contentStartMargin)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(252)
        }

        socialInfoFrame.snp.makeConstraints {
            $0.top.equalTo(basicInfoFrame.snp.bottom).offset(Constants.frameSpacing)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        vaccinationFrame.snp.makeConstraints {
            $0.top.equalTo(socialInfoFrame.snp.bottom).offset(Constants.frameSpacing)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(86)
        }

        contentView.snp.makeConstraints {
            $0.bottom.equalTo(vaccinationFrame.snp.bottom).offset(Constants.bottomPadding)
        }
    }

    // MARK: - Configuration Methods
    func configureProfileImage(with imageURLs: [String?]) {
        guard let firstImageURL = imageURLs.first, let urlString = firstImageURL, let url = URL(string: urlString) else {
            profileImageView.image = UIImage(named: "placeholder")
            return
        }
        profileImageView.kf.setImage(with: url)
    }

    func configureBasicInfo(
        dogName: String?,
        dogGender: String?,
        dogAge: Int?,
        breed: String?,
        weight: Double?,
        neuteringYn: String?
    ) {
        let dogName = dogName ?? "이름 없음"
        let dogGender = dogGender == "FEMALE" ? "여" : "남"
        let dogAgeString = (dogAge != nil) ? "\(dogAge!)살" : "알 수 없음"
        let breed = breed ?? "견종 정보 없음"
        let weightString: String

        if let weight = weight {
            if weight < 1 {
                weightString = "\(Int(weight * 1000))g"
            } else if weight == floor(weight) {
                weightString = "\(Int(weight))kg"
            } else {
                weightString = "\(weight)kg"
            }
        } else {
            weightString = "알 수 없음"
        }

        let neuteringYn = neuteringYn == "Y" ? "O" : "X"

        basicInfoFrame.configure(
            with: dogName,
            dogGender: dogGender,
            dogAge: dogAgeString,
            breed: breed,
            weight: weightString,
            neuteringYn: neuteringYn
        )
    }

    func configureSocialInfo(bite: String, friendly: String, barking: String) {
        socialInfoFrame.configure(bite: bite, friendly: friendly, barking: barking)
    }

    func configureVaccinationStatus(rabiesYn: String) {
        vaccinationFrame.updateVaccinationStatus(rabiesYn: rabiesYn)
    }
}
