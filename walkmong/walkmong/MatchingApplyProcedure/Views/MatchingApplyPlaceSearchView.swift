//
//  MatchingApplyPlaceSearchView.swift
//  walkmong
//
//  Created by 황채웅 on 11/9/24.
//

import UIKit

protocol MatchingApplyPlaceSearchViewDelegate: AnyObject {
    func matchingApplyPlaceSearchView(_ collectionView: UICollectionView, didSelectPlaceSearchResultAt indexPath: IndexPath)
    func matchingApplyPlaceSearchView(_ textField: UITextField, willSearchKeywords keyword: String)
    func reloadMatchingApplyPlaceSearchView(_ view: MatchingApplyPlaceSearchView)
}

class MatchingApplyPlaceSearchView: UIView {
    
    weak var delegate: MatchingApplyPlaceSearchViewDelegate?
    var placeSearchResults: [String] = []
    var didSearch: Bool = false
    
    private let placeSearchBarTextField: UITextField = {
        let textField = UITextField()
        
        let iconImageView = UIImageView(image: .searchIcon)
        iconImageView.frame = CGRect(x: 12, y: 15, width: 16, height: 16)
        
        let imageContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 46))
        imageContainerView.addSubview(iconImageView)
        
        textField.leftView = imageContainerView
        textField.leftViewMode = .always
        textField.textColor = .mainBlack
        textField.font = UIFont(name:"Pretendard-Medium",size: 16)
        textField.backgroundColor = .gray100
        textField.layer.cornerRadius = 5
        textField.keyboardType = .webSearch
        textField.addCharacterSpacing()
        return textField
    }()
    
    private let findCurrentLocationButton: UIButton = {
        var attributedTitle = AttributedString("현재위치로 찾기")
        attributedTitle.font = UIFont(name: "Pretendard-Regular", size: 14)
        
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .mainBlue
        configuration.attributedTitle = attributedTitle
        configuration.image = .currentLocation
        configuration.imagePadding = CGFloat(4)
        configuration.baseBackgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00) // Color Asset에 없음
        
        let button = UIButton(configuration: configuration)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray200.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
        
    private let placeSearchKeywordLabel: UILabel = {
        let label = UILabel()
        label.text = "키워드"
        label.textColor = .mainBlack
        label.font = UIFont(name:"Pretendard-Bold",size: 20)
        return label
    }()
    
    private let placeSearchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let illustrationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .illustration4
        return imageView
    }()
    
    private let illustrationLabel: UILabel = {
        let label = UILabel()
        label.text = "강아지와 산책할 장소를 설정해요!"
        label.textColor = .gray500
        label.font = UIFont(name:"Pretendard-SemiBold",size: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        addSubViews()
        setConstraints()
        setCollectionViewConfigure()
        setTextFieldConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCollectionViewConfigure(){
        placeSearchResultCollectionView.dataSource = self
        placeSearchResultCollectionView.delegate = self
        placeSearchResultCollectionView.register(walkmong.PlaceSearchResultCollectionViewCell.self, forCellWithReuseIdentifier: walkmong.PlaceSearchResultCollectionViewCell.className)
    }
    
    private func setTextFieldConfigure(){
        placeSearchBarTextField.delegate = self
    }
    
    private func addSubViews(){
        addSubviews(placeSearchBarTextField,
                    findCurrentLocationButton,
                    placeSearchKeywordLabel,
                    placeSearchResultCollectionView,
                    illustrationImageView,
                    illustrationLabel)
    }
    
    private func setConstraints(){
        placeSearchBarTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(46)
        }
        findCurrentLocationButton.snp.makeConstraints { make in
            make.top.equalTo(placeSearchBarTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        if !didSearch{
            illustrationImageView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(115)
                make.top.equalTo(findCurrentLocationButton.snp.bottom).offset(120)
                make.height.equalTo((self.frame.width-230)*(254/163))
            }
            illustrationLabel.snp.makeConstraints { make in
                make.top.equalTo(illustrationImageView.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
            }
        }else {
            illustrationLabel.isHidden = true
            illustrationImageView.isHidden = true
            placeSearchKeywordLabel.snp.makeConstraints { make in
                make.top.equalTo(findCurrentLocationButton.snp.bottom).offset(37)
                make.leading.equalToSuperview().inset(20)
            }
            placeSearchResultCollectionView.snp.makeConstraints { make in
                make.top.equalTo(placeSearchKeywordLabel.snp.bottom).offset(5)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
    }
    func reloadData(){
        self.placeSearchResultCollectionView.reloadData()
    }
    
}

extension MatchingApplyPlaceSearchView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.matchingApplyPlaceSearchView(collectionView, didSelectPlaceSearchResultAt: indexPath)
    }
}

extension MatchingApplyPlaceSearchView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placeSearchResults.count > 5 ? 5 : placeSearchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: walkmong.PlaceSearchResultCollectionViewCell.className, for: indexPath) as? PlaceSearchResultCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(with: placeSearchResults[indexPath.row])
        return cell
    }
}

extension MatchingApplyPlaceSearchView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 62)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MatchingApplyPlaceSearchView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
        guard let text = textField.text else { return true }
        let newlength = text.count + string.count - range.length
        return newlength < maxLength
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let keyword = textField.text, !keyword.trimmingCharacters(in: .whitespaces).isEmpty {
            self.placeSearchKeywordLabel.text = "'\(keyword)' 검색 결과"
            delegate?.matchingApplyPlaceSearchView(textField, willSearchKeywords: keyword)
            self.didSearch = true
            return true
        }
        return false
    }
}
