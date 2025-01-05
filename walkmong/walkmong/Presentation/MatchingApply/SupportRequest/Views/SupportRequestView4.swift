//
//  SupportRequestView4.swift
//  walkmong
//
//  Created by 신호연 on 1/4/25.
//

import UIKit
import SnapKit

final class SupportRequestView4: UIView {

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    private let texts = [
        "1. 산책 시 반려견의 인식표를 반드시 부착해 주시고 리드줄(목줄)은 길이 2m 이하로 준비해 주시기 바랍니다.",
        "2. 산책 전 제공하기로 한 산책 용품을 준비해 주시고, 산책자를 만날 때 지참해 주세요.",
        "3. 사전 만남은 산책 일자 전에 산책자와 협의하여 진행해 주세요.",
        "4. 다른 동물과의 인사 가능 여부, 오토바이 소음에 대한 대처법 등 산책 시 주의사항을 사전에 명확히 전달해 주세요.",
        "5. 위 사항을 준수하지 않아 발생한 사고의 책임은 보호자에게 있습니다."
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        addSubview(contentView)
        
        for text in texts {
            let container = UIView()
            contentView.addSubview(container)
            
            let numberLabel = MainParagraphLabel(
                text: String(text.prefix(2)),
                textColor: .black
            )
            numberLabel.textAlignment = .center
            container.addSubview(numberLabel)
            
            let paragraphLabel = MainParagraphLabel(
                text: String(text.dropFirst(2)),
                textColor: .gray600
            )
            paragraphLabel.numberOfLines = 0
            paragraphLabel.lineBreakMode = .byWordWrapping
            container.addSubview(paragraphLabel)
            
            numberLabel.snp.makeConstraints { make in
                make.width.equalTo(22)
                make.leading.top.equalToSuperview()
                make.bottom.lessThanOrEqualToSuperview()
            }
            
            paragraphLabel.snp.makeConstraints { make in
                make.leading.equalTo(numberLabel.snp.trailing).offset(8)
                make.top.bottom.equalToSuperview()
                make.trailing.equalToSuperview()
            }
            
            container.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(20)
            }
        }
    }
    
    private func setupLayout() {
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        var previousContainer: UIView? = nil
        
        for subview in contentView.subviews {
            subview.snp.makeConstraints { make in
                if let previous = previousContainer {
                    make.top.equalTo(previous.snp.bottom).offset(20)
                } else {
                    make.top.equalToSuperview().offset(20)
                }
            }
            previousContainer = subview
        }
        
        previousContainer?.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}
