//
//  MatchingApplyPlaceSearchViewController.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit

final class MatchingApplyPlaceSearchViewController: UIViewController {
    
    let placeSearchView = walkmong.MatchingApplyPlaceSearchView()
    var placeSearchResult: [String] = ["검색결과1","검색결과2","검색결과3","검색결과4","검색결과5","검색결과6","검색결과7","검색결과8","검색결과9","검색결과10","검색결과11","검색결과12"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardOnTap()
        addCustomNavigationBar(titleText: "만남장소", showLeftBarButton: true, showCloseBarButton: false, showRefreshBarButton: false)
        setUpViews()
        setConstraints()
    }
    
    private func setUpViews(){
        self.view.backgroundColor = .white
        self.view.addSubview(placeSearchView)
        placeSearchView.delegate = self
        placeSearchView.placeSearchResults = placeSearchResult
    }
    
    private func setConstraints(){
        placeSearchView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(121)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func placeSearchAPI(_ keyword: String) -> [String]{
        return []
    }
}

extension MatchingApplyPlaceSearchViewController: MatchingApplyPlaceSearchViewDelegate{
    
    func matchingApplyPlaceSearchView(_ textField: UITextField, willSearchKeywords keyword: String) {
        DispatchQueue.global(qos: .background).async {
            // 비동기적으로 네트워크 요청을 보냄
            self.placeSearchResult = self.placeSearchAPI(keyword)
            // 메인 스레드로 돌아와 UI 업데이트
            DispatchQueue.main.async {
                textField.endEditing(true)
                self.placeSearchView.setNeedsLayout()
                self.placeSearchView.layoutIfNeeded()
            }
        }
    }
    
    func matchingApplyPlaceSearchView(_ collectionView: UICollectionView, didSelectPlaceSearchResultAt indexPath: IndexPath) {
        // 터치 이벤트 처리
        let nextVC = MatchingApplyMapViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

