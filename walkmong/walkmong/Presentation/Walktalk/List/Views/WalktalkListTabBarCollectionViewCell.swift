//
//  WalktalkListTapBarCollectionViewCell.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit

class WalktalkListTabBarCollectionViewCell: UICollectionViewCell {
    
    private let tabBarLabel = MainHighlightParagraphLabel(text: "탭바 목록")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tabBarLabel)
        tabBarLabel.snp.makeConstraints{ make in
            make.center.equalToSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(text: String) {
        tabBarLabel.text = text
    }
    
    func setSelected(textColor: UIColor) {
        tabBarLabel.textColor = textColor
    }
}
