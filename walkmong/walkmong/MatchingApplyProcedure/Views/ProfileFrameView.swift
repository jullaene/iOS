//
//  ProfileFrameView.swift
//  walkmong
//
//  Created by 신호연 on 12/7/24.
//

import UIKit
import SnapKit

class ProfileFrameView: UIView {
    
    // MARK: - Subviews
    private let profileImageView = UIImageView()
    private let reviewerIdLabel = MainHighlightParagraphLabel(text: "산책할래말래", textColor: .gray600)
    private let walkDateLabel = SmallMainParagraphLabel(text: "2024년 11월 23일 산책 진행", textColor: .gray500)
    private let reportLabel: UILabel = {
        let label = UILabel()
        label.text = "신고하기"
        label.textColor = UIColor.gray400
        label.font = UIFont(name: "Pretendard-Light", size: 12)
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray400
        return view
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    private func setupView() {
        backgroundColor = .clear

        // Configure Profile Image
        profileImageView.layer.cornerRadius = 22
        profileImageView.clipsToBounds = true
        profileImageView.image = UIImage(named: "defaultImage")
        
        // Add Subviews
        [profileImageView, reviewerIdLabel, walkDateLabel, reportLabel, underlineView].forEach {
            addSubview($0)
        }
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        reviewerIdLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(9)
            make.top.equalToSuperview()
        }
        
        walkDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(reviewerIdLabel)
            make.bottom.equalToSuperview()
        }
        
        reportLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(reportLabel.snp.bottom).offset(1) // 밑줄 간격 조정
            make.centerX.equalTo(reportLabel)
            make.width.equalTo(reportLabel)
            make.height.equalTo(0.5) // 밑줄 두께
        }
    }
}
