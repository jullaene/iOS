//
//  MatchingViewController.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit
import SnapKit

class MatchingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 바 숨기기
        self.navigationController?.navigationBar.isHidden = true
        
        // 배경 색상 설정
        self.view.backgroundColor = .white
        
        // 커스텀 뷰 추가
        let customView = UIView()
        customView.backgroundColor = UIColor(red: 0.303, green: 0.764, blue: 1, alpha: 1)
        self.view.addSubview(customView)
        
        customView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(280)
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        // 하단 좌우측 모서리에 반경 30 적용 (UIBezierPath 사용)
        let path = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 280),
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: 30, height: 30)
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        customView.layer.mask = maskLayer
    }
}
