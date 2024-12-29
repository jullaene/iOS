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
    
    let titleLabel = MainParagraphLabel(text: "", textColor: .white)
    
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
        updateTitleLabel()
        
        collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
    }

    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }

    private func setupCustomNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)

        let navigationBarView = UIView()
        navigationBarView.backgroundColor = .clear
        view.addSubview(navigationBarView)

        navigationBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
        }
        
        titleLabel.text = "\(currentIndex + 1)/\(photos.count)"
        titleLabel.textAlignment = .center
        navigationBarView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        let closeButton = UIButton()
        closeButton.setImage(.deleteButton.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        navigationBarView.addSubview(closeButton)

        closeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(24)
        }
    }
    
    private func updateTitleLabel() {
        titleLabel.text = "\(currentIndex + 1)/\(photos.count)"
    }

    @objc private func didTapClose() {

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

    }
}

extension PhotoViewerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoViewerCell.identifier, for: indexPath) as! PhotoViewerCell
        cell.configure(with: photos[indexPath.item])
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        currentIndex = pageIndex
        updateTitleLabel()
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
