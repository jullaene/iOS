//
//  WalktalkChatView.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit
import SnapKit

class WalktalkChatView: UIView {
    
    private var keyboardFrameHeightConstraint: Constraint? // keyboardFrameView 높이 제약 조건
    private var keyboardInputTextViewHeightConstraint: Constraint? // keyboardInputTextView 높이 제약 조건
    private let maxTextViewHeight: CGFloat = 100 // 최대 높이 설정

    // MARK: 채팅 UI 구성
    private let walktalkChatCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .gray100
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

    private func addSubViews() {
        addSubviews(walktalkChatCollectionView, keyboardFrameView)
        keyboardFrameView.addSubviews(keyboardSendButton, keyboardPhotoButton, keyboardInputTextView)
    }

    private func setConstraints() {
        walktalkChatCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(keyboardFrameView.snp.top)
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
    }
    
    @objc private func sendButtonTapped(){
        // 메시지 전송
    }

    @objc private func photoButtonTapped() {
        // 앨범/카메라 탭 노출
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

