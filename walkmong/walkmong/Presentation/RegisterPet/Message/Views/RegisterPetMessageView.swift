//
//  RegisterPetMessageView.swift
//  walkmong
//
//  Created by 황채웅 on 1/14/25.
//

import UIKit

protocol RegisterPetMessageViewDelegate: AnyObject {
    func didTapNextButton()
}

final class RegisterPetMessageView: UIView {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private let scrollContentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        return contentView
    }()
    
    private let titleLabel = MiddleTitleLabel(text: "산책자에게 전달할 메시지")
    
    private let nextButton = NextButton(text: "등록하기")
    
    weak var delegate: RegisterPetMessageViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
        setConstraints()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubView() {
        addSubviews(scrollView)
        scrollView.addSubviews(scrollContentView, nextButton)
        scrollContentView.addSubviews(titleLabel)

    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
//            make.bottom.equalTo(shotYesButton.snp.bottom).offset(144)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(46)
        }
    }

    private func setUI() {
        nextButton.setButtonState(isEnabled: true)
    }
}
