//
//  MatchingDogInformationViewController.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit

class MatchingDogInformationViewController: UIViewController {
    private var matchingData: MatchingData?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func configure(with data: MatchingData) {
        matchingData = data
    }

    private func setupUI() {
        view.backgroundColor = .white

        if let data = matchingData {
            let nameLabel = UILabel()
            nameLabel.text = data.dogName
            nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
            nameLabel.textColor = .black
            view.addSubview(nameLabel)
            nameLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    }
}
