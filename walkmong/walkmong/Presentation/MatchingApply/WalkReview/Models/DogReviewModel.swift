//
//  DogReviewModel.swift
//  walkmong
//
//  Created by 신호연 on 12/8/24.
//

import UIKit

struct DogReviewModel {
    struct ProfileData {
        let image: UIImage?
        let reviewerId: String
        let walkDate: String
    }

    let profileData: ProfileData
    let circleTags: [(String, String)] // ("Tag Title", "#Tag Description")
    let photos: [UIImage] // Maximum 2 photos
    let reviewText: String?
}
