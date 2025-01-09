//
//  KeyboardEventManager.swift
//  walkmong
//
//  Created by 황채웅 on 12/30/24.
//

import Foundation
import UIKit

protocol KeyboardObserverDelegate: AnyObject {
    func keyboardWillShow(keyboardHeight: CGFloat)
}

class KeyboardEventManager {
    weak var delegate: KeyboardObserverDelegate?

    init(delegate: KeyboardObserverDelegate) {
        self.delegate = delegate
        setUpKeyboardNotifications()
    }

    deinit {
        removeKeyboardNotifications()
    }

    private func setUpKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dismissKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }

    private func addKeyboardObserver(selector: Selector, name: NSNotification.Name) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        delegate?.keyboardWillShow(keyboardHeight: keyboardHeight)
    }

    @objc func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
