//
//  MatchingApplyDetailSelectViewController.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit

final class MatchingApplyDetailSelectViewController: UIViewController {

    let detailSelectView = MatchingApplyDetailSelectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    private func setUpViews(){
        view.backgroundColor = .white
        addCustomNavigationBar(titleText: "메뉴 제목",showLeftBarButton: true, showCloseBarButton: true, showRefreshBarButton: false)
        addProgressBar(currentStep: 1, totalSteps: 3)
        
        self.view.addSubview(detailSelectView)
        
        detailSelectView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(156)
            make.bottom.equalToSuperview()
        }
    }
}
