//
//  WalkTalkListMatchingStateCollectionViewCell.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit

class WalktalkListMatchingStateCollectionViewCell: UICollectionViewCell {
    
    private let frameView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        view.layer.cornerRadius = 18
        view.clipsToBounds = true
        return view
    }()
    
    private let matchingStateLabel = SmallMainHighlightParagraphLabel(text: "매칭상태", textColor: .gray500)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        addSubview(frameView)
        frameView.addSubview(matchingStateLabel)
    }
    
    private func setConstraints() {
        frameView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        matchingStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setContent(text: String) {
        matchingStateLabel.text = text
    }
    
    func setSelected(textColor: UIColor, backgroundColor: UIColor) {
        matchingStateLabel.textColor = textColor
        frameView.backgroundColor = backgroundColor
    }
}
