//
//  MatchingDogInformationViewController.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit
import SnapKit

class MatchingDogInformationViewController: BaseViewController {
    
    // MARK: - Properties
    private var matchingData: MatchingData?
    private let dogInfoView = MatchingDogInformationView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 커스텀 네비게이션 바 설정
        setupCustomNavigationBar()
        
        // UI 설정
        setupUI()
        if let data = matchingData {
            // 여러 이미지 설정 (슬라이더)
            dogInfoView.configureImages(with: [data.dogProfile, data.dogProfile, data.dogProfile])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 기본 탭바 숨기기
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 기본 탭바 다시 표시
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Public Methods
    func configure(with data: MatchingData) {
        matchingData = data
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(dogInfoView)
        
        dogInfoView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupCustomNavigationBar() {
        customNavigationBar.setTitle("")
        customNavigationBar.addBackButtonAction(target: self, action: #selector(customBackButtonTapped))
    }
    
    // MARK: - Actions
    @objc private func customBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
