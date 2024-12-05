import UIKit
import SnapKit

class FilterSelectView: UIView {

    // MARK: - Buttons
    let filterButton = FilterSelectView.createButton(
        backgroundColor: .gray100,
        cornerRadius: 16.5,
        image: UIImage(named: "filterIcon")
    )
    
    let distanceButton = FilterSelectView.createButton(
        backgroundColor: .gray600,
        cornerRadius: 18.5,
        title: "거리",
        titleColor: .white,
        font: UIFont(name: "Pretendard-SemiBold", size: 16)
    )
    
    let breedButton = FilterSelectView.createButton(
        backgroundColor: .gray100,
        cornerRadius: 18.5,
        title: "견종",
        titleColor: .gray500,
        font: UIFont(name: "Pretendard-SemiBold", size: 16)
    )
    
    let matchStatusButton = FilterSelectView.createButton(
        backgroundColor: .gray100,
        cornerRadius: 18.5,
        title: "매칭여부",
        titleColor: .gray500,
        font: UIFont(name: "Pretendard-SemiBold", size: 16)
    )

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
        
        for (index, button) in buttons.enumerated() {
            addSubview(button)
            
            button.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.equalTo(36)
                
                if let previous = previousButton {
                    make.leading.equalTo(previous.snp.trailing).offset(8)
                } else {
                    make.leading.equalToSuperview().offset(16)
                }
                
                make.width.equalTo(index == 0 ? 34 : (index == 3 ? 87 : 60))
            }
            
            previousButton = button
        }
    }
    
    // MARK: - Helpers
    private static func createButton(
        backgroundColor: UIColor,
        cornerRadius: CGFloat,
        title: String? = nil,
        titleColor: UIColor? = nil,
        font: UIFont? = nil,
        image: UIImage? = nil
    ) -> UIButton {
        let button = UIButton()
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        
        if let title = title {
            button.setTitle(title, for: .normal)
        }
        
        if let titleColor = titleColor {
            button.setTitleColor(titleColor, for: .normal)
        }
        
        if let font = font {
            button.titleLabel?.font = font
        }
        
        if let image = image {
            button.setImage(image, for: .normal)
        }
        
        return button
    }
}
