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
}
