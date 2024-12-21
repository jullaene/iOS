//
//  WalktalkChatDateHeaderView.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit

class WalktalkChatDateHeaderView: UICollectionReusableView {
    
    private let frameView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 13)
        label.textColor = .gray500
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        addSubviews(frameView)
        frameView.addSubview(dateLabel)
        frameView.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
            make.height.equalTo(26)
        }
        dateLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setContent(date: String) {
        dateLabel.text = date
    }
}
