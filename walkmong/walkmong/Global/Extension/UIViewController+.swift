//
//  UIViewController+.swift
//  walkmong
//
//  Created by 황채웅 on 11/10/24.
//

import UIKit

extension UIViewController {
    
    func dismissKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
