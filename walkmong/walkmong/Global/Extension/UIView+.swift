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
    
    // Show a view with animation
    func animateShow(withDuration duration: TimeInterval = 0.3, offset: CGFloat = 0, cornerRadius: CGFloat? = nil) {
        if let cornerRadius = cornerRadius {
            self.layer.cornerRadius = cornerRadius
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        self.superview?.layoutIfNeeded()
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
            self.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(offset)
            }
            self.superview?.layoutIfNeeded()
        })
    }
    
    // Hide a view with animation
    func animateHide(withDuration duration: TimeInterval, offset: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(offset)
                }
                self.superview?.layoutIfNeeded()
            },
            completion: completion
        )
    }
    
    // Update dim view visibility
    func updateDimViewVisibility(isHidden: Bool, alpha: CGFloat = 0.5) {
        self.isHidden = isHidden
        self.alpha = isHidden ? 0 : alpha
    }
    
    static func createRoundedView(backgroundColor: UIColor, cornerRadius: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        return view
    }
    
}
