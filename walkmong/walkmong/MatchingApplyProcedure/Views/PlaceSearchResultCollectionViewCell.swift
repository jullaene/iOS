//
//  PlaceSearchResultCollectionViewCell.swift
//  walkmong
//
//  Created by 황채웅 on 11/10/24.
//

import UIKit

final class PlaceSearchResultCollectionViewCell: UICollectionViewCell {
        
    private let placeSearchResultLabel = MainParagraphLabel(text: "", textColor: .gray500)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews(){
        addSubview(placeSearchResultLabel)
    }
    
    private func setConstraints() {
        placeSearchResultLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    func configureCell(with data: String){
        placeSearchResultLabel.text = data
    }
}
