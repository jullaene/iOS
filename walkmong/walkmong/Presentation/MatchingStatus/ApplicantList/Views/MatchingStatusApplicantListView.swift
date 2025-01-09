//
//  MatchingStatusApplicantListView.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit
import SnapKit

final class MatchingStatusApplicantListView: UIView {
    
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
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    // MARK: - Configure Content
    func configureContent(with data: MatchingData) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        dogProfileView.backgroundColor = .gray100
        dogProfileView.layer.cornerRadius = 10
        contentView.addSubview(dogProfileView)
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
            make.height.equalTo(151)
        }
        
        dogProfileView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-32)
        }
    }
}
