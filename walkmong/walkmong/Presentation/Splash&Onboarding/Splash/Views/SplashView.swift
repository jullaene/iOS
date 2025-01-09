//
//  SplashView.swift
//  walkmong
//
//  Created by 신호연 on 1/2/25.
//

import UIKit
import SnapKit

final class SplashView: UIView {

    // MARK: - UI Components
    private let splashText: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splashText")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let splashLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splashLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let splashIllustration: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splashIllustration")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = UIColor(named: "mainBlue")
        addSubview(splashText)
        addSubview(splashLogo)
        addSubview(splashIllustration)
    }
    
    private func setupConstraints() {
        splashText.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(81)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(splashIllustration.snp.top).offset(-117)
        }
        
        splashIllustration.snp.makeConstraints { make in
            make.top.equalTo(splashText.snp.bottom).offset(117)
            make.centerX.equalToSuperview()
        }
        
        splashLogo.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(29)
            make.centerX.equalToSuperview()
        }
    }
}
