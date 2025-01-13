//
//  MatchingApplyWalkRequestViewSummarizeView.swift
//  walkmong
//
//  Created by 신호연 on 1/4/25.
//

import UIKit
import SnapKit

final class MatchingApplyWalkRequestViewSummarizeView: UIView {

    private let profileContainerView = UIView()
    private let profileInformationView = DogProfileInformationView()

    private let smallTitle = SmallTitleLabel(text: "소제목", textColor: .gray600)
    private let warningIcon: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(named: "warningIcon") {
            imageView.image = image
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let warningText = SmallMainHighlightParagraphLabel(
        text: "작은 본문 강조",
        textColor: .gray400
    )
    
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
    
    private let setView1 = UIView()
    private let setView2 = UIView()
    private let setView3 = UIView()
    
    private var sectionView1 = UIView()
    private var sectionView2 = UIView()
    private var sectionView3 = UIView()
    
    private let sendMessage = SmallTitleLabel(text: "산책자에게 전달할 메시지", textColor: .gray600)
    
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
                    planEndInformationView,
                    setView1,
                    setView2,
                    setView3,
                    sendMessage)
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
        
        setupLocationSelectionView(
            setView1,
            title: "만남 장소",
            warningText: "매칭 확정 후 산책자와 협의하여 장소를 변경할 수 있어요",
            warningColor: .mainBlue,
            centerLabelText: "산책자가 선택한 장소에서 만나요"
        )
        
        setView1.snp.makeConstraints { make in
            make.top.equalTo(planStartInformationView.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview()
        }
        
        setupLocationSelectionView(
            setView2,
            title: "산책 용품 제공",
            warningText: nil,
            warningColor: nil,
            centerLabelText: "배변봉투, 입마개, 리드줄(목줄)을 제공 가능해요")
        
        setView2.snp.makeConstraints { make in
            make.top.equalTo(setView1.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview()
        }
        
        setupLocationSelectionView(
            setView3,
            title: "사전 만남",
            warningText: "매칭 확정 후 산책자와 상의하여 사전 만남을 진행해 주세요",
            warningColor: .mainBlue,
            centerLabelText: "산책일 전 사전 만남이 가능해요")
        
        setView3.snp.makeConstraints { make in
            make.top.equalTo(setView2.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview()
        }
        
        sendMessage.snp.makeConstraints { make in
            make.top.equalTo(setView3.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview()
        }
        
        
        sectionView1 = createSectionView(
            titleText: "산책 요청 사항(필수)",
            contentText: "기본 텍스트"
        )
        sectionView2 = createSectionView(
            titleText: "산책 유의 사항(필수)",
            contentText: "기본 텍스트"
        )
        sectionView3 = createSectionView(
            titleText: "추가 안내 사항(선택)",
            contentText: "기본 텍스트"
        )
        
        addSubviews(sectionView1, sectionView2, sectionView3)
        sectionView1.snp.makeConstraints { make in
            make.top.equalTo(sendMessage.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        sectionView2.snp.makeConstraints { make in
            make.top.equalTo(sectionView1.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        sectionView3.snp.makeConstraints { make in
            make.top.equalTo(sectionView2.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(90)
        }
    }
    
    private func setupLocationSelectionView(
        _ view: UIView,
        title: String,
        warningText: String?,
        warningColor: UIColor?,
        centerLabelText: String
    ) {
        let locationTitle = SmallTitleLabel(text: title, textColor: .gray600)
        let locationWarningIcon: UIImageView? = {
            guard let warningColor = warningColor else { return nil }
            let icon = Self.createImageView(named: "warningIcon", contentMode: .scaleAspectFit)
            icon.tintColor = warningColor
            return icon
        }()

        let locationWarningText: UILabel? = {
            guard let text = warningText else { return nil }
            return SmallMainHighlightParagraphLabel(text: text, textColor: warningColor ?? .gray400)
        }()

        let whiteBackgroundView = UIView()
        whiteBackgroundView.backgroundColor = .white
        whiteBackgroundView.layer.cornerRadius = 5
        whiteBackgroundView.clipsToBounds = true

        let centerLabel = MainParagraphLabel(text: centerLabelText, textColor: .gray500)

        view.addSubview(locationTitle)
        if let icon = locationWarningIcon {
            view.addSubview(icon)
        }
        if let warningLabel = locationWarningText {
            view.addSubview(warningLabel)
        }
        view.addSubview(whiteBackgroundView)
        whiteBackgroundView.addSubview(centerLabel)

        locationTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }

        if let icon = locationWarningIcon, let warningLabel = locationWarningText {
            icon.snp.makeConstraints { make in
                make.top.equalTo(locationTitle.snp.bottom).offset(4)
                make.leading.equalToSuperview()
            }

            warningLabel.snp.makeConstraints { make in
                make.centerY.equalTo(icon.snp.centerY)
                make.leading.equalTo(icon.snp.trailing).offset(4)
                make.trailing.equalToSuperview()
            }

            whiteBackgroundView.snp.makeConstraints { make in
                make.top.equalTo(icon.snp.bottom).offset(16)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(46)
                make.bottom.equalToSuperview()
            }
        } else {
            whiteBackgroundView.snp.makeConstraints { make in
                make.top.equalTo(locationTitle.snp.bottom).offset(16)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(46)
                make.bottom.equalToSuperview()
            }
        }

        centerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private static func createImageView(named: String, contentMode: UIView.ContentMode, tintColor: UIColor? = nil) -> UIImageView {
        let imageView = UIImageView()
        if let image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate) {
            imageView.image = image
        }
        imageView.contentMode = contentMode
        if let tintColor = tintColor {
            imageView.tintColor = tintColor
        }
        return imageView
    }
    
    private func createSectionView(titleText: String, contentText: String) -> UIView {
        let containerView = UIView()

        let titleLabel = MainHighlightParagraphLabel(text: titleText, textColor: .gray600)
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        let whiteBackgroundView = UIView()
        whiteBackgroundView.backgroundColor = .white
        whiteBackgroundView.layer.cornerRadius = 5
        whiteBackgroundView.clipsToBounds = true
        containerView.addSubview(whiteBackgroundView)
        whiteBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        let contentLabel = MainParagraphLabel(text: contentText, textColor: .gray500)
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.textAlignment = .left
        
        whiteBackgroundView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        return containerView
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
    
    func updateSectionView(texts: [String]) {
        updateContentText(for: sectionView1, newText: texts[0])
        updateContentText(for: sectionView2, newText: texts[1])
        updateContentText(for: sectionView3, newText: texts[2])
    }

    private func updateContentText(for sectionView: UIView?, newText: String) {
        guard let sectionView = sectionView else { return }

        if let contentLabel = sectionView.subviews
            .compactMap({ $0 as? UIView })
            .flatMap({ $0.subviews })
            .compactMap({ $0 as? MainParagraphLabel })
            .first {
            contentLabel.text = newText.isEmpty ? "" : newText
        }
    }
}
