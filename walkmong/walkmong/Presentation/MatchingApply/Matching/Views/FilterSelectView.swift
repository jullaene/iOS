import UIKit
import SnapKit

class FilterSelectView: UIView {

    // MARK: - Buttons
    let filterButton = UIButton.createStyledButton(type: .homeFilter, style: .light, title: "")
    let distanceButton = UIButton.createStyledButton(type: .homeFilter, style: .dark, title: "거리")
    let breedButton = UIButton.createStyledButton(type: .homeFilter, style: .light, title: "견종")
    let matchStatusButton = UIButton.createStyledButton(type: .homeFilter, style: .light, title: "매칭여부")

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
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
        filterButton.layer.cornerRadius = 16.5
    }
}
