//
//  MatchingApplyFinalViewController.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit

class MatchingApplyFinalViewController: UIViewController {

    private let finalView = MatchingApplyFinalView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray100
        setUI()
    }
    
    private func setUI() {
        addSubView()
        setConstraints()
        finalView.delegate = self
    }
    
    private func addSubView() {
        self.view.addSubview(finalView)
    }
    
    private func setConstraints() {
        finalView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MatchingApplyFinalViewController: MatchingApplyFinalViewDelegate {
    func didCheckedInformation(button: UIButton) {
        
    }
    
    func didTapApplyButton() {
        
    }
    
    func didTapBackButton() {
        
    }
}
