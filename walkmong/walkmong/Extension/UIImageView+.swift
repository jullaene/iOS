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
}
