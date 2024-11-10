//
//  UIViewController+.swift
//  walkmong
//
//  Created by 황채웅 on 11/10/24.
//

import UIKit

// Extend UIViewController to dismiss keyboard when tapping outside the UITextField
extension UIViewController {
    
    // Dismiss the keyboard when tapping anywhere on the view
    func dismissKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // Dismiss keyboard method
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
