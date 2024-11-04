//
//  DayCell.swift
//  walkmong
//
//  Created by 신호연 on 11/4/24.
//

import UIKit
import SnapKit

class DayCell: UICollectionViewCell {
    
    static let identifier = "DayCell"
    
    private let dayOfWeekLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label.textColor = UIColor(red: 0.081, green: 0.081, blue: 0.076, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textColor = UIColor(red: 0.081, green: 0.081, blue: 0.076, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 30
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(dayOfWeekLabel)
        contentView.addSubview(dayLabel)
        
        dayOfWeekLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(dayOfWeekLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }
    }
    
    func configure(dayOfWeek: String, day: String) {
        dayOfWeekLabel.text = dayOfWeek
        dayLabel.text = day
    }
}
