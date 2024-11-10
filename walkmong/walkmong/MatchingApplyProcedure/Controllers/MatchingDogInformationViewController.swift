//
//  MatchingDogInformationViewController.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit
import SnapKit

class MatchingDogInformationViewController: BaseViewController {
    private var matchingData: MatchingData?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 커스텀 네비게이션 바 설정
        setNavigationBarTitle("프로필")
        addBackButtonAction(self, action: #selector(customBackButtonTapped))

        setupUI()
    }

    func configure(with data: MatchingData) {
        matchingData = data
    }

    private func setupUI() {
        // Safe Area 이외의 기본 배경색 설정
        view.backgroundColor = .white

        // 데이터가 없으면 기본 메시지 표시
        guard let data = matchingData else {
            let emptyLabel = UILabel()
            emptyLabel.text = "강아지 정보가 없습니다."
            emptyLabel.textColor = .gray
            emptyLabel.textAlignment = .center
            view.addSubview(emptyLabel)
            emptyLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            return
        }

        // 강아지 이름 표시
        let nameLabel = UILabel()
        nameLabel.text = data.dogName
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        view.addSubview(nameLabel)

        // 강아지 나이 및 품종 표시
        let infoLabel = UILabel()
        infoLabel.text = "나이: \(data.dogAge)살 / 품종: \(data.breed)"
        infoLabel.font = UIFont.systemFont(ofSize: 16)
        infoLabel.textColor = .darkGray
        infoLabel.textAlignment = .center
        view.addSubview(infoLabel)

        // 강아지 프로필 이미지 표시
        let imageView = UIImageView()
        imageView.image = UIImage(named: data.dogProfile) ?? UIImage(named: "defaultDogImage")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        // 레이아웃 설정
        imageView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120) // 이미지 크기
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }

    @objc private func customBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
