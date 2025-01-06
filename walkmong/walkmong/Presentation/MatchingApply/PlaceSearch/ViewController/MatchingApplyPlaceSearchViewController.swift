//
//  MatchingApplyPlaceSearchViewController.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit
import NMapsMap

final class MatchingApplyPlaceSearchViewController: UIViewController {
    
    let placeSearchView = walkmong.MatchingApplyPlaceSearchView()
    var placeSearchResult: [GeoAddress] = []
    var model = MatchingApplyPlaceSearchModel()
    var isSignUp: Bool = false
    
    init(isSignUp: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.isSignUp = isSignUp
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardOnTap()
        addCustomNavigationBar(titleText: isSignUp ? "동네 설정" : "만남장소", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        setUpViews()
        setConstraints()
    }
    
    private func setUpViews(){
        self.view.backgroundColor = .white
        self.view.addSubview(placeSearchView)
        placeSearchView.delegate = self
    }
    
    private func setConstraints(){
        placeSearchView.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(52)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func updateAddressList(with geocodingData: Geocoding) {
        self.placeSearchResult.removeAll()
        self.placeSearchView.placeSearchResults.removeAll()
        for address in geocodingData.addresses {
            self.placeSearchResult.append(address)
            self.placeSearchView.placeSearchResults.append(address.jibunAddress)
        }
        self.reloadMatchingApplyPlaceSearchView(self.placeSearchView)
    }

}

extension MatchingApplyPlaceSearchViewController: MatchingApplyPlaceSearchViewDelegate{
    func reloadMatchingApplyPlaceSearchView(_ view: MatchingApplyPlaceSearchView) {
        view.reloadData()
    }
    
    func matchingApplyPlaceSearchView(_ textField: UITextField, willSearchKeywords keyword: String) {
        showLoading()
        DispatchQueue.global(qos: .utility).async {
            Task {
                do {
                    let data = try await callRequest(query: keyword)
                    let decodedData = try JSONDecoder().decode(Geocoding.self, from: data)
                    await self.updateAddressList(with: decodedData)
                } catch {
                    print("Error: \(error)")
                }
            }
            DispatchQueue.main.async { [self] in
                textField.endEditing(true)
                placeSearchView.setNeedsLayout()
                placeSearchView.layoutIfNeeded()
                hideLoading()
            }
        }
    }
    
    func matchingApplyPlaceSearchView(_ collectionView: UICollectionView, didSelectPlaceSearchResultAt indexPath: IndexPath) {
        // 터치 이벤트 처리
        let selectedPlace = self.placeSearchResult[indexPath.row]
        print(selectedPlace.jibunAddress)
        let nextVC = isSignUp ? SignupMapViewController() : MatchingApplyMapViewController()
        if let lat = Double(selectedPlace.y), let lng = Double(selectedPlace.x) {
            print(lat, lng)
            if isSignUp, let nextVC = nextVC as? SignupMapViewController{
                if let dongmyunElement = selectedPlace.addressElements.first(where: { $0.types.contains("DONGMYUN") }), !dongmyunElement.longName.isEmpty {
                    nextVC.signupMapview.setupMap(initialPosition: NMGLatLng(lat: lat, lng: lng), dongAddress: dongmyunElement.longName)
                }else {
                    CustomAlertViewController.CustomAlertBuilder(viewController: self)
                        .setTitleState(.useTitleOnly)
                        .setTitleText("동/면 주소를 선택해주세요.")
                        .setButtonState(.singleButton)
                        .setSingleButtonTitle("돌아가기")
                        .showAlertView()
                    return
                }
            }else if let nextVC = nextVC as? MatchingApplyMapViewController{
                nextVC.matchingApplyMapView.setupMap(initialPosition: NMGLatLng(lat: lat, lng: lng))
            }
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

