//
//  WalktalkChatUpperView.swift
//  walkmong
//
//  Created by 황채웅 on 12/19/24.
//

import UIKit
import SnapKit

class WalktalkChatUpperView: UIView {

    private var currentMatchingState: Status!

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
    
    init(matchingState: Status) {
        super.init(frame: .zero)
        self.currentMatchingState = matchingState
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
        case .PENDING:
            matchingStateInnerView.addSubview(matchingStateFirstButton)
        case .CONFIRMED:
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
            make.height.equalTo(currentMatchingState == .COMPLETED || currentMatchingState == .REJECTED ? 88 : 149)
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

        updateStateConstraints()
    }
    
    private func updateStateConstraints() {
        if currentMatchingState == .PENDING {
            matchingStateFirstButton.snp.remakeConstraints { make in
                make.leading.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(41)
                make.width.equalTo(100)
            }
        }else if currentMatchingState == .CONFIRMED {
            matchingStateSecondButton.snp.remakeConstraints { make in
                make.leading.equalTo(matchingStateFirstButton.snp.trailing).offset(8)
                make.bottom.equalToSuperview()
                make.height.equalTo(41)
                make.width.equalTo(100)
            }

            matchingStateThirdButton.snp.remakeConstraints { make in
                make.leading.equalTo(matchingStateSecondButton.snp.trailing).offset(8)
                make.bottom.equalToSuperview()
                make.height.equalTo(41)
                make.width.equalTo(100)
            }
        } else {
            matchingStateSecondButton.snp.removeConstraints()
            matchingStateThirdButton.snp.removeConstraints()
        }
    }



    private func updateMatchingState() {
        matchingStateLabel.text = currentMatchingState.rawValue
        switch currentMatchingState {
        case .PENDING:
            matchingStateFirstButton.setTitle("매칭 확정하기", for: .normal)
            matchingStateView.backgroundColor = .lightBlue
            matchingStateLabel.textColor = .mainBlue
        case .CONFIRMED:
            matchingStateFirstButton.setTitle("사전만남 설정", for: .normal)
            matchingStateView.backgroundColor = .mainBlue
            matchingStateLabel.textColor = .white
        case .COMPLETED:
            matchingStateProfileImageView.toGrayscale()
            matchingStateView.backgroundColor = .gray400
            matchingStateLabel.textColor = .white
        case .REJECTED:
            matchingStateProfileImageView.toGrayscale()
            matchingStateView.backgroundColor = .gray200
            matchingStateLabel.textColor = .gray400
        default:
            break
        }
    }

    func setMatchingState(_ state: Status) {
        currentMatchingState = state
        updateMatchingState()
        setupConstraints()
    }
    
    func setContent(dogName: String, date: String, profileImageURL: String) {
        matchingStateDogNameLabel.text = dogName
        matchingStateDateLabel.text = date
        matchingStateProfileImageView.image = .defaultProfile //FIXME: 이미지 렌더링 필요
    }
}

