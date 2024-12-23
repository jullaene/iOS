//
//  PhotoViewerViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/21/24.
//

import UIKit


class PhotoViewerViewController: UIViewController {
    private var photos: [UIImage]
    private var currentIndex: Int

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = view.bounds.size

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoViewerCell.self, forCellWithReuseIdentifier: PhotoViewerCell.identifier)
        return collectionView
    }()

    init(photos: [UIImage], currentIndex: Int) {
        self.photos = photos
        self.currentIndex = currentIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        setupCustomNavigationBar()
        collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
    }

    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }

    private func setupCustomNavigationBar() {
        addCustomNavigationBar(
            titleText: "사진 보기",
            showLeftBackButton: false,
            showLeftCloseButton: false,
            showRightCloseButton: true,
            showRightRefreshButton: false,
            backgroundColor: .clear
        )
        
        if let rightCloseButton = navigationItem.rightBarButtonItem?.customView as? UIButton {
            rightCloseButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        }
    }

    @objc private func didTapClose() {
        print("didTapClose triggered")

        let transition = CATransition()
        transition.duration = 0.2
        transition.type = .fade
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)

        guard let navigationController = navigationController else {
            dismiss(animated: true, completion: nil)
            return
        }

        navigationController.view.layer.add(transition, forKey: kCATransition)
        navigationController.popViewController(animated: false)

        print("Transition animation applied")
    }
}

extension PhotoViewerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoViewerCell.identifier, for: indexPath) as! PhotoViewerCell
        cell.configure(with: photos[indexPath.item])
        return cell
    }
}

class PhotoViewerCell: UICollectionViewCell {
    static let identifier = "PhotoViewerCell"

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.bouncesZoom = true
        return scrollView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)

        scrollView.delegate = self
        scrollView.frame = contentView.bounds
        imageView.frame = scrollView.bounds
    }

    func configure(with image: UIImage) {
        imageView.image = image
    }
}

extension PhotoViewerCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
