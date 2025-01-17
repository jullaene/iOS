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
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .white
        collectionView.register(WalktalkListPageCollectionViewCell.self, forCellWithReuseIdentifier: WalktalkListPageCollectionViewCell.className)
        return collectionView
    }()
    
    private let walktalkListTabBarCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(RecordTabBarCollectionViewCell.self, forCellWithReuseIdentifier: RecordTabBarCollectionViewCell.className)
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
    
    private let walktalkListMatchingStateCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(MatchingStateCollectionViewCell.self, forCellWithReuseIdentifier: MatchingStateCollectionViewCell.className)
        return collectionView
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
        walktalkListTabBarCollectionView.reloadData()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.moveIndicatorBar(targetIndex: self.selectedTabBarIndex)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if selectedTabBarIndex == 0 {
            moveIndicatorBar(targetIndex: selectedTabBarIndex)
        }
        self.delegate?.didSelectTabBarIndex(
            record: Record.from(index: self.selectedTabBarIndex),
            status: Status.from(index: self.selectedMatchingStateIndex)
        )
    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        addSubviews(walktalkListPageCollectionView, walktalkListTabBarCollectionView, sectionLineView, sectionSelectedLineView, walktalkListMatchingStateCollectionView)
    }
    
    private func setConstraints() {
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
        walktalkListMatchingStateCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(sectionLineView.snp.bottom).offset(16)
            make.height.equalTo(36)
        }
        walktalkListPageCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(walktalkListMatchingStateCollectionView.snp.bottom).offset(12)
        }
    }
    
    private func configureCollectionView() {
        walktalkListPageCollectionView.delegate = self
        walktalkListPageCollectionView.dataSource = self
        walktalkListTabBarCollectionView.delegate = self
        walktalkListTabBarCollectionView.dataSource = self
        walktalkListMatchingStateCollectionView.delegate = self
        walktalkListMatchingStateCollectionView.dataSource = self
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
        chatroomResponse = sortChatroomDataByRecentTime(dataModel)
        chatroomResponse = sortChatroomDataByRecentTime(chatroomResponse)
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
        if collectionView == walktalkListTabBarCollectionView {
            selectedTabBarIndex = indexPath.row
            walktalkListPageCollectionView.isPagingEnabled = false
            walktalkListPageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            walktalkListPageCollectionView.isPagingEnabled = true
            moveIndicatorBar(targetIndex: indexPath.row)
            delegate?.didSelectTabBarIndex(record: Record.from(index: selectedTabBarIndex),status: Status.from(index: selectedMatchingStateIndex))
            walktalkListTabBarCollectionView.reloadData()
            walktalkListPageCollectionView.reloadData()
        }else if collectionView == walktalkListMatchingStateCollectionView {
            if let previousCell = collectionView.cellForItem(at: IndexPath(item: selectedMatchingStateIndex, section: 0)) as? MatchingStateCollectionViewCell{
                previousCell.setSelected(textColor: .gray500, backgroundColor: .gray200)
            }
            if let currentCell = collectionView.cellForItem(at: indexPath) as? MatchingStateCollectionViewCell {
                currentCell.setSelected(textColor: .gray100, backgroundColor: .gray600)
            }
            selectedMatchingStateIndex = indexPath.row
            delegate?.didSelectTabBarIndex(record: Record.from(index: selectedTabBarIndex),status: Status.from(index: selectedMatchingStateIndex))
            walktalkListPageCollectionView.reloadData()
        }
    }
}

extension WalktalkListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == walktalkListPageCollectionView {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        }else if collectionView == walktalkListTabBarCollectionView{
            return CGSize(width: indexPath.row == 0 ? 28 : 72, height: collectionView.bounds.height)
        }else {
            return CGSize(width: indexPath.row == 0 ? 68 : 80, height: 36)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == walktalkListPageCollectionView {
            return 0
        }else if collectionView == walktalkListTabBarCollectionView{
            return 24
        }else {
            return 8
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == walktalkListPageCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else if collectionView == walktalkListTabBarCollectionView{
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        }else {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        }
    }
}

extension WalktalkListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == walktalkListPageCollectionView {
            return 3
        }else if collectionView == walktalkListTabBarCollectionView{
            return 3
        }else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == walktalkListPageCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalktalkListPageCollectionViewCell.className, for: indexPath) as? WalktalkListPageCollectionViewCell else { return UICollectionViewCell() }
            cell.setContent(with: chatroomResponse, selectedMatchingStateIndex: selectedMatchingStateIndex, selectedTabbarIndex: selectedTabBarIndex)
            return cell
        }else if collectionView == walktalkListTabBarCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordTabBarCollectionViewCell.className, for: indexPath) as? RecordTabBarCollectionViewCell else { return UICollectionViewCell() }
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
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchingStateCollectionViewCell.className, for: indexPath) as? MatchingStateCollectionViewCell else { return UICollectionViewCell() }
            if indexPath.row == selectedMatchingStateIndex {
                cell.setSelected(textColor: .gray100, backgroundColor: .gray600)
            } else {
                cell.setSelected(textColor: .gray500, backgroundColor: .gray200)
            }
            switch indexPath.row {
            case 0:
                cell.setContent(text: Status.PENDING.rawValue)
            case 1:
                cell.setContent(text: Status.BEFORE.rawValue)
            case 2:
                cell.setContent(text: Status.AFTER.rawValue)
            default:
                cell.setContent(text: Status.REJECT.rawValue)
            }
            return cell
        }
    }
}

extension WalktalkListView {
    private func sortChatroomDataByRecentTime(_ data: [ChatroomResponseData]) -> [ChatroomResponseData] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return data.sorted { first, second in
            guard let firstDate = dateFormatter.date(from: first.lastChatTime),
                  let secondDate = dateFormatter.date(from: second.lastChatTime) else {
                return false
            }
            return firstDate > secondDate // 내림차순
        }
    }

}
