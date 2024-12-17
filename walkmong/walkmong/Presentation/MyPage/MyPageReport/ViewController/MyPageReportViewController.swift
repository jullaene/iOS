//
//  MyPageReportViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/17/24.
//

import UIKit
import SnapKit

class MyPageReportViewController: UIViewController {
    
    private lazy var myPageReportView = MyPageReportView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        configureTextView()
    }
    
    private func setupView() {
        view.addSubview(myPageReportView)
        myPageReportView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        addCustomNavigationBar(
            titleText: "산책 후기 신고하기",
            showLeftBackButton: false,
            showLeftCloseButton: false,
            showRightCloseButton: true,
            showRightRefreshButton: false
        )
    }
    
    private func configureTextView() {
        myPageReportView.reportTextView.didChangeText = { [weak self] count in
            self?.updateCharCountLabel(count: count)
        }
    }
    
    private func updateCharCountLabel(count: Int) {
        let maxCount = 250
        let countText = NSMutableAttributedString(
            string: "(\(count)/\(maxCount))",
            attributes: [.foregroundColor: UIColor.gray400]
        )
        
        let range = NSRange(location: 1, length: "\(count)".count)
        countText.addAttributes([.foregroundColor: count > 0 ? UIColor.gray500 : UIColor.gray400], range: range)
        
        myPageReportView.charCountLabel.attributedText = countText
    }
    
    // MARK: - 화면 닫기 액션
    @objc private func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}
