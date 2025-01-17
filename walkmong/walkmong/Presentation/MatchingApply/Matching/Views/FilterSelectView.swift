import UIKit
import SnapKit

protocol FilterSelectViewDelegate: AnyObject {
    func didTapFilterButton()
}

class FilterSelectView: UIView {

    // MARK: - Buttons
    let filterButton = UIButton.createStyledButton(type: .homeFilter, style: .light, title: "")
    let distanceButton = UIButton.createStyledButton(type: .homeFilter, style: .dark, title: "거리")
    let breedButton = UIButton.createStyledButton(type: .homeFilter, style: .light, title: "견종")
    let matchStatusButton = UIButton.createStyledButton(type: .homeFilter, style: .light, title: "매칭여부")

    weak var delegate: FilterSelectViewDelegate?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private func setupLayout() {
        let buttons = [filterButton, distanceButton, breedButton, matchStatusButton]
        var previousButton: UIView? = nil
        
        for (_, button) in buttons.enumerated() {

            addSubview(button)
            
            button.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                
                if let previous = previousButton {
                    make.leading.equalTo(previous.snp.trailing).offset(8)
                } else {
                    make.leading.equalToSuperview().offset(16)
                }

            }
            
            previousButton = button
        }
        
        if let filterIcon = UIImage(named: "filterIcon")?.withRenderingMode(.alwaysTemplate) {
            filterButton.setImage(filterIcon, for: .normal)
            filterButton.tintColor = UIColor.gray500
        }
        filterButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        filterButton.layer.cornerRadius = 16.5
    }
    
    private func setupActions() {
        let buttons = [filterButton, distanceButton, breedButton, matchStatusButton]
        buttons.forEach { button in
            button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        }
    }

    @objc private func filterButtonTapped() {
        delegate?.didTapFilterButton()
    }
}
