//
//  MatchingStatusWalkInfoForOwnerView.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit
import SnapKit

final class MatchingStatusWalkInfoForOwnerView: UIView {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let dogProfileView = UIView()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        dogProfileView.backgroundColor = .white
        dogProfileView.layer.cornerRadius = 10
        dogProfileView.layer.masksToBounds = true
        
        contentView.addSubview(dogProfileView)
        dogProfileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(187)
        }
    }
    
    // MARK: - 데이터 설정
    func updateDogProfile(with data: MatchingData) {
        dogProfileView.backgroundColor = .white
        dogProfileView.layer.cornerRadius = 10
        
        contentView.addSubviews(dogProfileView)
        
        dogProfileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        let dogProfileCell = MatchingCell()
        dogProfileCell.configure(with: data)
        dogProfileCell.setCustomViewAppearance(
            hideSizeLabel: true,
            hideDistanceLabel: true,
            hideTimeLabel: true,
            backgroundColor: .clear
        )
        dogProfileView.addSubview(dogProfileCell)
        dogProfileCell.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(12)
        }
    }
}
