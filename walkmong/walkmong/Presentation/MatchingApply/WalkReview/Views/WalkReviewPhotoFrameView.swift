import UIKit
import SnapKit
import Kingfisher

class WalkReviewPhotoFrameView: UIView {
    private var photoURLs: [URL] = []

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

    func configure(with urls: [URL]) {
        subviews.forEach { $0.removeFromSuperview() }
        photoURLs = urls

        if urls.isEmpty {
            isHidden = true
        } else {
            isHidden = false

            let leftImageView = createImageView()
            leftImageView.tag = 0
            leftImageView.isUserInteractionEnabled = true
            let leftTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto(_:)))
            leftImageView.addGestureRecognizer(leftTapGesture)
            addSubview(leftImageView)
            leftImageView.kf.setImage(with: urls[0], placeholder: UIImage(named: "defaultImage")) // Kingfisher 적용

            leftImageView.snp.makeConstraints {
                $0.top.leading.bottom.equalToSuperview()
                $0.width.equalToSuperview().multipliedBy(0.5).offset(-4)
                $0.height.equalTo(leftImageView.snp.width)
            }

            if urls.indices.contains(1) {
                let rightImageView = createImageView()
                rightImageView.tag = 1
                rightImageView.isUserInteractionEnabled = true
                let rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto(_:)))
                rightImageView.addGestureRecognizer(rightTapGesture)
                addSubview(rightImageView)
                rightImageView.kf.setImage(with: urls[1], placeholder: UIImage(named: "defaultImage")) // Kingfisher 적용

                rightImageView.snp.makeConstraints {
                    $0.top.trailing.bottom.equalToSuperview()
                    $0.leading.equalTo(leftImageView.snp.trailing).offset(8)
                    $0.width.equalToSuperview().multipliedBy(0.5).offset(-4)
                    $0.height.equalTo(rightImageView.snp.width)
                }
            }
        }
    }

    @objc private func didTapPhoto(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view,
              let viewController = getViewController(),
              tappedView.tag < photoURLs.count else { return }

        presentPhotoViewer(from: viewController, photoURLs: photoURLs, currentIndex: tappedView.tag)
    }

    private func presentPhotoViewer(from viewController: UIViewController, photoURLs: [URL], currentIndex: Int) {
        let images: [UIImage] = photoURLs.compactMap { url in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                return image
            }
            return UIImage(named: "defaultImage")
        }

        let photoViewer = PhotoViewerViewController(photos: images, currentIndex: currentIndex)

        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .fade
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        viewController.navigationController?.view.layer.add(transition, forKey: kCATransition)
        viewController.navigationController?.pushViewController(photoViewer, animated: false)
    }

    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }
}
