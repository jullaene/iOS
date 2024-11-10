//
//  BaseViewController.swift
//  walkmong
//
//  Created by 신호연 on 11/10/24.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    let customNavigationBar = CustomNavigationBar()

    private let safeAreaBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSafeAreaBackground()
        setupCustomNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupSafeAreaBackground() {
        // Safe Area 배경 추가
        view.addSubview(safeAreaBackgroundView)
        safeAreaBackgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }

    private func setupCustomNavigationBar() {
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(76)
        }

        customNavigationBar.addBackButtonAction(target: self, action: #selector(handleBackButtonTapped))
    }

    func setNavigationBarTitle(_ title: String) {
        customNavigationBar.setTitle(title)
    }

    @objc func handleBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    func addBackButtonAction(_ target: Any?, action: Selector) {
        customNavigationBar.addBackButtonAction(target: target, action: action)
    }

}
