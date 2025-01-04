//
//  WalktalkListPageCollectionViewCell.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit

final class WalktalkListPageCollectionViewCell: UICollectionViewCell {
    
    private var selectedMatchingStateIndex: Int = 0
    private var selectedTabbarIndex: Int = 0
    private var chatroomResponseData: [ChatroomResponseData] = []
    
    private let walktalkListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(WalktalkListCollectionViewCell.self, forCellWithReuseIdentifier: WalktalkListCollectionViewCell.className)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(walktalkListCollectionView)
        setDelegate()
        setConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDelegate() {
        walktalkListCollectionView.delegate = self
        walktalkListCollectionView.dataSource = self
    }
    
    private func setConstraints() {
        walktalkListCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func setContent(with dataModel: [ChatroomResponseData], selectedMatchingStateIndex: Int, selectedTabbarIndex: Int) {
        self.selectedTabbarIndex = selectedTabbarIndex
        self.selectedMatchingStateIndex = selectedMatchingStateIndex
        self.chatroomResponseData = dataModel
        walktalkListCollectionView.reloadData()
    }
    
}

extension WalktalkListPageCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 151)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension WalktalkListPageCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let VC = WalktalkChatViewController(roomId: chatroomResponseData[indexPath.row].roomId, currentMatchingState: Status.from(index: selectedMatchingStateIndex))
        self.getViewController()?.navigationController?.pushViewController(VC, animated: true)
    }
    
}

extension WalktalkListPageCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatroomResponseData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalktalkListCollectionViewCell.className, for: indexPath) as? WalktalkListCollectionViewCell else { return UICollectionViewCell() }
        cell.setContent(with: chatroomResponseData[indexPath.row], status: Status.from(index: selectedMatchingStateIndex), record: Record.from(index: selectedTabbarIndex))
        return cell
    }
}
