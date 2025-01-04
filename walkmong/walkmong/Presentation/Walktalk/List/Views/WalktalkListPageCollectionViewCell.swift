//
//  WalktalkListPageCollectionViewCell.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit

protocol WalktalkListPageCollectionViewCellDelegate: AnyObject {
    func didSelectMatchingStatus(index: Int)
}

final class WalktalkListPageCollectionViewCell: UICollectionViewCell {
    
    private var selectedMatchingStateIndex: Int = 0
    private var selectedTabbarIndex: Int = 0
    private var chatroomResponseData: [ChatroomResponseData] = []
    weak var delegate: WalktalkListPageCollectionViewCellDelegate?
    
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
    
    func setContent(with dataModel: [ChatroomResponseData]) {
        self.chatroomResponseData = dataModel
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
            let VC = WalktalkChatViewController(roomId: chatroomResponseData[indexPath.row].roomId, currentMatchingState: Status.from(index: selectedMatchingStateIndex))
        }else {
            selectedMatchingStateIndex = indexPath.row
            delegate?.didSelectMatchingStatus(index: indexPath.row)
            collectionView.reloadData()
        }
    }

}

extension WalktalkListPageCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == walktalkListCollectionView {
            return chatroomResponseData.count
        }else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == walktalkListCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalktalkListCollectionViewCell.className, for: indexPath) as? WalktalkListCollectionViewCell else { return UICollectionViewCell() }
            cell.setContent(with: chatroomResponseData[indexPath.row], status: Status.from(index: selectedMatchingStateIndex), record: Record.from(index: selectedTabbarIndex))
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalktalkListMatchingStateCollectionViewCell.className, for: indexPath) as? WalktalkListMatchingStateCollectionViewCell else { return UICollectionViewCell() }
            if indexPath.row == selectedMatchingStateIndex {
                cell.setSelected(textColor: .gray100, backgroundColor: .gray600)
                print("색상 반영 인덱스 : ",selectedMatchingStateIndex, indexPath.row)
            } else {
                cell.setSelected(textColor: .gray500, backgroundColor: .gray200)
            }
            switch indexPath.row {
            case 0:
                cell.setContent(text: Status.PENDING.rawValue)
            case 1:
                cell.setContent(text: Status.CONFIRMED.rawValue)
            case 2:
                cell.setContent(text: Status.COMPLETED.rawValue)
            default:
                cell.setContent(text: Status.REJECTED.rawValue)
            }
            return cell
        }
    }
}
