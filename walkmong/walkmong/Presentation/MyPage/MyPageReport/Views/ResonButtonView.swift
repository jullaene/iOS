//
//  ReasonButtonView.swift
//  walkmong
//
//  Created by 신호연 on 12/17/24.
//

import UIKit
import SnapKit

class ReasonButtonView: UIView {
    private let checkImageView = UIImageView()
    private let reasonLabel: UILabel
    var isChecked = false
    
    var onCheckStateChanged: (() -> Void)?
    
    // MARK: - Initializer
    init(text: String) {
        reasonLabel = MainParagraphLabel(text: text, textColor: .gray600)
        super.init(frame: .zero)
        
        self.isUserInteractionEnabled = true
        backgroundColor = .clear
        
        setupView()
        setupGesture()
        isChecked = false
        updateCheckImage(force: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View 설정
    private func setupView() {
        addSubview(checkImageView)
        addSubview(reasonLabel)
        
        checkImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.left.centerY.equalToSuperview()
        }
        
        reasonLabel.snp.makeConstraints { make in
            make.left.equalTo(checkImageView.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualToSuperview().offset(-8)
        }
        
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCheck))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func toggleCheck() {
        isChecked.toggle()
        updateCheckImage()
        onCheckStateChanged?()
    }
    
    private func updateCheckImage(force: Bool = false) {
        let imageName = isChecked ? "myPageReportChecked" : "myPageReportUnchecked"
        if let image = UIImage(named: imageName) {
            checkImageView.image = image.withRenderingMode(.alwaysOriginal)
        }
    }
}
