//
//  WalktalkChatUpperView.swift
//  walkmong
//
//  Created by 황채웅 on 12/19/24.
//

import UIKit
import SnapKit

class WalktalkChatUpperView: UIView {

    private var currentMatchingState: MatchingState = .matching //FIXME: 매칭 상태 변수 분리 필요

    private let matchingStateFrameView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerRadius = 30
        return view
    }()

    private let matchingStateInnerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let matchingStateProfileImageView: UIImageView = {
        let view = UIImageView()
        view.image = .defaultProfile
        return view
    }()

    private let matchingStateDogNameLabel = MainHighlightParagraphLabel(text: "반려견 이름")

    private let matchingStateDateLabel = MainParagraphLabel(text: "진행 일자", textColor: .gray500)

    private let matchingStateView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14.5
        return view
    }()

    private let matchingStateLabel = CaptionLabel(text: "매칭 상태", textColor: .white)

    private let matchingStateFirstButton: UIButton = {
        let button = UIButton()
        button.setTitle("사전 만남 설정", for: .normal)
        button.setTitleColor(.gray500, for: .normal)
        button.backgroundColor = .gray100
        button.titleLabel?.font = UIFont(name: "Pretendard-Semibold", size: 14)
        button.titleLabel?.textColor = .gray500
        button.layer.cornerRadius = 5
        return button
    }()

    private let matchingStateSecondButton: UIButton = {
        let button = UIButton()
        button.setTitle("만남 장소 변경", for: .normal)
        button.setTitleColor(.gray500, for: .normal)
        button.backgroundColor = .gray100
        button.titleLabel?.font = UIFont(name: "Pretendard-Semibold", size: 14)
        button.titleLabel?.textColor = .gray500
        button.layer.cornerRadius = 5
        return button
    }()

    private let matchingStateThirdButton: UIButton = {
        let button = UIButton()
        button.setTitle("산책 일자 변경", for: .normal)
        button.setTitleColor(.gray500, for: .normal)
        button.backgroundColor = .gray100
        button.titleLabel?.font = UIFont(name: "Pretendard-Semibold", size: 14)
        button.titleLabel?.textColor = .gray500
        button.layer.cornerRadius = 5
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        updateMatchingState()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(matchingStateFrameView)
        matchingStateFrameView.addSubview(matchingStateInnerView)
        matchingStateInnerView.addSubviews(matchingStateView,
                                           matchingStateDogNameLabel,
                                           matchingStateProfileImageView,
                                           matchingStateDateLabel)
        matchingStateView.addSubview(matchingStateLabel)

        switch currentMatchingState {
        case .matching:
            matchingStateInnerView.addSubview(matchingStateFirstButton)
        case .confirmed:
            matchingStateInnerView.addSubviews(
                matchingStateFirstButton,
                matchingStateSecondButton,
                matchingStateThirdButton)
        default:
            break
        }
    }

    private func setupConstraints() {
        matchingStateFrameView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(currentMatchingState == .ended || currentMatchingState == .cancelled ? 88 : 149)
            make.horizontalEdges.equalToSuperview()
        }

        matchingStateInnerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20.5)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(20)
        }

        matchingStateProfileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(45)
            make.top.leading.equalToSuperview()
        }

        matchingStateDogNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0.5)
            make.leading.equalTo(matchingStateProfileImageView.snp.trailing).offset(13)
        }

        matchingStateDateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(matchingStateProfileImageView.snp.bottom).inset(0.5)
            make.leading.equalTo(matchingStateProfileImageView.snp.trailing).offset(13)
        }

        matchingStateView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.height.equalTo(29)
            make.leading.equalTo(matchingStateLabel.snp.leading).offset(-16)
        }

        matchingStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }

        matchingStateFirstButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(41)
            make.width.equalTo(100)
        }

        if currentMatchingState == .confirmed {
            matchingStateSecondButton.snp.makeConstraints { make in
                make.leading.equalTo(matchingStateFirstButton.snp.trailing).offset(8)
                make.bottom.equalToSuperview()
                make.height.equalTo(41)
                make.width.equalTo(100)
            }

            matchingStateThirdButton.snp.makeConstraints { make in
                make.leading.equalTo(matchingStateSecondButton.snp.trailing).offset(8)
                make.bottom.equalToSuperview()
                make.height.equalTo(41)
                make.width.equalTo(100)
            }
        }
    }

    private func updateMatchingState() {
        matchingStateLabel.text = currentMatchingState.rawValue
        switch currentMatchingState {
        case .matching:
            matchingStateFirstButton.setTitle("매칭 확정하기", for: .normal)
            matchingStateView.backgroundColor = .mainGreen
            matchingStateLabel.textColor = .white
        case .confirmed:
            matchingStateFirstButton.setTitle("사전만남 설정", for: .normal)
            matchingStateView.backgroundColor = .mainBlue
            matchingStateLabel.textColor = .white
        case .ended:
            matchingStateProfileImageView.toGrayscale()
            matchingStateView.backgroundColor = .gray400
            matchingStateLabel.textColor = .white
        case .cancelled:
            matchingStateProfileImageView.toGrayscale()
            matchingStateView.backgroundColor = .gray200
            matchingStateLabel.textColor = .gray400
        }
    }

    func setMatchingState(_ state: MatchingState) {
        currentMatchingState = state
        updateMatchingState()
        setupConstraints()
    }
}