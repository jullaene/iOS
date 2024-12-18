//
//  String+.swift
//  walkmong
//
//  Created by 황채웅 on 12/20/24.
//

import UIKit

extension String {
    func getEstimatedMessageFrame(width: CGFloat ,with font: UIFont) -> CGRect {
        let size = CGSize(width: width, height: 1000)
        let optionss = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: self).boundingRect(with: size, options: optionss, attributes: [.font: font], context: nil)
        return estimatedFrame
    }
}
