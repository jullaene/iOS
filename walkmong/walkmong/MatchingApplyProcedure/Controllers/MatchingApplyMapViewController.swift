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
    var model = MatchingApplyMapModel(didSelectLocation: false)

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        addSubViews()
        setConstraints()
        addCustomNavigationBar(titleText: "만남장소", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        let coverView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width, height: 52)))
        coverView.backgroundColor = .white
        self.view.addSubview(coverView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setMapView()
        modalView.delegate = self
    }
    
    private func addSubViews(){
        self.view.addSubviews(matchingApplyMapView, modalView)
    }
    
    private func setConstraints(){
        matchingApplyMapView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(52)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        modalView.snp.makeConstraints { make in
            make.height.equalTo(268)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    private func setMapView(){
        matchingApplyMapView.delegate = self
    }
}

extension MatchingApplyMapViewController: MatchingApplyMapViewDelegate{
    func willSelectLocation() {
        self.model.didSelectLocation = false
    }
    
    func didTapNextButton() {
        if self.model.didSelectLocation {
            willHideModalView(self.modalView)
        }
    }
    
    func matchingApplyMapView(_ view: MatchingApplyMapView, didSelectLocationAt coords: String) {
        callRequest(coords: coords) { data in
            do {
                let decodeData = try JSONDecoder().decode(ReverseGeocodingModel.self, from: data)
                for address in decodeData.results {
                    if let land = address.land.name {
                        print(address.region.area3.name + " " + address.region.area2.name + " " + land + " " + address.land.number1 + " " +  address.land.addition0.value)
                    }
                    self.model.didSelectLocation = true
                }
            } catch {
                print(error)
            }
        }
    }
}

extension MatchingApplyMapViewController: MatchingApplyMapNotifyModalViewDelegate{
    func willHideModalView(_ view: UIView) {
        DispatchQueue.main.async{
            UIView.animate(withDuration: 1.5, animations: {
                view.transform = CGAffineTransform(translationX: 0, y: -view.frame.height - 20)
            }) { _ in
                view.isHidden = true
            }
        }
    }
}
