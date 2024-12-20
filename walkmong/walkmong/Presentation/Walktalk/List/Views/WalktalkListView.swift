//
//  WalktalkListView.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit

class WalktalkListView: UIView {
    
    private let walktalkListMatchingStateCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(WalktalkListCollectionViewCell.self, forCellWithReuseIdentifier: WalktalkListCollectionViewCell.className)
        return collectionView
    }()
    
    private let walktalkListPageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(WalktalkListCollectionViewCell.self, forCellWithReuseIdentifier: WalktalkListCollectionViewCell.className)
        return collectionView
    }()
    
    private let walktalkListTabBarCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(WalktalkListCollectionViewCell.self, forCellWithReuseIdentifier: WalktalkListCollectionViewCell.className)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        walktalkListPageCollectionView.delegate = self
        walktalkListPageCollectionView.dataSource = self
        walktalkListTabBarCollectionView.delegate = self
        walktalkListTabBarCollectionView.dataSource = self
        walktalkListMatchingStateCollectionView.delegate = self
        walktalkListMatchingStateCollectionView.dataSource = self
    }
    
}

extension WalktalkListView: UICollectionViewDelegate {
    
}

extension WalktalkListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case walktalkListPageCollectionView:
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        case walktalkListTabBarCollectionView:
            return CGSize(width: indexPath.row == 0 ? 28 : 41, height: collectionView.bounds.height)
        case walktalkListMatchingStateCollectionView:
            return CGSize(width: indexPath.row == 0 ? 68 : 80, height: collectionView.bounds.height)
        default:
            guard let pageCell = collectionView.superview as? WalktalkListPageCollectionViewCell else { return CGSize() }
            //TODO: 페이지 별 셀 개수
            return CGSize(width: collectionView.bounds.width, height: 144)
        }
    }
}

extension WalktalkListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case walktalkListPageCollectionView:
            return 3
        case walktalkListTabBarCollectionView:
            return 3
        case walktalkListMatchingStateCollectionView:
            return 4
        default:
            guard let pageCell = collectionView.superview as? WalktalkListPageCollectionViewCell else { return 0 }
            //TODO: 페이지 별 셀 개수
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case walktalkListPageCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalktalkListPageCollectionViewCell.className, for: indexPath) as? WalktalkListPageCollectionViewCell else { return UICollectionViewCell() }
            cell.setDelegate(delegate: self)
            //TODO: 매칭 페이지 셀 구현
            return cell
        case walktalkListTabBarCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalktalkListTabBarCollectionViewCell.className, for: indexPath) as? WalktalkListTabBarCollectionViewCell else { return UICollectionViewCell() }
            //TODO: 매칭 유형 셀 구현
            return cell
        case walktalkListMatchingStateCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalktalkListMatchingStateCollectionViewCell.className, for: indexPath) as? WalktalkListMatchingStateCollectionViewCell else { return UICollectionViewCell() }
            //TODO: 매칭 상태 셀 구현
            return cell
        default:
            guard let pageCell = collectionView.superview as? WalktalkListPageCollectionViewCell else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalktalkListCollectionViewCell.className, for: indexPath)
            //TODO: 페이지 별 셀 구현
            return cell
        }
    }
    
    
}
