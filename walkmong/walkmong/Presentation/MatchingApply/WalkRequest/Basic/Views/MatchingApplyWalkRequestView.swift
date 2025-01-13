//
//  MatchingApplyWalkRequestView.swift
//  walkmong
//
//  Created by 신호연 on 1/4/25.
//

import UIKit
import SnapKit

protocol StepConfigurable {
    var stepTitle: String { get }
    var buttonTitle: String { get }
    var isButtonEnabled: Bool { get }
    var isWarningVisible: Bool { get }
    var buttonStateChanged: ((Bool) -> Void)? { get set }
}

final class MatchingApplyWalkRequestView: UIView, KeyboardObserverDelegate, UIScrollViewDelegate {
    let scrollView = UIScrollView()
    let contentView = UIView()

    let middleTitleLabel = MiddleTitleLabel(text: "중제목")

    let actionButton: UIButton = UIButton.createStyledButton(
        type: .large,
        style: .light,
        title: "다음으로"
    )

    private let warningBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.isHidden = true
        return view
    }()
    
    let checkBoxIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "check-box-lined"))
        return imageView
    }()
    
    let checkBoxText: UILabel = {
        let label = MainHighlightParagraphLabel(text: "주의사항을 모두 확인했습니다.", textColor: .gray500)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private(set) var isWarningSectionVisible: Bool = false
    private var keyboardEventManager: KeyboardEventManager?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupKeyboardManager()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupKeyboardManager() {
        keyboardEventManager = KeyboardEventManager(delegate: self)
    }

    deinit {
        keyboardEventManager = nil
    }

    private func setupViews() {
        addSubviews(scrollView, warningBackgroundView, actionButton)
        warningBackgroundView.addSubviews(checkBoxIcon, checkBoxText)

        scrollView.addSubview(contentView)
        scrollView.delegate = self
        contentView.addSubview(middleTitleLabel)
        
        setupLayout()
        addGestureRecognizers()
        initializeButtonState()
    }

    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(140)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(actionButton.snp.top).offset(-12)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview()
        }

        middleTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(39)
            make.leading.equalToSuperview().offset(18)
        }

        warningBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(actionButton.snp.top).offset(-86)
        }

        actionButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(54)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
        }

        checkBoxIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(actionButton.snp.top).offset(-32)
            make.size.equalTo(24)
        }

        checkBoxText.snp.makeConstraints { make in
            make.leading.equalTo(checkBoxIcon.snp.trailing).offset(12)
            make.centerY.equalTo(checkBoxIcon)
        }
    }

    private func addGestureRecognizers() {
        let iconTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCheckBoxTapped))
        checkBoxIcon.addGestureRecognizer(iconTapGesture)
        checkBoxIcon.isUserInteractionEnabled = true
        
        let textTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCheckBoxTapped))
        checkBoxText.addGestureRecognizer(textTapGesture)
        checkBoxText.isUserInteractionEnabled = true
    }

    @objc private func handleCheckBoxTapped() {
        if checkBoxIcon.image == UIImage(named: "check-box-lined") {
            checkBoxIcon.image = UIImage(named: "checkbox")
            actionButton.setStyle(.dark, type: .large)
            actionButton.isEnabled = true
        } else {
            checkBoxIcon.image = UIImage(named: "check-box-lined")
            actionButton.setStyle(.light, type: .large)
            actionButton.isEnabled = false
        }
    }

    func showWarningSection() {
        warningBackgroundView.isHidden = false
    }

    func hideWarningSection() {
        warningBackgroundView.isHidden = true
    }
    
    func updateWarningText(_ text: String) {
        checkBoxText.text = text
    }
    
    func updateContentView(with additionalView: UIView) {
        contentView.subviews.forEach {
            if $0 != middleTitleLabel {
                $0.removeFromSuperview()
            }
        }

        contentView.addSubview(additionalView)

        additionalView.snp.makeConstraints { make in
            make.top.equalTo(middleTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.endEditing(true)
    }

    // MARK: - KeyboardObserverDelegate
    func keyboardWillShow(keyboardHeight: CGFloat) {
        let keyboardInset = keyboardHeight - safeAreaInsets.bottom
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardInset, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    func keyboardWillHide() {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    func initializeButtonState() {
        actionButton.setStyle(.light, type: .large)
        actionButton.isEnabled = false
    }
}
