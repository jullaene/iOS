//
//  WalkerReviewViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit
import SnapKit

final class WalkerReviewViewController: UIViewController, KeyboardObserverDelegate {

    // MARK: - Properties
    private let walkerReviewView = WalkerReviewView()
    private var keyboardEventManager: KeyboardEventManager?
    private var feedbackViewBottomConstraint: Constraint?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        keyboardEventManager = KeyboardEventManager(delegate: self)
        setupScrollToDismissKeyboard()
    }

    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(walkerReviewView)
        walkerReviewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    
    private func setupScrollToDismissKeyboard() {
        walkerReviewView.scrollView.keyboardDismissMode = .onDrag
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        walkerReviewView.scrollView.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        keyboardEventManager?.dismissKeyboard()
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
}
