//
//  WalkReviewPhotoFrameView.swift
//  walkmong
//
//  Created by 신호연 on 12/19/24.
//

import UIKit
import SnapKit

class WalkReviewPhotoFrameView: UIView {
    private var photoData: [UIImage] = []

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
        photoData = photos

        if photos.isEmpty {
            isHidden = true
        } else {
            isHidden = false

            let firstImage = photos[0]
            let secondImage = photos.indices.contains(1) ? photos[1] : nil

            let leftImageView = createImageView(with: firstImage)
            leftImageView.tag = 0
            leftImageView.isUserInteractionEnabled = true
            let leftTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto(_:)))
            leftImageView.addGestureRecognizer(leftTapGesture)

            addSubview(leftImageView)
            leftImageView.snp.makeConstraints {
                $0.top.leading.bottom.equalToSuperview()
                $0.width.equalToSuperview().multipliedBy(0.5).offset(-4)
                $0.height.equalTo(leftImageView.snp.width).multipliedBy(1).priority(.required)
            }

            if let secondImage = secondImage {
                let rightImageView = createImageView(with: secondImage)
                rightImageView.tag = 1
                rightImageView.isUserInteractionEnabled = true
                let rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto(_:)))
                rightImageView.addGestureRecognizer(rightTapGesture)

                addSubview(rightImageView)
                rightImageView.snp.makeConstraints {
                    $0.top.trailing.bottom.equalToSuperview()
                    $0.leading.equalTo(leftImageView.snp.trailing).offset(8)
                    $0.width.equalToSuperview().multipliedBy(0.5).offset(-4)
                    $0.height.equalTo(leftImageView.snp.width).multipliedBy(1).priority(.required)
                }
            }
        }
    }

    @objc private func didTapPhoto(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view,
              let viewController = findParentViewController(),
              tappedView.tag < photoData.count else { return }

        presentPhotoViewer(from: viewController, photos: photoData, currentIndex: tappedView.tag)
    }

    private func presentPhotoViewer(from viewController: UIViewController, photos: [UIImage], currentIndex: Int) {
        let photoViewer = PhotoViewerViewController(photos: photos, currentIndex: currentIndex)

        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .fade
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        viewController.navigationController?.view.layer.add(transition, forKey: kCATransition)
        viewController.navigationController?.pushViewController(photoViewer, animated: false)
    }

    private func findParentViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

    private func createImageView(with image: UIImage?) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }
}
