//
//  String+.swift
//  walkmong
//
//  Created by 황채웅 on 12/20/24.
//

import UIKit

extension String {
    func getEstimatedMessageFrame(width: CGFloat, with font: UIFont, lineBreakStrategy: NSParagraphStyle.LineBreakStrategy = .hangulWordPriority) -> CGRect {
        // 임시 UILabel을 생성하여 라벨 속성을 설정
        let label = UILabel()
        label.font = font
        label.numberOfLines = 0  // 여러 줄로 표시할 수 있도록 설정
        label.lineBreakMode = .byWordWrapping // 기본 줄 바꿈 모드
        label.lineBreakStrategy = lineBreakStrategy // 한글 우선 줄 바꿈 전략
        label.text = self
        
        // `UILabel`의 텍스트 레이아웃에 맞춰 프레임 계산
        let sizeThatFits = label.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        
        // 계산된 크기 반환
        return CGRect(origin: .zero, size: sizeThatFits)
    }
    
    func localizedDogSize() -> String {
        switch self.uppercased() {
        case "SMALL":
            return "소형견"
        case "MIDDLE":
            return "중형견"
        case "BIG":
            return "대형견"
        default:
            return "알 수 없음"
        }
    }
}
