//
//  MyPageViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/11/24.
//

import UIKit

class MyPageViewController: UIViewController {
    
    private let myPageView = MyPageView()
    
    override func loadView() {
        self.view = UIView()
        view.addSubview(myPageView)
        
        myPageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateReviewData()
    }
    
    private func updateReviewData() {
        myPageView.contentViewSection.reviewView.updateChartData(scores: [5.0, 5.0, 5.0, 5.0, 5.0])
    }
}
