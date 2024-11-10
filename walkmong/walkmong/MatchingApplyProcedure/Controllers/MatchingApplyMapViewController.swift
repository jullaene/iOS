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
        dismissKeyboardOnTap()
        setupKeyboardEvent()
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
            make.height.equalTo(268)
            make.horizontalEdges.equalToSuperview()
        }
        addressModalView.snp.makeConstraints { make in
            make.height.equalTo(346)
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
                        self.model.roadAddress = "\(address.region.area2.name) \(land) \(address.land.number1) \(address.land.addition0.value)"
                        self.model.latitude = target.lat
                        self.model.longitude = target.lng
                    }
                }
                DispatchQueue.main.async {
                    self.model.didSelectLocation = true
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
    func didTapDecideButton(){
        guard let presentingVC = self.presentingViewController as? UINavigationController else { return }
        let viewControllerStack = presentingVC.viewControllers
        self.dismiss(animated: true) {
            for viewController in viewControllerStack {
                if let rootVC = viewController as? MatchingApplyDetailSelectViewController {
                    presentingVC.popToViewController(rootVC, animated: true)
                }
            }
        }
    }

}

extension MatchingApplyMapViewController {
    private func raiseModalView(_ view: UIView){
        DispatchQueue.main.async{
            UIView.animate(withDuration: 1.5, animations: {
                view.transform = CGAffineTransform(translationX: 0, y: -view.frame.height)
            }) { _ in
                
            }
        }
    }
    private func downModalView(_ view: UIView){
        DispatchQueue.main.async{
            UIView.animate(withDuration: 1.5, animations: {
                view.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
            }) { _ in
                
            }
        }
    }
}
