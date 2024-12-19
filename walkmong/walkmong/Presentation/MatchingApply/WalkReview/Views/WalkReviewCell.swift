//
//  WalkReviewCell.swift
//  walkmong
//
//  Created by 신호연 on 12/7/24.
//

import UIKit
import SnapKit

class WalkReviewCell: UIView {
    private let roundedContainer = UIView()
    private let contentContainer = UIView()
    private let profileFrame = ProfileFrameView()
    private var dynamicViews = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        addSubview(roundedContainer)
        setupRoundedContainer()
        setupInitialSubviews()
    }
    
    private func setupRoundedContainer() {
        roundedContainer.backgroundColor = .white
        roundedContainer.layer.cornerRadius = 15
        roundedContainer.clipsToBounds = true
        roundedContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        roundedContainer.addSubview(contentContainer)
        contentContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    private func setupInitialSubviews() {
        addDynamicSubview(profileFrame, height: 44, topInset: 0)
    }
    
    func addDynamicSubview(_ view: UIView, height: CGFloat, topInset: CGFloat = 16) {
        contentContainer.addSubview(view)
        view.snp.makeConstraints { make in
            make.height.equalTo(height)
            make.leading.trailing.equalToSuperview()
            if let lastView = dynamicViews.last {
                make.top.equalTo(lastView.snp.bottom).offset(24)
            } else {
                make.top.equalToSuperview().inset(topInset)
            }
        }
        dynamicViews.append(view)

        view.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20).priority(.low)
        }
    }
    
    private func updateLastViewConstraints() {
        for subview in contentContainer.subviews {
            subview.snp.removeConstraints()
        }
        
        if let lastView = dynamicViews.last {
            lastView.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(20)
            }
        }
    }
    
    var totalHeight: CGFloat {
        return dynamicViews.reduce(0) { $0 + $1.bounds.height }
            + CGFloat(dynamicViews.count - 1) * 24
            + 40
    }
    
    func configure(with model: DogReviewModel) {
        profileFrame.configure(with: model.profileData)
        
        let totalRatingView = UIView()
        totalRatingView.backgroundColor = .gray100
        totalRatingView.layer.cornerRadius = 15
        addDynamicSubview(totalRatingView, height: 317)
        
        let tagView = UIView()
        tagView.backgroundColor = .green
        addDynamicSubview(tagView, height: 30)
    }
}
