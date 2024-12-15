//
//  MyPageSettingsView.swift
//  walkmong
//
//  Created by 신호연 on 12/11/24.
//

import UIKit
import SnapKit

class MyPageSettingsView: UIView {
    
    private let menuItems: [(String, String)] = [
        ("내가 쓴 산책 후기", "MyPageSettingsArrow"),
        ("지난 산책", "MyPageSettingsArrow"),
        ("공지사항", "MyPageSettingsArrow"),
        ("설정", "MyPageSettingsArrow")
    ]
    
    private let itemHeight: CGFloat = 52
    private let bottomPadding: CGFloat = 19
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 0
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .gray100
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        menuItems.forEach { title, imageName in
            let itemView = createMenuItem(title: title, imageName: imageName)
            stackView.addArrangedSubview(itemView)
        }
        
        let spacerView = UIView()
        spacerView.backgroundColor = .gray100
        addSubview(spacerView)
        spacerView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(bottomPadding)
            make.bottom.equalToSuperview()
        }
    }
    
    private func createMenuItem(title: String, imageName: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .white
        container.snp.makeConstraints { make in
            make.height.equalTo(itemHeight)
        }
        
        let label = UILabel()
        label.text = title
        label.textColor = .mainBlack
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.1
        label.attributedText = NSMutableAttributedString(
            string: title,
            attributes: [
                .kern: -0.32,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: imageName)
        arrowImageView.contentMode = .scaleAspectFit
        
        container.addSubview(label)
        container.addSubview(arrowImageView)
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(28)
        }
        
        return container
    }
}
