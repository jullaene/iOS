//
//  MyPagePetView.swift
//  walkmong
//
//  Created by 신호연 on 12/11/24.
//

import UIKit
import SnapKit
import Kingfisher

protocol MyPagePetViewDelegate: AnyObject {
    func didSelectPet(dogId: Int)
}

class MyPagePetView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    weak var delegate: MyPagePetViewDelegate?
    
    private let titleView = UIView()
    private let titleLabel = SmallTitleLabel(text: "내 반려견", textColor: .gray600)
    private let editButton = UIButton()
    private let descriptionLabel = SmallMainParagraphLabel(text: "2마리의 반려견과 함께 지내고 있어요", textColor: .gray400)
    private let petListView = UIView()
    private let pageControl = UIPageControl()
    
    private let collectionView: UICollectionView
    private var petProfiles: [PetProfile] = []
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 40
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        setupView()
        setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .white
        
        // Title View
        addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
        
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        
        titleView.addSubview(editButton)
        editButton.backgroundColor = .gray200
        editButton.layer.cornerRadius = 4
        editButton.setTitle("수정하기", for: .normal)
        editButton.setTitleColor(.gray400, for: .normal)
        editButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        editButton.snp.makeConstraints { make in
            make.width.equalTo(65)
            make.height.equalTo(25)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(titleLabel)
        }
        
        titleView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        // Pet List View
        addSubview(petListView)
        petListView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom).offset(24)
        }
        
        // Collection View
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PetProfileCell.self, forCellWithReuseIdentifier: "PetProfileCell")
        petListView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(94)
        }
        
        // Page Control
        pageControl.currentPageIndicatorTintColor = .mainBlack
        pageControl.pageIndicatorTintColor = .mainBlack.withAlphaComponent(0.3)
        petListView.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }
        
        // Bottom Constraint
        petListView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupData() {
        NetworkManager().fetchDogList { [weak self] result in
            switch result {
            case .success(let petModels):
                self?.petProfiles = petModels.map { petModel in
                    let dogSizeText: String
                    switch petModel.dogSize.uppercased() {
                    case "SMALL":
                        dogSizeText = "소형견"
                    case "MIDDLE":
                        dogSizeText = "중형견"
                    case "BIG":
                        dogSizeText = "대형견"
                    default:
                        dogSizeText = "알 수 없음"
                    }
                    
                    return PetProfile(
                        dogId: petModel.dogId,
                        imageURL: petModel.dogProfile,
                        name: petModel.dogName,
                        details: "\(dogSizeText) · \(petModel.breed) · \(petModel.weight)kg",
                        gender: petModel.dogGender
                    )
                }
                DispatchQueue.main.async {
                    self?.pageControl.numberOfPages = (self?.petProfiles.count ?? 0) + 1
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching dog list: \(error)")
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petProfiles.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isAddPetCell = indexPath.item == petProfiles.count
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetProfileCell", for: indexPath) as! PetProfileCell
        if isAddPetCell {
            cell.configureAsAddPet()
        } else {
            let profile = petProfiles[indexPath.item]
            cell.configure(with: profile)
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalInsets = 20.0
        let width = collectionView.frame.width - (horizontalInsets * 2)
        return CGSize(width: width, height: 94)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < petProfiles.count else { return }
        let selectedPet = petProfiles[indexPath.item]
        delegate?.didSelectPet(dogId: selectedPet.dogId)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int((scrollView.contentOffset.x + 20) / scrollView.frame.width)
        pageControl.currentPage = page
    }
}
