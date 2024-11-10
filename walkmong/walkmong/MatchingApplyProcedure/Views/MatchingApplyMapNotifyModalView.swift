//
//  MatchingApplyMapNotifyModalView.swift
//  walkmong
//
//  Created by 황채웅 on 11/10/24.
//

import UIKit

class MatchingApplyMapNotifyModalView: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 20
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private let innerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "보호자와 만나서 반려견을 전달받을 장소를 선택해주세요."
        label.numberOfLines = 2
        label.textAlignment = .left
        label.lineBreakStrategy = .hangulWordPriority
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Pretendard-Bold", size: 24)
        label.textColor = .gray600
        let attrString = NSMutableAttributedString(string: label.text!)
        label.setLineSpacing(ratio: 1.4)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "장소 선택 후 보호자와 상의하여 장소를 변경해도 괜찮아요."
        label.numberOfLines = 2
        label.textAlignment = .left
        label.lineBreakStrategy = .hangulWordPriority
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = .gray400
        let attrString = NSMutableAttributedString(string: label.text!)
        label.setLineSpacing(ratio: 1.4)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews(){
        self.addSubview(containerView)
        containerView.addSubview(innerView)
        innerView.addSubviews(titleLabel, subtitleLabel)
    }
    
    private func setConstraints(){
        containerView.snp.makeConstraints { make in
            make.height.equalTo(268)
            make.horizontalEdges.equalToSuperview()
        }
        innerView.snp.makeConstraints { make in
            make.height.equalTo(268)
            make.horizontalEdges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(innerView.snp.top).offset(131)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
