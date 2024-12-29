//
//  WalktalkChatView.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit
import SnapKit

class WalktalkChatView: UIView {
    
    private var keyboardFrameHeightConstraint: Constraint?
    private var keyboardInputTextViewHeightConstraint: Constraint?
    private let maxTextViewHeight: CGFloat = 100
    private let userID: Int = 0
    
    let chatLog = WalkTalkChatLogModel(
        matchingState: "매칭중",
        dogName: "Buddy",
        date: "2024-12-23",
        id: "123",
        data: []
    )
    
    lazy var sectionedMessages = chatLog.sectionedChatMessages()
    
    // MARK: 채팅 UI 구성
    private let walktalkChatCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .gray100
        collectionView.register(WalktalkChatDateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WalktalkChatDateHeaderView.className)
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
        configureCollectionView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        walktalkChatCollectionView.layoutIfNeeded()
        scrollToBottom()
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
            make.top.equalToSuperview().inset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(keyboardFrameView.snp.top)
        }
        
        keyboardFrameView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            keyboardFrameHeightConstraint = make.height.equalTo(58).constraint
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
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalTo(keyboardPhotoButton.snp.trailing).offset(9)
            make.trailing.equalTo(keyboardSendButton.snp.leading).offset(-9)
            keyboardInputTextViewHeightConstraint = make.height.greaterThanOrEqualTo(42).constraint
        }
    }
    
    private func addButtonTargets() {
        keyboardSendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        keyboardPhotoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
    }
    
    private func configureCollectionView() {
        walktalkChatCollectionView.delegate = self
        walktalkChatCollectionView.dataSource = self
    }
    
    @objc private func sendButtonTapped(){
        //TODO: 메시지 전송
    }
    
    @objc private func photoButtonTapped() {
        //TODO: 앨범/카메라 탭 노출
    }
    
    func setupTextViewDelegate(delegate: UITextViewDelegate) {
        keyboardInputTextView.delegate = delegate
    }
    
    func updateTextViewHeight(){
        let size = CGSize(width: keyboardInputTextView.frame.width, height: .infinity)
        let estimatedSize = keyboardInputTextView.sizeThatFits(size)
        
        let newHeight = min(estimatedSize.height, maxTextViewHeight)
        let isScrollEnabled = estimatedSize.height > maxTextViewHeight
        keyboardInputTextView.isScrollEnabled = isScrollEnabled
        
        keyboardInputTextViewHeightConstraint?.update(offset: newHeight)
        let newFrameHeight = newHeight + 16
        keyboardFrameHeightConstraint?.update(offset: max(newFrameHeight, 58))
        layoutIfNeeded()
    }
    func scrollToBottom() {
        let contentHeight = walktalkChatCollectionView.contentSize.height
        let collectionViewHeight = walktalkChatCollectionView.bounds.size.height
        let yOffset = max(0, contentHeight - collectionViewHeight + walktalkChatCollectionView.contentInset.bottom)
        
        walktalkChatCollectionView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
    }
    
}

extension WalktalkChatView: UICollectionViewDelegate {
    
}

extension WalktalkChatView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (sectionedMessages[indexPath.section].messages[indexPath.row].id == String(userID)) ?
        (collectionView.bounds.width - 56 - 4 - 16) :
        (collectionView.bounds.width - 32 - 8 - 16 - 56 - 4)
        let text = sectionedMessages[indexPath.section].messages[indexPath.row].text
        let font = UIFont(name: "Pretendard-Medium", size: 16) ?? .systemFont(ofSize: 16)
        let estimatedFrame = text?.getEstimatedMessageFrame(width: width, with: font, lineBreakStrategy: .hangulWordPriority)
        return CGSize(width: collectionView.bounds.width, height: (estimatedFrame?.height ?? 0) + 32)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 16
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 16
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 26 + 24)
    }
}

extension WalktalkChatView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionedMessages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionedMessages[section].messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = sectionedMessages[indexPath.section].messages[indexPath.row]
        
        guard let dateString = message.date,
              let textString = message.text else {
            return UICollectionViewCell()
        }
        
        let timeFormatted = WalkTalkChatLogModel.dateFormatter.date(from: dateString)
            .flatMap { WalkTalkChatLogModel.outputTimeFormatter.string(from: $0) }
            ?? dateString
        
        if message.id == String(userID) {
            //MARK: 보낸 메시지 셀
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WalktalkChatMessageSentCollectionViewCell.className,
                for: indexPath
            ) as? WalktalkChatMessageSentCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setContent(message: textString, time: timeFormatted)
            return cell
        } else {
            //MARK: 받은 메시지 셀
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WalktalkChatMessageReceivedCollectionViewCell.className,
                for: indexPath
            ) as? WalktalkChatMessageReceivedCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setContent(message: textString, time: timeFormatted, profileImage: .defaultProfile)
            return cell
        }
    }
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: WalktalkChatDateHeaderView.className,
                for: indexPath
            ) as? WalktalkChatDateHeaderView else { return UICollectionReusableView() }
            supplementaryView.setContent(date: sectionedMessages[indexPath.section].sectionTitle)
            return supplementaryView
        }
        return UICollectionReusableView()
    }
}
