//
//  MatchingApplyWalkRequestDogProfileSelectionView.swift
//  walkmong
//
//  Created by 신호연 on 1/4/25.
//

import UIKit
import SnapKit
import Kingfisher

protocol MatchingApplyWalkRequestDogProfileSelectionViewDelegate: AnyObject {
    func didTapProfileButton(for profile: PetProfile)
}

final class MatchingApplyWalkRequestDogProfileSelectionView: UIView {
    // MARK: - Properties
    weak var delegate: MatchingApplyWalkRequestDogProfileSelectionViewDelegate?
    
    var selectedDogId: Int? {
        guard let selectedIndexPath = selectedIndexPath, selectedIndexPath.item < profiles.count else {
            return nil
        }
        return profiles[selectedIndexPath.item].dogId
    }
    private var selectedIndexPath: IndexPath?
    private var profiles: [PetProfile] = []
    var onDogSelected: ((Bool) -> Void)?
    
    private let networkProvider = NetworkProvider<DogAPI>()
    private let collectionView: UICollectionView
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
        fetchDogProfiles()
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
        collectionView.isScrollEnabled = false
        collectionView.register(PetProfileCell.self, forCellWithReuseIdentifier: "PetProfileCell")
    }
    
    private func observeCollectionViewHeight() {
        DispatchQueue.main.async {
            self.collectionView.layoutIfNeeded()
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
    
    // MARK: - Fetch Data
    private func fetchDogProfiles() {
        Task {
            do {
                let response = try await networkProvider.request(
                    target: .getDogList,
                    responseType: DogListResponse.self
                )
                profiles = response.data.map { item in
                    let weightString: String
                    if item.weight == floor(item.weight) {
                        weightString = "\(Int(item.weight))"
                    } else {
                        weightString = String(format: "%.1f", item.weight)
                    }

                    return PetProfile(
                        dogId: item.dogId,
                        imageURL: item.dogProfile ?? "",
                        name: item.dogName,
                        details: "\(item.dogSize.localizedDogSize()) · \(item.breed) · \(weightString)kg",
                        gender: item.dogGender
                    )
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.observeCollectionViewHeight()
                }
            } catch {
                print("Failed to fetch dog profiles: \(error)")
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MatchingApplyWalkRequestDogProfileSelectionView: UICollectionViewDataSource {
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
                self.delegate?.didTapProfileButton(for: profile)
            }
        } else {
            cell.configureAsAddPet()
            
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MatchingApplyWalkRequestDogProfileSelectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == profiles.count {
            let nextVC = RegisterPetInfoViewController()
            self.getViewController()?.navigationController?.pushViewController(nextVC, animated: true)
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
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MatchingApplyWalkRequestDogProfileSelectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 94)
    }
}
