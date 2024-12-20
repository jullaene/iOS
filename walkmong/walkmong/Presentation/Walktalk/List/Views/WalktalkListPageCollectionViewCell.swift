//
//  WalktalkListPageCollectionViewCell.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit

class WalktalkListPageCollectionViewCell: UICollectionViewCell {
    
    private let walktalkListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(WalktalkListCollectionViewCell.self, forCellWithReuseIdentifier: WalktalkListCollectionViewCell.className)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDelegate(delegate: UICollectionViewDelegate & UICollectionViewDataSource) {
        walktalkListCollectionView.delegate = delegate
        walktalkListCollectionView.dataSource = delegate
    }
    
}
