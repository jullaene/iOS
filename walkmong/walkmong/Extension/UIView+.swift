//
//  UIView+.swift
//  walkmong
//
//  Created by 황채웅 on 11/8/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    // 현재 뷰를 포함하는 뷰 컨트롤러를 찾기 위한 유틸리티 메서드
    func getViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
