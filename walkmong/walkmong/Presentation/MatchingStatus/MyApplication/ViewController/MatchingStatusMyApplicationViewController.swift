//
//  MatchingStatusMyApplicationViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit
import SnapKit

final class MatchingStatusMyApplicationViewController: UIViewController {
    
    // MARK: - Properties
    private let matchingStatusMyApplicationView = MatchingStatusMyApplicationView()
    private var applyId: Int?
    private let service = ApplyService()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        if let applyId = self.applyId {
            Task {
                await getApplyMyForm(applyId: applyId)
            }
        }
    }
    
    init(applyId: Int) {
        self.applyId = applyId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupView() {
        view.backgroundColor = .gray100
        view.addSubview(matchingStatusMyApplicationView)
        matchingStatusMyApplicationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(52)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        addCustomNavigationBar(
            titleText: "산책 지원서",
            showLeftBackButton: true,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false,
            backgroundColor: .clear
        )
    }
 
    func getApplyMyForm(applyId: Int) async {
        Task {
            showLoading()
            defer { hideLoading() }
            do {
                let response = try await service.getApplyMyForm(applyId: applyId)
                matchingStatusMyApplicationView.updateDogProfile(with: response.data)
            } catch {
                print("Error fetching or decoding ApplyMyForm: \(error)")
            }
        }
    }
}
