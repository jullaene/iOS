//
//  MatchingStatusLiveMapModalViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/16/25.
//

import UIKit

final class MatchingStatusLiveMapModalViewController: UIViewController {
    
    private var dogNickname: String
    private var walkerNickname: String?
    private let buttonView: MatchingStatusLiveMapButtonView
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .puppy
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 27
        return imageView
    }()
    
    private let timeFrameView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let statusLabel = UpperTitleLabel(text: "산책을 진행 중이에요", textColor: UIColor(hexCode: "#000000", alpha: 1.0))
    
    private let timePastLabel = MiddleTitleLabel(text: "0", textColor: .mainBlue)
    private let pastMinuteLabel = SmallMainParagraphLabel(text: "분", textColor: UIColor(hexCode: "#000000", alpha: 1.0))
    private let pastLabel = SmallMainHighlightParagraphLabel(text: "진행 시간", textColor: .gray500)
    
    private let timeLeftLabel = MiddleTitleLabel(text: "0", textColor: .mainBlue)
    private let leftMinuteLabel = SmallMainParagraphLabel(text: "분", textColor: UIColor(hexCode: "#000000", alpha: 1.0))
    private let leftLabel = SmallMainHighlightParagraphLabel(text: "남은 시간", textColor: .gray500)
    
    private let frameView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let titleLabel = SmallTitleLabel(text: "산책 관련 정보")
    private let requestLabel = MainHighlightParagraphLabel(text: "산책 요청 사항")
    private let requestContentLabel = MainParagraphLabel(text: "요청 사항")
    private let referenceLabel = MainHighlightParagraphLabel(text: "산책 참고 사항")
    private let referenceContentLabel = MainParagraphLabel(text: "참고 사항")
    private let additionalLabel = MainHighlightParagraphLabel(text: "추가 안내 사항")
    private let additionalContentLabel = MainParagraphLabel(text: "안내 사항")

    init(dogNickname: String, walkerNickname: String? = nil) {
        self.dogNickname = dogNickname
        self.walkerNickname = walkerNickname
        self.buttonView = MatchingStatusLiveMapButtonView(isWalker: walkerNickname != nil)
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        addSubview()
        setConstraints()
        setStatusLabel()
        buttonView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        view.addSubviews(profileImageView, statusLabel, timeFrameView, frameView, buttonView)
        timeFrameView.addSubviews(timePastLabel, pastMinuteLabel, pastLabel, timeLeftLabel, leftMinuteLabel, leftLabel)
        frameView.addSubviews(titleLabel, requestLabel, requestContentLabel, referenceLabel, referenceContentLabel, additionalLabel, additionalContentLabel)
    }
    
    private func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(32)
            make.height.width.equalTo(54)
        }
        statusLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        timeFrameView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(statusLabel.snp.bottom).offset(24)
            make.top.equalTo(timePastLabel.snp.top)
        }
        pastLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalTo(timeFrameView.snp.centerX).offset(-32.5)
        }
        pastMinuteLabel.snp.makeConstraints { make in
            make.leading.equalTo(timePastLabel.snp.trailing).offset(1.5)
            make.bottom.equalTo(timePastLabel.snp.bottom).offset(-2.5)
        }
        timePastLabel.snp.makeConstraints { make in
            make.leading.equalTo(pastLabel.snp.leading).offset(10.5)
            make.bottom.equalTo(pastLabel.snp.top).offset(-10)
        }
        leftLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalTo(timeFrameView.snp.centerX).offset(32.5)
        }
        leftMinuteLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeLeftLabel.snp.trailing).offset(1.5)
            make.bottom.equalTo(timeLeftLabel.snp.bottom).offset(-2.5)
        }
        timeLeftLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftLabel.snp.leading).offset(10.5)
            make.bottom.equalTo(leftLabel.snp.top).offset(-10)
        }
        frameView.snp.makeConstraints { make in
            make.top.equalTo(timeFrameView.snp.bottom).offset(20)
            make.bottom.equalTo(additionalContentLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(24)
        }
        requestLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(24)
        }
        requestContentLabel.snp.makeConstraints { make in
            make.top.equalTo(requestLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        referenceLabel.snp.makeConstraints { make in
            make.top.equalTo(requestContentLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
        }
        referenceContentLabel.snp.makeConstraints { make in
            make.top.equalTo(referenceLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        additionalLabel.snp.makeConstraints { make in
            make.top.equalTo(referenceContentLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
        }
        additionalContentLabel.snp.makeConstraints { make in
            make.top.equalTo(additionalLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        buttonView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(112)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    func setContent(requestMessage: String, referenceMessage: String, additionalMessage: String) {
        requestContentLabel.text = requestMessage
        referenceContentLabel.text = referenceMessage
        additionalContentLabel.text = additionalMessage
        addSubview()
        setConstraints()
    }
    
    func setTime(timePast: Int, timeLeft: Int) {
        timePastLabel.text = String(timePast)
        timeLeftLabel.text = String(timeLeft)
    }
    
    private func setStatusLabel() {
        if let walkerNickname {
            statusLabel.text = "\(walkerNickname)님이 \(dogNickname) 산책을\n진행 중이에요"
        }else {
            statusLabel.text = "\(dogNickname) 산책을\n진행 중이에요"
        }
        self.statusLabel.textAlignment = .center
        self.statusLabel.lineBreakMode = .byWordWrapping
        self.statusLabel.lineBreakStrategy = .hangulWordPriority
    }
}

extension MatchingStatusLiveMapModalViewController: MatchingStatusLiveMapButtonViewDelegate {
    func didTapContactButton() {
        //TODO: 채팅으로 전환
    }
    
    func didTapEndButton() {
        //TODO: 매칭 상태 변경
        //TODO: 후기 작성으로 전환
    }
}
