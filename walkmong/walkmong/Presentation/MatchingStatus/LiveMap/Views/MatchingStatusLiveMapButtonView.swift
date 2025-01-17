//
//  MatchingStatusLiveMapButtonView.swift
//  walkmong
//
//  Created by 황채웅 on 1/16/25.
//

import UIKit

protocol MatchingStatusLiveMapButtonViewDelegate: AnyObject {
    func didTapContactButton()
    func didTapEndButton()
}

final class MatchingStatusLiveMapButtonView: UIView {
    
    weak var delegate: MatchingStatusLiveMapButtonViewDelegate?
    
    private let isWalker: Bool
    
    private let contactButton: UIButton = {
        let button = UIButton()
        button.setTitle("산책자 연락하기", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.titleLabel?.textColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    private lazy var endButton: UIButton = {
        let button = UIButton()
        button.setTitle("산책 종료", for: .normal)
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 15
        button.backgroundColor = .gray600
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    init(isWalker: Bool) {
        self.isWalker = isWalker
        super.init(frame: .zero)
        self.backgroundColor = .white
        addSubview()
        setConstraints()
        setButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubview() {
        if isWalker {
            addSubview(contactButton)
        }else {
            addSubviews(contactButton, endButton)
        }
    }
    
    func setConstraints() {
        if isWalker {
            contactButton.setTitle("반려인 연락하기", for: .normal)
            contactButton.backgroundColor = .gray600
            contactButton.setTitleColor(.white, for: .normal)
            contactButton.snp.makeConstraints { make in
                make.height.equalTo(54)
                make.horizontalEdges.equalToSuperview().inset(20)
                make.top.equalToSuperview().offset(12)
            }
        }else {
            contactButton.backgroundColor = .gray300
            contactButton.setTitleColor(.mainBlack, for: .normal)
            contactButton.snp.makeConstraints { make in
                make.height.equalTo(54)
                make.leading.equalToSuperview().offset(20)
                make.top.equalToSuperview().offset(12)
                make.trailing.equalTo(self.snp.centerX).offset(-4)
            }
            endButton.snp.makeConstraints { make in
                make.height.equalTo(54)
                make.trailing.equalToSuperview().offset(-20)
                make.top.equalToSuperview().offset(12)
                make.leading.equalTo(self.snp.centerX).offset(4)
            }
        }
    }
    private func setButtonAction() {
        contactButton.addTarget(self, action: #selector(contactButtonAction), for: .touchUpInside)
        endButton.addTarget(self, action: #selector(endButtonAction), for: .touchUpInside)
    }
    
    @objc private func contactButtonAction() {
        delegate?.didTapContactButton()
    }
    
    @objc private func endButtonAction() {
        delegate?.didTapEndButton()
    }
}
