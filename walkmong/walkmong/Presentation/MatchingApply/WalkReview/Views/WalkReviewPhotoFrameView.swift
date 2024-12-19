//
//  WalkReviewPhotoFrameView.swift
//  walkmong
//
//  Created by 신호연 on 12/19/24.
//

import UIKit
import SnapKit

class WalkReviewPhotoFrameView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
    }

    func configure(with photos: [UIImage]) {
        subviews.forEach { $0.removeFromSuperview() }

        if photos.isEmpty {
            isHidden = true
        } else {
            isHidden = false

            let defaultImage = UIImage(named: "defaultImage") ?? UIImage(systemName: "photo")
            let firstImage = photos.indices.contains(0) ? photos[0] : defaultImage
            let secondImage = photos.indices.contains(1) ? photos[1] : defaultImage

            let leftImageView = createImageView(with: firstImage)
            let rightImageView = createImageView(with: secondImage)

            [leftImageView, rightImageView].forEach { addSubview($0) }

            leftImageView.snp.makeConstraints {
                $0.top.leading.bottom.equalToSuperview()
                $0.width.equalToSuperview().multipliedBy(0.5).offset(-4)
                $0.height.equalTo(leftImageView.snp.width)
            }

            rightImageView.snp.makeConstraints {
                $0.top.trailing.bottom.equalToSuperview()
                $0.leading.equalTo(leftImageView.snp.trailing).offset(8)
                $0.width.equalToSuperview().multipliedBy(0.5).offset(-4)
                $0.height.equalTo(rightImageView.snp.width)
            }
        }
    }

    private func createImageView(with image: UIImage?) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }
}
