//
//  AlertCell.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit
import SnapKit

class AlertCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 19
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .gray300
        return imageView
    }()
    
    private let categoryLabel: SmallMainHighlightParagraphLabel = {
        let label = SmallMainHighlightParagraphLabel(text: "", textColor: .gray500)
        return label
    }()
    
    private let messageLabel: MainParagraphLabel = {
        let label = MainParagraphLabel(text: "", textColor: .gray600)
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        backgroundColor = .gray100
        contentView.addSubview(profileImageView)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(messageLabel)
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 38, height: 38))
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(16)
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(16)
            make.top.equalTo(categoryLabel.snp.bottom).offset(4)
            make.right.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
    }
    
    // MARK: - Configuration
    
    func configure(with image: UIImage?, categoryText: String, messageText: String, isRead: Bool) {
        if let image = image {
            profileImageView.image = image
            profileImageView.backgroundColor = .clear
        } else {
            profileImageView.image = nil
            profileImageView.backgroundColor = .gray300
        }
        
        categoryLabel.text = categoryText
        messageLabel.text = messageText
        
        if isRead {
            categoryLabel.textColor = .gray400
            messageLabel.textColor = .gray500
            backgroundColor = .gray100
        } else {
            categoryLabel.textColor = .gray500
            messageLabel.textColor = .gray600
            backgroundColor = .white
        }
    }
}
