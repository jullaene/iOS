import UIKit

protocol DropdownViewDelegate: AnyObject {
    func didSelectLocation(_ location: String)
}

class DropdownView: UIView {
    // MARK: - Properties
    weak var delegate: DropdownViewDelegate?
    
    private let locations = ["공릉동", "청담동"] // 선택 가능한 동네
    private var selectedLocation: String = "공릉동" // 기본 선택
    
    private let labels: [UILabel] = [UILabel(), UILabel(), UILabel()]
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false // Auto Layout 설정
        setupView()
        updateSelection(selectedLocation: selectedLocation) // 초기 상태 업데이트
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupView() {
        self.layer.backgroundColor = UIColor.gray100.cgColor
        self.layer.cornerRadius = 20
        
        let texts = ["공릉동", "청담동", "동네 설정"]
        for (index, label) in labels.enumerated() {
            setupLabel(label, text: texts[index], isSelected: index == 0) // 첫 번째 레이블 선택 상태
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
    
    // MARK: - Update Selection
    func updateSelection(selectedLocation: String) {
        self.selectedLocation = selectedLocation
        for (index, label) in labels.enumerated() {
            let isSelected = selectedLocation == locations[safe: index] ?? ""
            setupLabel(label, text: label.text ?? "", isSelected: isSelected)
        }
    }
    
    // MARK: - Actions
    @objc private func handleLabelTap(_ sender: UITapGestureRecognizer) {
        guard let tappedLabel = sender.view as? UILabel,
              let index = labels.firstIndex(of: tappedLabel),
              index < locations.count else { return }
        let selected = locations[index]
        delegate?.didSelectLocation(selected)
    }
}

// MARK: - Safe Array Indexing
private extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
