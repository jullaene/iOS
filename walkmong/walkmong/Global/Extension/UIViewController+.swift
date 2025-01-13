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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showLoading() {
        let loadingView = UIActivityIndicatorView(style: .large)
        loadingView.color = .gray
        loadingView.startAnimating()
        loadingView.tag = 999 // 로딩 뷰 식별용 태그
        loadingView.center = self.view.center
        self.view.addSubview(loadingView)
    }
    
    func hideLoading() {
        self.view.viewWithTag(999)?.removeFromSuperview()
    }

}
