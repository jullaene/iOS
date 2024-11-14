import UIKit
import SnapKit

import UIKit
import SnapKit

protocol DropdownViewDelegate: AnyObject {
    func didSelectLocation(_ location: String)
}

class DropdownView: UIView {
    weak var delegate: DropdownViewDelegate?

    private var locations: [String] = ["공릉동", "청담동"]
    private var selectedLocation: String = "공릉동"

    private let labels: [UILabel] = [UILabel(), UILabel(), UILabel()]

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
        updateSelection(selectedLocation: selectedLocation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.layer.backgroundColor = UIColor.gray100.cgColor
        self.layer.cornerRadius = 20
        
        let texts = ["공릉동", "청담동", "동네 설정"]
        for (index, label) in labels.enumerated() {
            setupLabel(label, text: texts[index], isSelected: index == 0)
            addSubview(label)
            label.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(20)
                make.top.equalToSuperview().offset(20 + (index * 32))
                if index == labels.count - 1 {
                    make.bottom.equalToSuperview().offset(-20)
                }
            }
            label.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap(_:)))
            label.addGestureRecognizer(tapGesture)
        }
    }
    
    private func setupLabel(_ label: UILabel, text: String, isSelected: Bool) {
        label.text = text
        label.textColor = isSelected ? UIColor.mainBlue : UIColor.gray400
        label.font = UIFont(name: "Pretendard-\(isSelected ? "SemiBold" : "Medium")", size: 16)
    }
    
    func updateSelection(selectedLocation: String) {
        self.selectedLocation = selectedLocation
        for (index, label) in labels.enumerated() {
            let isSelected = selectedLocation == locations[safe: index] ?? ""
            setupLabel(label, text: label.text ?? "", isSelected: isSelected)
        }
    }

    func updateLocations(locations: [String]) {
        self.locations = locations
        updateSelection(selectedLocation: locations.first ?? "공릉동")
    }
    
    @objc private func handleLabelTap(_ sender: UITapGestureRecognizer) {
        guard let tappedLabel = sender.view as? UILabel,
              let index = labels.firstIndex(of: tappedLabel),
              index < locations.count else { return }
        let selected = locations[index]
        delegate?.didSelectLocation(selected)
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
