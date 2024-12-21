//
//  WalktalkListView.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit

class WalktalkListView: UIView {
    
    private var selectedTabBarIndex: Int = 0
    private var walktalkListDataList: [[WalktalkListModel]] = {
        let profileImage: UIImage = .defaultProfile

        let firstSection = [
            WalktalkListModel(matchingState: .matching, date: "11.03 (일) 16:00 ~ 16:30", name: "한글이름 1", textPreview: "오늘 산책 가능해요!", profileImage: profileImage, time: "오후 10:30", chatCount: 5, isWalker: true),
            WalktalkListModel(matchingState: .confirmed, date: "11.03 (일) 16:00 ~ 16:30", name: "한글이름 2", textPreview: "내일 산책은 어때요?", profileImage: profileImage, time: "오후 2:00", chatCount: 3, isWalker: false),
            WalktalkListModel(matchingState: .ended, date: "11.03 (일) 16:00 ~ 16:30", name: "한글이름 3", textPreview: "좋은 산책이었어요!", profileImage: profileImage, time: "오후 6:00", chatCount: 2, isWalker: true),
            WalktalkListModel(matchingState: .cancelled, date: "11.03 (일) 16:00 ~ 16:30", name: "한글이름 4", textPreview: "취소된 산책입니다.", profileImage: profileImage, time: "오후 8:30", chatCount: 1, isWalker: false)
        ]

        let secondSection = [
            WalktalkListModel(matchingState: .matching, date: "11.04 (월) 16:00 ~ 16:30", name: "한글이름 5", textPreview: "새로운 산책 요청", profileImage: profileImage, time: "오후 1:00", chatCount: 4, isWalker: true),
            WalktalkListModel(matchingState: .confirmed, date: "11.04 (월) 16:00 ~ 16:30", name: "한글이름 6", textPreview: "확정된 산책입니다.", profileImage: profileImage, time: "오후 11:00", chatCount: 6, isWalker: false),
            WalktalkListModel(matchingState: .ended, date: "11.04 (월) 16:00 ~ 16:30", name: "한글이름 7", textPreview: "오늘 너무 좋았어요!", profileImage: profileImage, time: "오후 7:30", chatCount: 2, isWalker: true),
            WalktalkListModel(matchingState: .cancelled, date: "11.04 (월) 16:00 ~ 16:30", name: "한글이름 8", textPreview: "산책이 취소되었습니다.", profileImage: profileImage, time: "오전 9:00", chatCount: 1, isWalker: false),
            WalktalkListModel(matchingState: .matching, date: "11.04 (월) 16:00 ~ 16:30", name: "한글이름 9", textPreview: "새로운 산책 요청", profileImage: profileImage, time: "오후 2:00", chatCount: 4, isWalker: true),
            WalktalkListModel(matchingState: .confirmed, date: "11.04 (월) 16:00 ~ 16:30", name: "한글이름 10", textPreview: "확정된 산책입니다.", profileImage: profileImage, time: "오후 5:00", chatCount: 5, isWalker: false),
            WalktalkListModel(matchingState: .ended, date: "11.04 (월) 16:00 ~ 16:30", name: "한글이름 11", textPreview: "오늘 너무 좋았어요!", profileImage: profileImage, time: "오후 8:30", chatCount: 0, isWalker: true),
            WalktalkListModel(matchingState: .cancelled, date: "11.04 (월) 16:00 ~ 16:30", name: "한글이름 12", textPreview: "산책이 취소되었습니다.", profileImage: profileImage, time: "오전 10:00", chatCount: 2, isWalker: false),
            WalktalkListModel(matchingState: .matching, date: "11.04 (월) 16:00 ~ 16:30", name: "한글이름 13", textPreview: "새로운 산책 요청", profileImage: profileImage, time: "오후 6:00", chatCount: 3, isWalker: true),
            WalktalkListModel(matchingState: .confirmed, date: "11.04 (월) 16:00 ~ 16:30", name: "한글이름 14", textPreview: "확정된 산책입니다.", profileImage: profileImage, time: "오전 11:30", chatCount: 2, isWalker: false)
        ]

        let thirdSection = [
            WalktalkListModel(matchingState: .ended, date: "11.05 (화) 16:00 ~ 16:30", name: "한글이름 15", textPreview: "오늘 너무 좋았어요!", profileImage: profileImage, time: "오후 5:30", chatCount: 0, isWalker: true),
            WalktalkListModel(matchingState: .matching, date: "11.05 (화) 16:00 ~ 16:30", name: "한글이름 16", textPreview: "새로운 산책 요청", profileImage: profileImage, time: "오전 9:30", chatCount: 1, isWalker: false),
            WalktalkListModel(matchingState: .cancelled, date: "11.05 (화) 16:00 ~ 16:30", name: "한글이름 17", textPreview: "산책이 취소되었습니다.", profileImage: profileImage, time: "오후 12:30", chatCount: 3, isWalker: true),
            WalktalkListModel(matchingState: .matching, date: "11.05 (화) 16:00 ~ 16:30", name: "한글이름 18", textPreview: "새로운 산책 요청", profileImage: profileImage, time: "오후 4:30", chatCount: 2, isWalker: false),
            WalktalkListModel(matchingState: .confirmed, date: "11.05 (화) 16:00 ~ 16:30", name: "한글이름 19", textPreview: "확정된 산책입니다.", profileImage: profileImage, time: "오후 6:00", chatCount: 5, isWalker: true),
            WalktalkListModel(matchingState: .ended, date: "11.05 (화) 16:00 ~ 16:30", name: "한글이름 20", textPreview: "좋은 산책이었어요!", profileImage: profileImage, time: "오후 8:00", chatCount: 0, isWalker: false)
        ]

        return [firstSection, secondSection, thirdSection]
    }()

    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
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
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(walktalkListTabBarCollectionView.snp.bottom).offset(12)
        }
        walktalkListTabBarCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(22)
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
            //TODO: 매칭 페이지 셀 구현
            cell.setContent(with: walktalkListDataList[selectedTabBarIndex][indexPath.row])
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
