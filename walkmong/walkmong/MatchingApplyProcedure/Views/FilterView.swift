//
//  FilterView.swift
//  walkmong
//
//  Created by 신호연 on 12/8/24.
//

import UIKit

class FilterView: UIView {

    private let titleLabel = SmallMainHighlightParagraphLabel(text: "필터", textColor: .gray400)
    private let latestLabel = MainHighlightParagraphLabel(text: "최신순", textColor: .mainBlue)
    private let oldestLabel = MainHighlightParagraphLabel(text: "오래된 순", textColor: .gray600)
    private var selectedFilter: String = "최신순"

    var onFilterSelected: ((String) -> Void)?
    var onHideRequested: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        addTapGestures()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 30
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addSubview(titleLabel)
        addSubview(latestLabel)
        addSubview(oldestLabel)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(42)
            make.leading.equalToSuperview().offset(20)
        }

        latestLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
        }

        oldestLabel.snp.makeConstraints { make in
            make.top.equalTo(latestLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(20)
        }
    }

    private func addTapGestures() {
        latestLabel.isUserInteractionEnabled = true
        oldestLabel.isUserInteractionEnabled = true

        let latestTap = UITapGestureRecognizer(target: self, action: #selector(filterTapped(_:)))
        let oldestTap = UITapGestureRecognizer(target: self, action: #selector(filterTapped(_:)))

        latestLabel.addGestureRecognizer(latestTap)
        oldestLabel.addGestureRecognizer(oldestTap)
    }

    @objc private func filterTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedLabel = gesture.view as? UILabel else { return }

        if tappedLabel == latestLabel {
            selectedFilter = "최신순"
            latestLabel.textColor = .mainBlue
            oldestLabel.textColor = .gray600
        } else if tappedLabel == oldestLabel {
            selectedFilter = "오래된 순"
            latestLabel.textColor = .gray600
            oldestLabel.textColor = .mainBlue
        }

        onFilterSelected?(selectedFilter)
        onHideRequested?()
    }
}
