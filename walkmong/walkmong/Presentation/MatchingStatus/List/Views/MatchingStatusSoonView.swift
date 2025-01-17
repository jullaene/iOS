//
//  MatchingStatusSoonView.swift
//  walkmong
//
//  Created by 황채웅 on 1/17/25.
//

import UIKit

protocol MatchingStatusSoonViewDelegate: AnyObject {
    
}

final class MatchingStatusSoonView: UIView {

    weak var delegate: MatchingStatusSoonViewDelegate?
    
    private let profileImageview: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40.5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let matchingStatusLabel = MiddleTitleLabel(text: "현황", textColor: .mainBlack)
    
    private let subLabel = MainHighlightParagraphLabel(text: "부제목", textColor: .mainBlack)
    
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(.arrowIcon, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .mainBlue
        addSubview()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        addSubviews(profileImageview, matchingStatusLabel, subLabel, button)
    }
    
    private func setConstraints() {
        
    }
    
}
