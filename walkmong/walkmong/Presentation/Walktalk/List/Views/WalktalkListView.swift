//
//  WalktalkListView.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit

protocol WalktalkListViewDelegate: AnyObject {
    func didSelectTabBarIndex(record: Record, status: Status)
}

final class WalktalkListView: UIView {
    
    private var selectedTabBarIndex: Int = 0
    private var selectedMatchingStateIndex: Int = 0
    private var chatroomResponse: [ChatroomResponseData] = []
    weak var delegate: WalktalkListViewDelegate?
    
    
    private let walktalkListPageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(WalktalkListPageCollectionViewCell.self, forCellWithReuseIdentifier: WalktalkListPageCollectionViewCell.className)
        return collectionView
    }()
    
    private let walktalkListTabBarCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(WalktalkListTabBarCollectionViewCell.self, forCellWithReuseIdentifier: WalktalkListTabBarCollectionViewCell.className)
        return collectionView
    }()
    
    private let sectionLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    private let sectionSelectedLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlue
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addSubview()
        setConstraints()
        configureCollectionView()
        loadInitialData()
    }
    
    private func loadInitialData() {
        DispatchQueue.main.async { [self] in
            moveIndicatorBar(targetIndex: selectedTabBarIndex)
            delegate?.didSelectTabBarIndex(record: Record.from(index: selectedTabBarIndex) , status: Status.from(index: selectedMatchingStateIndex))
            walktalkListPageCollectionView.reloadData()
            walktalkListTabBarCollectionView.reloadData()
        }
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        addSubviews(walktalkListPageCollectionView, walktalkListTabBarCollectionView, sectionLineView, sectionSelectedLineView)
    }
    
    private func setConstraints() {
        walktalkListPageCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(sectionLineView.snp.bottom)
        }
        walktalkListTabBarCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(22)
        }
        sectionLineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(walktalkListTabBarCollectionView.snp.bottom).offset(12)
            make.height.equalTo(1)
        }
        sectionSelectedLineView.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.width.equalTo(28)
            make.bottom.equalTo(walktalkListTabBarCollectionView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    private func configureCollectionView() {
        walktalkListPageCollectionView.delegate = self
        walktalkListPageCollectionView.dataSource = self
        walktalkListTabBarCollectionView.delegate = self
        walktalkListTabBarCollectionView.dataSource = self
    }
    
    private func moveIndicatorBar(targetIndex: Int) {
        let indexPath = IndexPath(item: targetIndex, section: 0)
        
        guard let attributes = walktalkListTabBarCollectionView.layoutAttributesForItem(at: indexPath) else { return }
        
        let cellFrame = attributes.frame
        
        sectionSelectedLineView.snp.remakeConstraints { make in
            make.centerX.equalTo(cellFrame.midX)
            make.width.equalTo(cellFrame.width)
            make.height.equalTo(4)
            make.bottom.equalTo(walktalkListTabBarCollectionView.snp.bottom).offset(12)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func setContent(with dataModel: [ChatroomResponseData]){
        chatroomResponse = [
            ChatroomResponseData(
                dogName: "Buddy",
                dogProfile: "buddy_profile.png",
                startTime: "2025-01-01 10:00:00",
                endTime: "2025-01-01 11:00:00",
                chatTarget: 1,
                lastChat: "오늘 산책 가능하세요?",
                lastChatTime: "2025-01-01 09:50:00",
                targetName: "Alice",
                notRead: 2,
                roomId: 101
            ),
            ChatroomResponseData(
                dogName: "Max",
                dogProfile: "max_profile.png",
                startTime: "2025-01-02 14:00:00",
                endTime: "2025-01-02 15:00:00",
                chatTarget: 2,
                lastChat: "내일 산책 일정 확인 부탁드립니다.",
                lastChatTime: "2025-01-02 13:45:00",
                targetName: "Bob",
                notRead: 5,
                roomId: 102
            ),
            ChatroomResponseData(
                dogName: "Charlie",
                dogProfile: "charlie_profile.png",
                startTime: "2025-01-03 16:00:00",
                endTime: "2025-01-03 17:00:00",
                chatTarget: 3,
                lastChat: "새로운 산책 경로 제안드립니다.",
                lastChatTime: "2025-01-03 15:30:00",
                targetName: "Carol",
                notRead: 0,
                roomId: 103
            ),
            ChatroomResponseData(
                dogName: "Rocky",
                dogProfile: "rocky_profile.png",
                startTime: "2025-01-04 18:00:00",
                endTime: "2025-01-04 19:00:00",
                chatTarget: 4,
                lastChat: "산책 후 간식 나눠줄게요!",
                lastChatTime: "2025-01-04 17:50:00",
                targetName: "David",
                notRead: 3,
                roomId: 104
            )
        ]
        if chatroomResponse.isEmpty {
            //TODO: 비어있을 때 처리
        }
        moveIndicatorBar(targetIndex: selectedTabBarIndex)
        walktalkListPageCollectionView.reloadData()
    }
}

extension WalktalkListView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == self.walktalkListPageCollectionView {
            let targetIndex = Int(round(targetContentOffset.pointee.x / scrollView.bounds.width))
            if selectedTabBarIndex != targetIndex {
                selectedTabBarIndex = targetIndex
                moveIndicatorBar(targetIndex: targetIndex)
                delegate?.didSelectTabBarIndex(record: Record.from(index: targetIndex), status: Status.from(index: selectedMatchingStateIndex))
                walktalkListPageCollectionView.reloadData()
                walktalkListTabBarCollectionView.reloadData()
            }
        }
    }
}

extension WalktalkListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        if collectionView == walktalkListTabBarCollectionView && selectedTabBarIndex != indexPath.row {
            selectedTabBarIndex = indexPath.row
            walktalkListPageCollectionView.isPagingEnabled = false
            walktalkListPageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            walktalkListPageCollectionView.isPagingEnabled = true
            moveIndicatorBar(targetIndex: indexPath.row)
            delegate?.didSelectTabBarIndex(record: Record.from(index: selectedTabBarIndex),status: Status.from(index: selectedMatchingStateIndex))
            walktalkListTabBarCollectionView.reloadData()
            walktalkListPageCollectionView.reloadData()
        }
    }
}

extension WalktalkListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == walktalkListPageCollectionView {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        }else {
            return CGSize(width: indexPath.row == 0 ? 28 : 72, height: collectionView.bounds.height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == walktalkListPageCollectionView {
            return 0
        }else {
            return 24
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == walktalkListPageCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
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
            cell.delegate = self
            cell.setContent(with: chatroomResponse)
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalktalkListTabBarCollectionViewCell.className, for: indexPath) as? WalktalkListTabBarCollectionViewCell else { return UICollectionViewCell() }
            if indexPath.row == selectedTabBarIndex {
                cell.setSelected(textColor: .mainBlack)
            }else {
                cell.setSelected(textColor: .gray400)
            }
            switch indexPath.row {
            case 0:
                cell.setContent(text: "전체")
            case 1:
                cell.setContent(text: "지원한 산책")
            default:
                cell.setContent(text: "의뢰한 산책")
            }
            return cell
        }
    }
}

extension WalktalkListView: WalktalkListPageCollectionViewCellDelegate {
    func didSelectMatchingStatus(index: Int) {
        selectedMatchingStateIndex = index
        delegate?.didSelectTabBarIndex(record: Record.from(index: selectedTabBarIndex), status: Status.from(index: selectedMatchingStateIndex))
    }
}
