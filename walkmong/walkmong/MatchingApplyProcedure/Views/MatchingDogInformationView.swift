//
//  MatchingDogInformationView.swift
//  walkmong
//
//  Created by 신호연 on 11/10/24.
//

import UIKit
import SnapKit

class MatchingDogInformationView: UIView {
    
    // MARK: - UI Components
    private let nameLabel = UILabel()
    private let infoLabel = UILabel()
    private let imageView = UIImageView()
    private let emptyLabel = UILabel()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .white
        
        // Empty Label
        emptyLabel.text = "강아지 정보가 없습니다."
        emptyLabel.textColor = .gray
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = true
        addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // Profile Image View
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100) // Layout will be adjusted by the controller
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        // Name Label
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // Info Label
        infoLabel.font = UIFont.systemFont(ofSize: 16)
        infoLabel.textColor = .darkGray
        infoLabel.textAlignment = .center
        addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    func configure(with data: MatchingData?) {
        guard let data = data else {
            emptyLabel.isHidden = false
            imageView.isHidden = true
            nameLabel.isHidden = true
            infoLabel.isHidden = true
            return
        }
        
        emptyLabel.isHidden = true
        imageView.isHidden = false
        nameLabel.isHidden = false
        infoLabel.isHidden = false
        
        imageView.image = UIImage(named: data.dogProfile) ?? UIImage(named: "defaultDogImage")
        nameLabel.text = data.dogName
        infoLabel.text = "나이: \(data.dogAge)살 / 품종: \(data.breed)"
    }
}
