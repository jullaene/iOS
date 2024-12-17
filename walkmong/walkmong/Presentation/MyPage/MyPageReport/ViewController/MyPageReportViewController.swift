//
//  MyPageReportViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/17/24.
//

import UIKit
import SnapKit

class MyPageReportViewController: UIViewController {
    
    private lazy var myPageReportView = MyPageReportView(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(myPageReportView)
        myPageReportView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
