//
//  WalktalkChatView.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit
import SnapKit

class WalktalkChatView: UIView {
    
    private var matchingState: MatchingState = .matching
    
    private var keyboardFrameHeightConstraint: Constraint? // keyboardFrameView 높이 제약 조건
    private var keyboardInputTextViewHeightConstraint: Constraint? // keyboardInputTextView 높이 제약 조건
    private let maxTextViewHeight: CGFloat = 100 // 최대 높이 설정

    
    //MARK: 상단 바 구성
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
    
    private let matchingStateDogNameLabel = MainHighlightParagraphLabel(text: "진행 일자")
    
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
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray100
        button.titleLabel?.font = UIFont(name: "Pretendard-Semibold", size: 12)
        button.titleLabel?.textColor = .gray500
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let matchingStateSecondButton: UIButton = {
        let button = UIButton()
        button.setTitle("만남 장소 변경", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray100
        button.titleLabel?.font = UIFont(name: "Pretendard-Semibold", size: 12)
        button.titleLabel?.textColor = .gray500
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let matchingStateThirdButton: UIButton = {
        let button = UIButton()
        button.setTitle("산책 일자 변경", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray100
        button.titleLabel?.font = UIFont(name: "Pretendard-Semibold", size: 12)
        button.titleLabel?.textColor = .gray500
        button.layer.cornerRadius = 5
        return button
    }()
    
    //MARK: 채팅 UI 구성
    private let walktalkChatCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(WalktalkChatMessageReceivedCollectionViewCell.self, forCellWithReuseIdentifier: WalktalkChatMessageReceivedCollectionViewCell.className)
        collectionView.register(WalktalkChatMessageSentCollectionViewCell.self, forCellWithReuseIdentifier: WalktalkChatMessageSentCollectionViewCell.className)
        return collectionView
    }()
    
    //MARK: 키보드 구성
    private let keyboardFrameView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let keyboardPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(.union, for: .normal)
        return button
    }()
    
    private let keyboardInputTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColor(hexCode: "#D8DDE4")
        textView.text = "메시지 보내기"
        textView.textContainerInset = UIEdgeInsets(top: 10.5, left: 12, bottom: 10.5, right: 12)
        textView.backgroundColor = UIColor(hexCode: "#F4F6F8")
        textView.layer.cornerRadius = 21
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let keyboardSendButton: UIButton = {
        let button = UIButton()
        button.setImage(.send, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray100
        addSubViews()
        setConstraints()
        addButtonTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews(){
        addSubviews(matchingStateFrameView,
                    walktalkChatCollectionView,
                    keyboardFrameView)
        matchingStateFrameView.addSubview(matchingStateInnerView)
        matchingStateInnerView.addSubviews(matchingStateView,
                                           matchingStateDogNameLabel,
                                           matchingStateProfileImageView,
                                           matchingStateDateLabel)
        matchingStateView.addSubview(matchingStateLabel)
        keyboardFrameView.addSubviews(keyboardSendButton,
                                      keyboardPhotoButton,
                                      keyboardInputTextView)
        switch matchingState {
        case .matching:
            matchingStateInnerView.addSubview(matchingStateFirstButton)
        case .confirmed:
            matchingStateInnerView.addSubviews(
                matchingStateFirstButton,
                matchingStateSecondButton,
                matchingStateThirdButton)
        default :
            break
        }
    }
    
    private func setConstraints(){
        
        switch matchingState {
        case .matching:
            matchingStateFrameView.snp.makeConstraints { make in
                make.height.equalTo(149)
                make.horizontalEdges.equalToSuperview()
            }
            matchingStateInnerView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(20.5)
                make.top.equalToSuperview().offset(20)
                make.bottom.equalToSuperview().inset(20)
            }
            
        case .confirmed:
            matchingStateFrameView.snp.makeConstraints { make in
                make.height.equalTo(149)
                make.horizontalEdges.equalToSuperview()
            }
            matchingStateInnerView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(20.5)
                make.top.equalToSuperview().offset(20)
                make.bottom.equalToSuperview().inset(20)
            }
            
        case .ended, .cancelled:
            matchingStateFrameView.snp.makeConstraints { make in
                make.height.equalTo(88)
                make.horizontalEdges.equalToSuperview()
            }
            matchingStateInnerView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(20.5)
                make.top.equalToSuperview().offset(20)
                make.bottom.equalToSuperview().inset(20)
            }
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
            make.horizontalEdges.equalTo(matchingStateLabel.snp.horizontalEdges).offset(16)
        }
        matchingStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        keyboardFrameView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            keyboardFrameHeightConstraint = make.height.equalTo(58).constraint // 기본 높이 설정
        }
        keyboardPhotoButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        keyboardSendButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
        keyboardInputTextView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalTo(keyboardPhotoButton.snp.trailing).offset(9)
            make.trailing.equalTo(keyboardSendButton.snp.leading).offset(-9)
            keyboardInputTextViewHeightConstraint = make.height.equalTo(42).constraint // 기본 높이 설정
        }
    }
    
    private func addButtonTargets(){
        keyboardSendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        keyboardPhotoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        switch matchingState {
        case .matching:
            matchingStateFirstButton.addTarget(self, action: #selector(matchingStateFirstButtonTapped), for: .touchUpInside)
        case .confirmed:
            matchingStateFirstButton.addTarget(self, action: #selector(matchingStateFirstButtonTapped), for: .touchUpInside)
            matchingStateSecondButton.addTarget(self, action: #selector(matchingStateSecondButtonTapped), for: .touchUpInside)
            matchingStateThirdButton.addTarget(self, action: #selector(matchingStateThirdButtonTapped), for: .touchUpInside)
        default :
            break
        }
    }
    
    @objc private func sendButtonTapped(){
        // 메시지 전송
    }
    
    @objc private func photoButtonTapped(){
        // 앨뱀/카메라 탭 노출
    }
    
    @objc private func matchingStateFirstButtonTapped(){
        switch matchingState {
        case .matching:
            // 매칭 확정하기
            break
        case .confirmed:
            //사전 만남 설저
            break
        default :
            break
        }
    }
    
    @objc private func matchingStateSecondButtonTapped(){
        // 만남 장소 변경
    }
    
    @objc private func matchingStateThirdButtonTapped(){
        //산책 일자 변경
    }
    
    func setupTextViewDelegate(delegate: UITextViewDelegate) {
        keyboardInputTextView.delegate = delegate
    }
    
    func updateTextViewHeight(){
        // 텍스트뷰의 높이를 동적으로 계산
        let size = CGSize(width: keyboardInputTextView.frame.width, height: .infinity)
        let estimatedSize = keyboardInputTextView.sizeThatFits(size)

        // 텍스트뷰의 높이를 최대 높이까지 제한
        let newHeight = min(estimatedSize.height, maxTextViewHeight)
        let isScrollEnabled = estimatedSize.height > maxTextViewHeight
        keyboardInputTextView.isScrollEnabled = isScrollEnabled

        // 높이 업데이트
        keyboardInputTextViewHeightConstraint?.update(offset: newHeight)
        let newFrameHeight = newHeight + 16 // 텍스트뷰 패딩(위, 아래 8씩)
        keyboardFrameHeightConstraint?.update(offset: max(newFrameHeight, 58)) // 최소 높이는 58
        layoutIfNeeded() // 레이아웃 업데이트
    }
}

private enum MatchingState: String{
    case matching = "매칭중"
    case confirmed = "매칭확정"
    case ended = "산책완료"
    case cancelled = "매칭취소"
}
