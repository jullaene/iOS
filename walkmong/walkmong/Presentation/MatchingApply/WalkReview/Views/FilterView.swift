//
//  FilterView.swift
//  walkmong
//
//  Created by 신호연 on 12/8/24.
//

import UIKit
import SnapKit

class FilterView: UIView {
    
    private let titleLabel = SmallMainHighlightParagraphLabel(text: "필터", textColor: .gray400)
    var filters: [String] = ["최신순", "오래된 순"] {
        didSet {
            setupFilters()
        }
    }
    private var labels: [UILabel] = []
    var onFilterSelected: ((String) -> Void)?
    var onHideRequested: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupFilters()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 30
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupConstraints() {
        var previousLabel: UILabel? = titleLabel
        
        for label in labels {
            label.snp.makeConstraints { make in
                if let previous = previousLabel {
                    make.top.equalTo(previous.snp.bottom).offset(previous == titleLabel ? 24 : 32)
                }
                make.leading.trailing.equalToSuperview().inset(20)
            }
            previousLabel = label
        }
        
        previousLabel?.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
    }
    
    private func setupFilters() {
        labels.forEach { $0.removeFromSuperview() }
        labels = filters.enumerated().map { index, filter in
            let label = index == 0 ? MainHighlightParagraphLabel(text: filter, textColor: .mainBlue) : MainHighlightParagraphLabel(text: filter, textColor: .gray600)
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(filterTapped(_:))))
            addSubview(label)
            return label
        }
        setupConstraints()
    }
    
    @objc private func filterTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedLabel = gesture.view as? UILabel, let filterIndex = labels.firstIndex(of: tappedLabel) else { return }
        
        for label in labels {
            label.textColor = .gray600
        }
        tappedLabel.textColor = .mainBlue
        onFilterSelected?(filters[filterIndex])
        onHideRequested?()
    }
}
