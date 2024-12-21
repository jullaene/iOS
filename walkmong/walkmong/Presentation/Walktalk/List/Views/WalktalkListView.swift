//
//  WalktalkListView.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit

class WalktalkListView: UIView {
    
    private var selectedTabBarIndex: Int = 0
    
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
        addSubview()
        setConstraints()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        addSubviews(walktalkListPageCollectionView, walktalkListTabBarCollectionView)
    }
    
    private func setConstraints() {
        walktalkListPageCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(22)
        }
        walktalkListTabBarCollectionView.snp.makeConstraints { make in
            
        }
    }
    
    private func configureCollectionView() {
        walktalkListPageCollectionView.delegate = self
        walktalkListPageCollectionView.dataSource = self
        walktalkListTabBarCollectionView.delegate = self
        walktalkListTabBarCollectionView.dataSource = self
    }
    
}

extension WalktalkListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == walktalkListTabBarCollectionView {
            selectedTabBarIndex = indexPath.row
            collectionView.reloadData()
        }
    }
}

extension WalktalkListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == walktalkListPageCollectionView {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        }else {
            return CGSize(width: indexPath.row == 0 ? 28 : 41, height: collectionView.bounds.height)
        }
    }
}

extension WalktalkListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == walktalkListPageCollectionView {
            return 3
        }else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == walktalkListPageCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalktalkListPageCollectionViewCell.className, for: indexPath) as? WalktalkListPageCollectionViewCell else { return UICollectionViewCell() }
            //TODO: 매칭 페이지 셀 구현
            
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalktalkListTabBarCollectionViewCell.className, for: indexPath) as? WalktalkListTabBarCollectionViewCell else { return UICollectionViewCell() }
            //TODO: 매칭 유형 셀 구현
            if indexPath.row == selectedTabBarIndex {
                cell.setSelected(textColor: .mainBlack)
            }else {
                cell.setSelected(textColor: .gray400)
            }
            switch indexPath.row {
            case 0:
                cell.setContent(text: "전체")
            case 1:
                cell.setContent(text: "산책자")
            default:
                cell.setContent(text: "반려인")
            }
            return cell
        }
    }
}
