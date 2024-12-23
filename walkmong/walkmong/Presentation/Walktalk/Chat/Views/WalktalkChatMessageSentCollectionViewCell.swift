//
//  WalktalkChatMessageSentCollectionViewCell.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit

class WalktalkChatMessageSentCollectionViewCell: UICollectionViewCell {
    
    private let messageView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlue
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private let messageLabel: MainParagraphLabel = {
        let label = MainParagraphLabel(text: "메시지 내용")
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let messageTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont(name: "Pretendard-Medium", size: 12)
        label.textColor = .gray400
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubviews(messageView, messageTimeLabel)
        messageView.addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(11)
        }
        
        messageTimeLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualToSuperview().offset(0)
            make.width.greaterThanOrEqualTo(52)
            make.bottom.equalTo(messageView.snp.bottom)
        }
        
        messageView.snp.makeConstraints { make in
            make.leading.equalTo(messageTimeLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }

    }
    func setContent(message: String, time: String){
        messageTimeLabel.text = time
        messageLabel.text = message
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        // 레이아웃 속성 복사
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        // 가로 너비를 고정
        let fixedWidth = layoutAttributes.frame.width
        let targetSize = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)

        // Auto Layout 기반 높이 계산
        let calculatedSize = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        // 디버깅: 계산된 크기 확인
        print("IndexPath: \(layoutAttributes.indexPath), Calculated Size: \(calculatedSize)")

        // 고정된 너비와 계산된 높이 설정
        attributes.frame.size = CGSize(width: fixedWidth, height: calculatedSize.height)
        return attributes
    }


}
