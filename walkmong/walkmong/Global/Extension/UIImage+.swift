//
//  UIImage+.swift
//  walkmong
//
//  Created by 황채웅 on 11/15/24.
//

import UIKit

extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func createImageView(
        named imageName: String? = nil,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        cornerRadius: CGFloat = 0,
        tintColor: UIColor? = nil
    ) -> UIImageView {
        let imageView = UIImageView()
        
        // 이미지 설정
        if let imageName = imageName {
            if let image = UIImage(named: imageName) {
                imageView.image = tintColor != nil ? image.withRenderingMode(.alwaysTemplate) : image
            }
        }
        
        // 공통 속성
        imageView.contentMode = contentMode
        
        // 코너 라운드 설정
        if cornerRadius > 0 {
            imageView.layer.cornerRadius = cornerRadius
            imageView.clipsToBounds = true
        }
        
        // 틴트 컬러 설정
        if let tintColor = tintColor {
            imageView.tintColor = tintColor
        }
        
        return imageView
    }
    
}
