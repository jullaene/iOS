//
//  DogProfileView.swift
//  walkmong
//
//  Created by 신호연 on 11/12/24.
//

import UIKit
import SnapKit

class DogProfileView: UIView {

    // MARK: - UI Components
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let infoStackView = UIStackView()

    // MARK: - Initializer
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

    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .white

        // Profile Image
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 50
        profileImageView.backgroundColor = .gray

        // Name Label
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.text = "강아지 이름"

        // Info Stack View
        infoStackView.axis = .vertical
        infoStackView.spacing = 12
        infoStackView.distribution = .equalSpacing
        infoStackView.alignment = .leading

        ["성별: 남", "나이: 3살", "견종: 포메라니안", "몸무게: 4kg", "중성화 여부: O"].forEach {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .darkGray
            label.text = $0
            infoStackView.addArrangedSubview(label)
        }
    }

    private func setupLayout() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(infoStackView)

        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }

        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
