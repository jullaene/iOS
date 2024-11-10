//
//  MatchingApplyMapViewController.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit
import NMapsMap
import Alamofire

class MatchingApplyMapViewController: UIViewController {
    
    let matchingApplyMapView = MatchingApplyMapView()
    let modalView = MatchingApplyMapNotifyModalView()

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setConstraints()
        addCustomNavigationBar(titleText: "만남장소", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
    }
    
    private func addSubViews(){
        self.view.addSubviews(matchingApplyMapView, modalView)
    }
    
    private func setConstraints(){
        matchingApplyMapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        modalView.snp.makeConstraints { make in
            make.height.equalTo(268)
            make.horizontalEdges.equalToSuperview()
        }
    }
}
