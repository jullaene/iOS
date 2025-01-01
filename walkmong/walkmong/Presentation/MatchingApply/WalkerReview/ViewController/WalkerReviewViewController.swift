//
//  WalkerReviewViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit
import SnapKit

final class WalkerReviewViewController: UIViewController, KeyboardObserverDelegate {
    
    enum WalkerReviewViewState {
        case reviewOverview
        case detailedReview
    }
    
    private var currentState: WalkerReviewViewState = .reviewOverview

    // MARK: - Properties
    private let walkerReviewView = WalkerReviewView()
    private var keyboardEventManager: KeyboardEventManager?
    private var feedbackViewBottomConstraint: Constraint?
    private let reviewPhotoView = ReviewPhotoView()
    private let bottomButton: UIButton = {
        return UIButton.createStyledButton(type: .large, style: .dark, title: "완료")
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        keyboardEventManager = KeyboardEventManager(delegate: self)
        setupScrollToDismissKeyboard()
        setupBottomButton()
        switchToState(.reviewOverview)
    }

    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(walkerReviewView)
        walkerReviewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(reviewPhotoView)
        reviewPhotoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(52 + 23)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func setupNavigationBar() {
        addCustomNavigationBar(
            titleText: "산책 후기 쓰기",
            showLeftBackButton: false,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false
        )
    }
    
    private func setupBottomButton() {
        view.addSubview(bottomButton)
        
        bottomButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
            make.height.equalTo(53)
        }
        
        bottomButton.addTarget(self, action: #selector(handleBottomButtonTapped), for: .touchUpInside)
        bottomButton.isHidden = true
    }
    
    private func setupScrollToDismissKeyboard() {
        walkerReviewView.scrollView.keyboardDismissMode = .onDrag
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismisskeyboard))
        tapGesture.cancelsTouchesInView = false
        walkerReviewView.scrollView.addGestureRecognizer(tapGesture)
    }

    @objc private func dismisskeyboard() {
        keyboardEventManager?.dismisskeyboard()
    }

    // MARK: - KeyboardObserverDelegate
    func keyboardWillShow(keyboardHeight: CGFloat) {
        feedbackViewBottomConstraint?.update(offset: -keyboardHeight)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func keyboardWillHide() {
        feedbackViewBottomConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func switchToState(_ state: WalkerReviewViewState) {
        currentState = state

        switch state {
        case .reviewOverview:
            walkerReviewView.isHidden = false
            reviewPhotoView.isHidden = true
            bottomButton.isHidden = true
            
        case .detailedReview:
            walkerReviewView.isHidden = true
            reviewPhotoView.isHidden = false
            bottomButton.isHidden = false
        }
    }
    
    @objc private func handleBottomButtonTapped() {
        print("후기 완료 버튼이 눌렸습니다.")
    }
}
