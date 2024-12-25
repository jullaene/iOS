import UIKit
import SnapKit

class AlertView: UIView {
    
    // MARK: - UI Components
    let tableView = UITableView()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .white
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(52+18)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
