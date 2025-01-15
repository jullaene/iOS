//
//  MatchingStatusListPageCollectionViewCell.swift
//  walkmong
//
//  Created by 황채웅 on 1/11/25.
//

import UIKit

protocol MatchingStatusListPageCollectionViewCellDelegate: AnyObject {
    func didSelectMatchingCell(matchingResponseData: ApplyHistoryItem, record: Record, status: Status)
}

final class MatchingStatusListPageCollectionViewCell: UICollectionViewCell {
    
    private var selectedMatchingStateIndex: Int = 0
    private var selectedTabbarIndex: Int = 0
    private var matchingResponseData: [ApplyHistoryItem] = []
    
    private let matchingStatusListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MatchingStatusListCollectionViewCell.self, forCellWithReuseIdentifier: MatchingStatusListCollectionViewCell.className)
        return collectionView
    }()
    
    weak var delegate: MatchingStatusListPageCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(matchingStatusListCollectionView)
        setDelegate()
        setConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDelegate() {
        matchingStatusListCollectionView.delegate = self
        matchingStatusListCollectionView.dataSource = self
    }
    
    private func setConstraints() {
        matchingStatusListCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func setContent(with dataModel: [ApplyHistoryItem], selectedMatchingStateIndex: Int, selectedTabbarIndex: Int) {
        self.selectedTabbarIndex = selectedTabbarIndex
        self.selectedMatchingStateIndex = selectedMatchingStateIndex
        self.matchingResponseData = dataModel
        matchingStatusListCollectionView.reloadData()
    }
    
}

extension MatchingStatusListPageCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width-40, height: 194)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

extension MatchingStatusListPageCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let VC = MatchingStatusListViewController()
        self.getViewController()?.navigationController?.pushViewController(VC, animated: true)
    }
    
}

extension MatchingStatusListPageCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchingResponseData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchingStatusListCollectionViewCell.className, for: indexPath) as? MatchingStatusListCollectionViewCell else { return UICollectionViewCell() }
        cell.setContent(with: matchingResponseData[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension MatchingStatusListPageCollectionViewCell: MatchingStatusListCollectionViewCellDelegate {
    func didTapMatchingStatusListCollectionViewCell(matchingResponseData: ApplyHistoryItem, record: Record, status: Status) {
        delegate?.didSelectMatchingCell(matchingResponseData: matchingResponseData, record: record, status: status)
    }
}
