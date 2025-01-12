//
//  MyPageViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/11/24.
//

import UIKit

class MyPageViewController: UIViewController {
    
    private let myPageView = MyPageView()
    
    override func loadView() {
        self.view = UIView()
        view.addSubview(myPageView)
        
        myPageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        myPageView.contentViewSection.petView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MyPageViewController: MyPagePetViewDelegate {
    func didSelectPet(dogId: Int) {
        let dogProfileVC = DogProfileViewController()
        dogProfileVC.configure(with: dogId)
        navigationController?.pushViewController(dogProfileVC, animated: true)
    }
}
