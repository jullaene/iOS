import UIKit
import SnapKit

protocol DropdownViewDelegate: AnyObject {
    func didSelectLocation(_ location: String)
}

class DropdownView: UIView {
    weak var delegate: DropdownViewDelegate?

    private var locations: [String] = []
    private var selectedLocation: String?
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
    
    func updateLocations(locations: [String]) {
        // 기존 라벨 제거
        labels.forEach { $0.removeFromSuperview() }
        labels.removeAll()

        // 주소 데이터를 "동" 단위로 포맷팅
        let formattedLocations = locations.compactMap { extractDong(from: $0) }
        self.locations = formattedLocations + ["동네 설정"]
        self.selectedLocation = formattedLocations.first

        // 라벨 생성 및 추가
        for (index, location) in self.locations.enumerated() {
            let label = createLabel(text: location, isSelected: index == 0)
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
        self.selectedLocation = selectedLocation
        for (index, label) in labels.enumerated() {
            let isSelected = selectedLocation == locations[safe: index] ?? ""
            setupLabel(label, text: label.text ?? "", isSelected: isSelected)
        }
    }
    
    @objc private func handleLabelTap(_ sender: UITapGestureRecognizer) {
        guard let tappedLabel = sender.view as? UILabel,
              let index = labels.firstIndex(of: tappedLabel),
              index < locations.count else { return }
        let selected = locations[index]

        // "동네 설정"은 선택하지 않음
        if selected == "동네 설정" { return }

        selectedLocation = selected
        delegate?.didSelectLocation(selected)
        updateSelection(selectedLocation: selected)
    }
}

// MARK: - Array Extension for Safe Indexing
private extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
