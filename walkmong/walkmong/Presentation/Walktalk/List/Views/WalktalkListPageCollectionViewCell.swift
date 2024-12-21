//
//  WalktalkListPageCollectionViewCell.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit

class WalktalkListPageCollectionViewCell: UICollectionViewCell {
    
    private var selectedMatchingStateIndex: Int?
    private var walktalkListData: WalktalkListModel?
    
    private let walktalkListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(WalktalkListCollectionViewCell.self, forCellWithReuseIdentifier: WalktalkListCollectionViewCell.className)
        return collectionView
    }()
    
    private let walktalkListMatchingStateCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(WalktalkListMatchingStateCollectionViewCell.self, forCellWithReuseIdentifier: WalktalkListMatchingStateCollectionViewCell.className)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(walktalkListCollectionView, walktalkListMatchingStateCollectionView)
        setDelegate()
        setConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDelegate() {
        walktalkListCollectionView.delegate = self
        walktalkListCollectionView.dataSource = self
        walktalkListMatchingStateCollectionView.delegate = self
        walktalkListMatchingStateCollectionView.dataSource = self
    }
    
    private func setConstraints() {
        walktalkListMatchingStateCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(36)
        }
        walktalkListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(walktalkListMatchingStateCollectionView.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func setContent(with dataModel: WalktalkListModel) {
        self.walktalkListData = dataModel
        walktalkListCollectionView.reloadData()
    }
    
}

extension WalktalkListPageCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == walktalkListCollectionView {
            return CGSize(width: collectionView.bounds.width, height: 151)
        }else {
            return CGSize(width: indexPath.row == 0 ? 68 : 80, height: 36)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == walktalkListCollectionView {
            return 0
        }else {
            return 8
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == walktalkListCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        }
    }
}

extension WalktalkListPageCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == walktalkListCollectionView {
            //TODO: 해당 채팅으로 전환
        }else {
            selectedMatchingStateIndex = indexPath.row
            collectionView.reloadData()
        }
        
    }
}

extension WalktalkListPageCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == walktalkListCollectionView {
            return 10 //FIXME: 채팅방 목록 개수
        }else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == walktalkListCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalktalkListCollectionViewCell.className, for: indexPath) as? WalktalkListCollectionViewCell else { return UICollectionViewCell() }
            if let data = walktalkListData {
                cell.setContent(with: data)
            }
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalktalkListMatchingStateCollectionViewCell.className, for: indexPath) as? WalktalkListMatchingStateCollectionViewCell else { return UICollectionViewCell() }
            if indexPath.row == selectedMatchingStateIndex {
                cell.setSelected(textColor: .gray100, backgroundColor: .gray600)
            } else {
                cell.setSelected(textColor: .gray500, backgroundColor: .gray200)
            }
            switch indexPath.row {
            case 0:
                cell.setContent(text: "매칭중")
            case 1:
                cell.setContent(text: "매칭확정")
            case 2:
                cell.setContent(text: "산책완료")
            default:
                cell.setContent(text: "매칭취소")
            }
            return cell
        }
    }
}
