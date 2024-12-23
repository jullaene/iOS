//
//  UIImageView+.swift
//  walkmong
//
//  Created by 신호연 on 12/12/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(from urlString: String?, placeholder: String) {
        if let urlString = urlString?.trimmingCharacters(in: .whitespacesAndNewlines),
           let url = URL(string: urlString), url.scheme == "http" || url.scheme == "https" {
            self.kf.setImage(with: url, placeholder: UIImage(named: placeholder))
        } else {
            self.image = UIImage(named: placeholder)
        }
    }
    func toGrayscale() {
        guard let originalImage = self.image, // UIImageView의 이미지 가져오기
              let ciImage = CIImage(image: originalImage) else { return }

        // Core Image 흑백 필터 생성
        let filter = CIFilter(name: "CIPhotoEffectMono")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)

        // 필터 적용 후 UIImage로 변환
        let context = CIContext()
        if let outputImage = filter?.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            self.image = UIImage(cgImage: cgImage) // UIImageView에 흑백 이미지 적용
        }
    }
}
