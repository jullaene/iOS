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
    let addressModalView = MatchingApplyMapAddressModalView()
    var model = MatchingApplyMapModel(didSelectLocation: false)

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        addSubViews()
        setConstraints()
        setUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
    }
    
    private func setConfigure(){
        self.view.backgroundColor = .white
        modalView.delegate = self
        addressModalView.delegate = self
        setupKeyboardEvent(for: matchingApplyMapView)
        setMapView()
    }
    private func setUI(){
        addCustomNavigationBar(titleText: "만남장소", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        let coverView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width, height: 52)))
        coverView.backgroundColor = .white
        self.view.addSubview(coverView)
    }
    
    private func addSubViews(){
        self.view.addSubviews(matchingApplyMapView, modalView, addressModalView)
    }
    
    private func setConstraints(){
        matchingApplyMapView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(52)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        modalView.snp.makeConstraints { make in
            make.height.equalTo(283)
            make.horizontalEdges.equalToSuperview()
        }
        addressModalView.snp.makeConstraints { make in
            make.height.equalTo(341)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
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
            willRaiseModalView(self.modalView)
            willRaiseModalView(self.addressModalView)
        }
    }
    
    func matchingApplyMapView(_ view: MatchingApplyMapView, didSelectLocationAt target: NMGLatLng) {
        let coords = "\(target.lng)" + "," + "\(target.lat)"
        Task {
            do {
                let data = try await callRequest(coords: coords)
                let decodeData = try JSONDecoder().decode(ReverseGeocodingModel.self, from: data)
                for address in decodeData.results {
                    if let land = address.land.name {
                        self.model.dongAddress = address.region.area3.name
                        self.model.roadAddress = "\(address.region.area2.name) \(land) \(address.land.number1)"
                        self.model.buildingName = address.land.addition0.value
                        self.model.latitude = target.lat
                        self.model.longitude = target.lng
                        self.model.didSelectLocation = true
                    }else {
                        self.model.didSelectLocation = false
                    }
                }
                DispatchQueue.main.async {
                    self.addressModalView.configure(with: self.model)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

extension MatchingApplyMapViewController: MatchingApplyMapNotifyModalViewDelegate{
    func willRaiseModalView(_ view: UIView) {
        raiseModalView(view)
    }
}

extension MatchingApplyMapViewController: MatchingApplyMapAddressModalViewDelegate{
    func didEndEditing(for textfield: UITextField) {
        if let keyword = textfield.text{
            if !keyword.trimmingCharacters(in: .whitespaces).isEmpty {
                self.model.memo = keyword.trimmingCharacters(in: .whitespaces)
            }
            self.addressModalView.updateButtonState(value: !keyword.trimmingCharacters(in: .whitespaces).isEmpty)
        }
    }
    
    func didTapDecideButton() {
        if self.model.memo != nil {
            let controllers = self.navigationController?.viewControllers
            for vc in controllers! {
                if let matchingVC = vc as? MatchingApplyDetailSelectViewController {
                    matchingVC.detailSelectView.delegate?.updatePlaceSelected(matchingVC.detailSelectView, self.model)
                    self.navigationController?.popToViewController(matchingVC, animated: true)
                    break
                }
            }
        }
    }
}

extension MatchingApplyMapViewController {
    private func raiseModalView(_ view: UIView){
        DispatchQueue.main.async{
            UIView.animate(withDuration: 0.75, animations: {
                view.transform = CGAffineTransform(translationX: 0, y: -view.frame.height)
            }) { _ in
                
            }
        }
    }
    private func downModalView(_ view: UIView){
        DispatchQueue.main.async{
            UIView.animate(withDuration: 0.75, animations: {
                view.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
            }) { _ in
                
            }
        }
    }
}
