//
//  WalktalkListCollectionViewCell.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit

class WalktalkListCollectionViewCell: UICollectionViewCell {
    
    private let matchingStateView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14.5
        view.backgroundColor = .mainBlue
        return view
    }()

    private let matchingStateLabel = CaptionLabel(text: "매칭 상태", textColor: .white)
    
    private let dateLabel = MainHighlightParagraphLabel(text: "매칭 일시")
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 31
        return imageView
    }()
    
    private let walkerIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .defaultProfile
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let nameLabel = MainHighlightParagraphLabel(text: "반려견 이름", textColor: .gray600)
    
    private let timeLabel: SmallMainHighlightParagraphLabel = {
        let label = SmallMainHighlightParagraphLabel(text: "시각", textColor: .gray400)
        label.textAlignment = .right
        return label
    }()
    
    private let textPreviewLabel = SmallMainHighlightParagraphLabel(text: "대화 내용", textColor: .gray400)
    
    private let chatCountView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlue
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let chatCountLabel = CaptionLabel(text: "10", textColor: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubviews(matchingStateView,
                    dateLabel,
                    profileImageView,
                    walkerIconView,
                    nameLabel,
                    timeLabel,
                    textPreviewLabel,
                    chatCountView)
        matchingStateView.addSubview(matchingStateLabel)
        chatCountView.addSubview(chatCountLabel)
    }
    
    private func setConstraints() {
        matchingStateView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(67)
            make.height.equalTo(29)
        }
        matchingStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalTo(nameLabel.snp.leading)
        }
        profileImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(62)
        }
        walkerIconView.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.trailing.equalTo(profileImageView.snp.trailing).offset(4)
            make.width.height.equalTo(24)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(8)
            make.leading.equalTo(walkerIconView.snp.trailing).offset(16)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-24)
        }
        textPreviewLabel.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom).offset(-8)
            make.leading.equalTo(walkerIconView.snp.trailing).offset(16)
        }
        chatCountView.snp.makeConstraints { make in
            make.centerY.equalTo(textPreviewLabel.snp.centerY)
            make.height.equalTo(20)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-32)
        }
        chatCountLabel.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(6)
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(6)
        }
    }
    
    func setContent(with datamodel: WalktalkListModel) {
        matchingStateLabel.text = datamodel.matchingState.rawValue
        switch datamodel.matchingState {
        case .matching:
            matchingStateView.backgroundColor = .lightBlue
            matchingStateLabel.textColor = .mainBlue
        case .confirmed:
            matchingStateView.backgroundColor = .mainBlue
            matchingStateLabel.textColor = .white
        case .ended:
            matchingStateView.backgroundColor = .gray400
            matchingStateLabel.textColor = .white
        case .cancelled:
            matchingStateView.backgroundColor = .gray200
            matchingStateLabel.textColor = .gray400
        }
        dateLabel.text = datamodel.date
        walkerIconView.isHidden = datamodel.isWalker
        nameLabel.text = datamodel.name
        textPreviewLabel.text = datamodel.textPreview
        chatCountLabel.text = String(datamodel.chatCount)
        profileImageView.image = .defaultProfile
        timeLabel.text = datamodel.time
    }
    
}