//
//  SignupMapViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/6/25.
//

import UIKit

final class SignupMapViewController: UIViewController {
    
    let signupMapview = SignupMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setConstraints()
        addCustomNavigationBar(titleText: "동네 설정", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        signupMapview.delegate = self
    }
    
    private func addSubview() {
        view.addSubview(signupMapview)
    }
    
    private func setConstraints() {
        signupMapview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(52)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
extension SignupMapViewController: SignupMapViewDelegate {
    func didTapNextButton(dongAddress: String, latitude: Double, longitude: Double) {
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if let signupVC = vc as? SignupDetailViewController {
                signupVC.signupDetailView.updatePlaceState(place: dongAddress, latitude: latitude, longitude: longitude)
                self.navigationController?.popToViewController(signupVC, animated: true)
                break
            }
        }
    }
}
