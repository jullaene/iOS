//
//  WalktalkChatView.swift
//  walkmong
//
//  Created by 황채웅 on 12/18/24.
//

import UIKit
import SnapKit

protocol WalktalkChatViewDelegate: AnyObject {
    func didSendMessage(_ message: String)
}

class WalktalkChatView: UIView {
    
    private var keyboardFrameHeightConstraint: Constraint?
    private var keyboardInputTextViewHeightConstraint: Constraint?
    private let maxTextViewHeight: CGFloat = 100
    private let userID: Int = 0
    private var chatLog: [HistoryItem] = []
    private var sectionedMessages: [(sectionTitle: String, messages: [HistoryItem])] = []
    
    weak var delegate: WalktalkChatViewDelegate?

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .gray100
        addSubViews()
        setConstraints()
        addButtonTargets()
        configureCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        walktalkChatCollectionView.layoutIfNeeded()
        scrollToBottom()
    }

    // MARK: UI Components
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
    
    func updateChatLog(_ chatLog: [HistoryItem]) {
        self.chatLog = chatLog
        self.sectionedMessages = chatLog.sectionedChatMessages()
        walktalkChatCollectionView.reloadData()
        scrollToBottom()
    }

    func appendMessage(_ message: HistoryItem) {
        chatLog.append(message)
        sectionedMessages = chatLog.sectionedChatMessages()
        walktalkChatCollectionView.reloadData()
        scrollToBottom()
    }

    func setupTextViewDelegate(delegate: UITextViewDelegate) {
        keyboardInputTextView.delegate = delegate
    }

    func updateTextViewHeight() {
        let size = CGSize(width: keyboardInputTextView.frame.width, height: .infinity)
        let estimatedSize = keyboardInputTextView.sizeThatFits(size)
        let newHeight = min(estimatedSize.height, maxTextViewHeight)
        keyboardInputTextView.isScrollEnabled = estimatedSize.height > maxTextViewHeight
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

    @objc private func sendButtonTapped() {
        guard let text = keyboardInputTextView.text, !text.isEmpty, keyboardInputTextView.textColor != .lightGray else { return }

        delegate?.didSendMessage(text)
        appendMessage(HistoryItem(message: text, senderId: userID, createdAt: Date.currentTimestamp()))
        keyboardInputTextView.text = "메시지 보내기"
        keyboardInputTextView.textColor = UIColor(hexCode: "#D8DDE4")
        updateTextViewHeight()
        scrollToBottom()
    }


    @objc private func photoButtonTapped() {
        // TODO: 앨범/카메라 액션
    }

}

extension WalktalkChatView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let message = sectionedMessages[indexPath.section].messages[indexPath.row]
        let width = message.senderId == userID ?
        (collectionView.bounds.width - 56 - 4 - 16) :
        (collectionView.bounds.width - 32 - 8 - 16 - 56 - 4)
        let font = UIFont.systemFont(ofSize: 16)
        let estimatedHeight = message.message.getEstimatedMessageFrame(width: width, with: font, lineBreakStrategy: .hangulWordPriority).height
        return CGSize(width: collectionView.bounds.width, height: estimatedHeight + 32)
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
        let formattedTime = HistoryItem.inputDateFormatter.date(from: message.createdAt)
            .flatMap { HistoryItem.outputTimeFormatter.string(from: $0) }
        ?? message.createdAt

        if message.senderId == userID {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WalktalkChatMessageSentCollectionViewCell.className,
                for: indexPath
            ) as? WalktalkChatMessageSentCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setContent(message: message.message, time: formattedTime)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WalktalkChatMessageReceivedCollectionViewCell.className,
                for: indexPath
            ) as? WalktalkChatMessageReceivedCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setContent(message: message.message, time: formattedTime, profileImage: .defaultProfile)
            return cell
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: WalktalkChatDateHeaderView.className,
                for: indexPath
            ) as? WalktalkChatDateHeaderView else { return UICollectionReusableView() }
            header.setContent(date: sectionedMessages[indexPath.section].sectionTitle)
            return header
        }
        return UICollectionReusableView()
    }
}
