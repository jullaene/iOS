//
//  MyPageContentViewSection.swift
//  walkmong
//
//  Created by 신호연 on 12/11/24.
//

import UIKit
import SnapKit

class MyPageContentViewSection: UIView {
    
    private let petView = MyPagePetView()
    private let walkInfoView = MyPageWalkInfoView()
    private let reviewView = MyPageReviewView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        addSubview(petView)
        addSubview(walkInfoView)
        addSubview(reviewView)
    }
    
    private func setupLayout() {
        petView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.right.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(210).priority(.high)
            make.height.lessThanOrEqualTo(242).priority(.high)
        }
        
        walkInfoView.snp.makeConstraints { make in
            make.top.equalTo(petView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(463)
        }
        
        reviewView.snp.makeConstraints { make in
            make.top.equalTo(walkInfoView.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(408).priority(.high)
            make.height.lessThanOrEqualTo(961).priority(.high)
        }
    }
}
