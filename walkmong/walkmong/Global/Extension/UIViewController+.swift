//
//  UIViewController+.swift
//  walkmong
//
//  Created by 황채웅 on 11/10/24.
//

import UIKit

extension UIViewController {
    
    func dismissKeyboardOnTap(for view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupKeyboardEvent(for targetView: UIView) {
        dismissKeyboardOnTap(for: targetView)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: targetView)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: targetView)
    }
    
    
    @objc private func keyboardWillShow(_ sender: Notification, for targetView: UIView) {
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        if targetView.frame.origin.y == 0 {
            targetView.frame.origin.y -= keyboardHeight
        }
    }
    
    @objc private func keyboardWillHide(_ sender: Notification, for targetView: UIView) {
        if targetView.frame.origin.y != 0 {
            targetView.frame.origin.y = 0
        }
    }
    
}
