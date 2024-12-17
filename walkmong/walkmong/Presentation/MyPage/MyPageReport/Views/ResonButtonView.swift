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
    private var isChecked = false
    
    // MARK: - Initializer
    init(text: String) {
        reasonLabel = MainParagraphLabel(text: text, textColor: .gray600)
        super.init(frame: .zero)
        
        self.isUserInteractionEnabled = true
        backgroundColor = .clear // 터치 인식 활성화
        
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
        tapGesture.cancelsTouchesInView = false // 다른 터치 이벤트를 방해하지 않도록 설정
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - 체크 이미지 토글
    @objc private func toggleCheck() {
        isChecked.toggle()
        updateCheckImage()
    }
    
    private func updateCheckImage(force: Bool = false) {
        let imageName = isChecked ? "myPageReportChecked" : "myPageReportUnchecked"
        if let image = UIImage(named: imageName) {
            checkImageView.image = image.withRenderingMode(.alwaysOriginal)
    }
}
