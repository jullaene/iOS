import UIKit
import SnapKit

protocol DropdownViewDelegate: AnyObject {
    func didSelectLocation(_ location: String)
}

class DropdownView: UIView {
    weak var delegate: DropdownViewDelegate?
    private var locations: [(dongAddress: String, addressId: String)] = []
    var selectedAddressId: String?
    var selectedLocation: String?
    private var labels: [UILabel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.layer.backgroundColor = UIColor.gray100.cgColor
        self.layer.cornerRadius = 20
    }
    
    func updateLocations(locations: [(dongAddress: String, addressId: String)]) {
        labels.forEach { $0.removeFromSuperview() }
        labels.removeAll()

        self.locations = locations + [("동네 설정", "")]
        self.selectedLocation = locations.first?.dongAddress
        self.selectedAddressId = locations.first?.addressId

        for (index, location) in self.locations.enumerated() {
            let label = createLabel(text: location.dongAddress, isSelected: index == 0)
            addSubview(label)
            labels.append(label)

            label.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(20)
                make.top.equalToSuperview().offset(20 + (index * 32))
                if index == self.locations.count - 1 {
                    make.bottom.equalToSuperview().offset(-20)
                }
            }
        }
    }
    
    private func extractDong(from location: String) -> String? {
        return location.split(separator: " ").last.map { String($0) }
    }
    
    private func createLabel(text: String, isSelected: Bool) -> UILabel {
        let label = UILabel()
        setupLabel(label, text: text, isSelected: isSelected)
        
        // 라벨에 탭 제스처 추가
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap(_:)))
        label.addGestureRecognizer(tapGesture)
        
        return label
    }
    
    private func setupLabel(_ label: UILabel, text: String, isSelected: Bool) {
        label.text = text
        label.textColor = isSelected ? UIColor.mainBlue : UIColor.gray400
        label.font = UIFont(name: "Pretendard-\(isSelected ? "SemiBold" : "Medium")", size: 16)
    }
    
    func updateSelection(selectedLocation: String) {
        guard let selectedIndex = locations.firstIndex(where: { $0.dongAddress == selectedLocation }) else { return }
        self.selectedLocation = selectedLocation
        self.selectedAddressId = locations[selectedIndex].addressId

        for (index, label) in labels.enumerated() {
            let isSelected = index == selectedIndex
            setupLabel(label, text: label.text ?? "", isSelected: isSelected)
        }
    }
    
    @objc private func handleLabelTap(_ sender: UITapGestureRecognizer) {
        guard let tappedLabel = sender.view as? UILabel,
              let index = labels.firstIndex(of: tappedLabel),
              index < locations.count else { return }
        let selected = locations[index]
        if selected.dongAddress == "동네 설정" { return }

        selectedLocation = selected.dongAddress
        selectedAddressId = selected.addressId
        delegate?.didSelectLocation(selectedLocation ?? "")
        updateSelection(selectedLocation: selectedLocation ?? "")
    }
}

// MARK: - Array Extension for Safe Indexing
private extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
