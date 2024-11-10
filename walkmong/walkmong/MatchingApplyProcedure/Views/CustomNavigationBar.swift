//
//  CustomNavigationBar.swift
//  walkmong
//
//  Created by 신호연 on 11/10/24.
//

import UIKit
import SnapKit

class CustomNavigationBar: UIView {

    private let backButtonContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let backButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BackButton")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.mainBlack
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.backgroundColor = .white

        // 뒤로가기 버튼 컨테이너
        addSubview(backButtonContainer)
        backButtonContainer.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(28)
        }

        backButtonContainer.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButtonContainer.snp.centerY)
        }
    }

    func setTitle(_ title: String) {
        titleLabel.text = title
    }

    func addBackButtonAction(target: Any?, action: Selector) {
        backButtonContainer.gestureRecognizers?.forEach { backButtonContainer.removeGestureRecognizer($0) }
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        backButtonContainer.addGestureRecognizer(tapGesture)
        backButtonContainer.isUserInteractionEnabled = true
    }
}
