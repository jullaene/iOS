//
//  SupportRequestView1.swift
//  walkmong
//
//  Created by 신호연 on 1/4/25.
//

import UIKit
import SnapKit
import Kingfisher

protocol SupportRequestView1Delegate: AnyObject {
    func didTapProfileButton(for profile: PetProfile)
}

final class SupportRequestView1: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    weak var delegate: SupportRequestView1Delegate?
    
    // MARK: - Properties
    private let profiles: [PetProfile] = [
        PetProfile(dogId: 1, imageURL: "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQP5QQKcY4t1-_XAOvt_5Ii9LGJqTDX0B7u5sOZJFeU8QCGJ2jReifGEDftXkScCw-lMm8nmFUYF2QXwMR2KrzTsw", name: "초코", details: "소형견 · 푸들 · 5kg", gender: "FEMALE"),
        PetProfile(dogId: 2, imageURL: "https://nz.rs-cdn.com/images/nwsp9-jl7cn/blog/feb38fea9fe8d3e2af6fef82dedbc7ba__d935/zoom668x467z105000cw668.jpg?etag=b76ec26bd9831e6a6223c7aca5d23961", name: "바둑이", details: "중형견 · 믹스 · 15kg", gender: "MALE"),
    ]
    
    private var selectedIndexPath: IndexPath?
    var onDogSelected: ((Bool) -> Void)?
    
    let collectionView: UICollectionView
    private let smallTitle = SmallTitleLabel(text: "나의 반려견")
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        
        setupView()
        observeCollectionViewHeight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        addSubviews(smallTitle, collectionView)
        
        setupConstraints()
        setupCollectionView()
    }
    
    private func setupConstraints() {
        smallTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(smallTitle.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(PetProfileCell.self, forCellWithReuseIdentifier: "PetProfileCell")
        collectionView.reloadData()
    }
    
    private func observeCollectionViewHeight() {
        DispatchQueue.main.async {
            let contentHeight = self.collectionView.contentSize.height
            self.collectionView.snp.remakeConstraints { make in
                make.top.equalTo(self.smallTitle.snp.bottom).offset(20)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview().inset(20)
                make.height.equalTo(contentHeight)
            }
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetProfileCell", for: indexPath) as! PetProfileCell
        
        if indexPath.item < profiles.count {
            let profile = profiles[indexPath.item]
            cell.configure(with: profile)
            
            cell.didTapProfileButton = { [weak self] in
                guard let self = self else { return }
                print("프로필 버튼 클릭: \(profile.name)")
                self.delegate?.didTapProfileButton(for: profile) // 델리게이트 호출로 뷰 컨트롤러에 이벤트 전달
            }
        } else {
            cell.configureAsAddPet()
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == profiles.count {
            return
        }
        
        if let previousIndexPath = selectedIndexPath {
            let previousCell = collectionView.cellForItem(at: previousIndexPath) as? PetProfileCell
            previousCell?.setDefaultStyle()
        }
        
        let selectedCell = collectionView.cellForItem(at: indexPath) as? PetProfileCell
        selectedCell?.setSelectedStyle()
        
        selectedIndexPath = indexPath
        
        onDogSelected?(true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 94)
    }
}
