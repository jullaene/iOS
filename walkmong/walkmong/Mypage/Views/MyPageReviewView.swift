//
//  MyPageReviewView.swift
//  walkmong
//
//  Created by 신호연 on 12/11/24.
//

import UIKit
import SnapKit

class MyPageReviewView: UIView {
    
    private let walkerReviewTitle = ReviewTitleView(title: "받은 산책자 후기", count: 5)
    private let ownerReviewTitle = ReviewTitleView(title: "받은 반려인 후기", count: 3)
    
    private let userRatingView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let keywordView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let ownerReviewView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let ownerReviewTitleLabel: UILabel = {
        let label = SmallTitleLabel(text: "김철수님의 반려인 후기", textColor: .gray600)
        return label
    }()
    
    private let participantLabel: UILabel = {
        let label = SmallMainParagraphLabel(text: "10명 참여", textColor: .gray400)
        return label
    }()
    
    private let chartView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(walkerReviewTitle)
        addSubview(userRatingView)
        addSubview(keywordView)
        addSubview(ownerReviewTitle)
        addSubview(ownerReviewView)
        
        ownerReviewView.addSubview(ownerReviewTitleLabel)
        ownerReviewView.addSubview(participantLabel)
        ownerReviewView.addSubview(chartView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        walkerReviewTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(34)
        }
        
        userRatingView.snp.makeConstraints { make in
            make.top.equalTo(walkerReviewTitle.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(340)
        }
        
        keywordView.snp.makeConstraints { make in
            make.top.equalTo(userRatingView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(305)
        }
        
        ownerReviewTitle.snp.makeConstraints { make in
            make.top.equalTo(keywordView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(34)
        }
        
        ownerReviewView.snp.makeConstraints { make in
            make.top.equalTo(ownerReviewTitle.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(128)
            make.bottom.lessThanOrEqualToSuperview().inset(40)
        }
        
        ownerReviewTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(19)
        }
        
        participantLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-19)
            make.centerY.equalTo(ownerReviewTitleLabel)
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(ownerReviewTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(19)
            make.height.equalTo(44)
        }
    }
}

class ReviewTitleView: UIView {
    private let titleLabel: MiddleTitleLabel
    private let countLabel: MainHighlightParagraphLabel = {
        let label = MainHighlightParagraphLabel(text: "0개", textColor: .gray600)
        return label
    }()
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "MyPageReviewArrow"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(title: String, count: Int) {
        self.titleLabel = MiddleTitleLabel(text: title)
        super.init(frame: .zero)
        countLabel.text = "\(count)개"
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(countLabel)
        addSubview(arrowImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-4)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
}
