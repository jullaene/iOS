//
//  WalktalkChatMessageReceivedCollectionViewCell.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit

class WalktalkChatMessageReceivedCollectionViewCell: UICollectionViewCell {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .defaultProfile
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private let messageView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private let messageLabel = MainParagraphLabel(text: "메시지 내용")
    
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
        messageLabel.numberOfLines = 50
        addSubviews(messageView, messageTimeLabel, profileImageView)
        messageView.addSubview(messageLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.height.equalTo(32)
            make.top.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(11)
        }
        
        messageTimeLabel.snp.makeConstraints { make in
            make.trailing.lessThanOrEqualToSuperview()
            make.bottom.equalToSuperview()
        }
        
        messageView.snp.makeConstraints { make in
            make.trailing.equalTo(messageTimeLabel.snp.leading).offset(-4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.top.bottom.equalToSuperview()
        }

    }
    
    func setContent(message: String, time: String, profileImage: UIImage){
        profileImageView.image = .defaultProfile //FIXME: 프로필 이미지 로드 필요
        messageTimeLabel.text = time
        messageLabel.text = message
    }
}
