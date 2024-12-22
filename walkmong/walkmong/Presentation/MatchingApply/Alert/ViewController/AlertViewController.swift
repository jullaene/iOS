//
//  AlertViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit

class AlertViewController: UIViewController {
    
    private let alertView = AlertView()
    private var alerts: [AlertModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        loadMockData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(alertView)
        
        alertView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        alertView.tableView.dataSource = self
        alertView.tableView.delegate = self
        alertView.tableView.register(AlertCell.self, forCellReuseIdentifier: "AlertCell")
    }
    
    private func setupNavigationBar() {
        addCustomNavigationBar(
            titleText: "알림",
            showLeftBackButton: true,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false
        )
    }
    
    private func loadMockData() {
        // 목데이터 생성
        alerts = [
            AlertModel(image: UIImage(named: "profile1"), categoryText: "카테고리 1", messageText: "알림 메시지 1", isRead: false),
            AlertModel(image: nil, categoryText: "카테고리 2", messageText: "알림 메시지 2", isRead: true),
            AlertModel(image: UIImage(named: "profile2"), categoryText: "카테고리 3", messageText: "알림 메시지 3", isRead: false)
        ]
        alertView.tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension AlertViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlertCell", for: indexPath) as? AlertCell else {
            return UITableViewCell()
        }
        let alert = alerts[indexPath.row]
        cell.configure(
            with: alert.image,
            categoryText: alert.categoryText,
            messageText: alert.messageText,
            isRead: alert.isRead
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - AlertModel

struct AlertModel {
    let image: UIImage?
    let categoryText: String
    let messageText: String
    let isRead: Bool
}
