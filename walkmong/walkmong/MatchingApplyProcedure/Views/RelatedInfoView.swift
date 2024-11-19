import UIKit
import SnapKit

class RelatedInfoView: UIView {
    
    // MARK: - UI Components
    private let titleLabel = RelatedInfoView.createLabel(
        text: "산책 관련 정보",
        textColor: UIColor.gray600,
        font: UIFont(name: "Pretendard-Bold", size: 20),
        lineHeightMultiple: 1.17,
        kern: -0.32
    )
    
    private let requestTitleLabel = RelatedInfoView.createLabel(
        text: "산책 요청 사항",
        textColor: UIColor.gray600,
        font: UIFont(name: "Pretendard-SemiBold", size: 16)
    )
    
    private let requestDescriptionLabel = RelatedInfoView.createLabel(
        text: "",
        textColor: UIColor.gray500,
        font: UIFont(name: "Pretendard-Medium", size: 16),
        numberOfLines: 0
    )
    
    private let referenceTitleLabel = RelatedInfoView.createLabel(
        text: "산책 참고 사항",
        textColor: UIColor.gray600,
        font: UIFont(name: "Pretendard-SemiBold", size: 16)
    )
    
    private let referenceDescriptionLabel = RelatedInfoView.createLabel(
        text: "",
        textColor: UIColor.gray500,
        font: UIFont(name: "Pretendard-Medium", size: 16)
    )
    
    private let additionalInfoTitleLabel = RelatedInfoView.createLabel(
        text: "추가 안내 사항",
        textColor: UIColor.gray600,
        font: UIFont(name: "Pretendard-SemiBold", size: 16)
    )
    
    private let additionalInfoDescriptionLabel = RelatedInfoView.createLabel(
        text: "",
        textColor: UIColor.gray500,
        font: UIFont(name: "Pretendard-Medium", size: 16)
    )
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .gray100
        layer.cornerRadius = 20
        
        // Add all labels to the view
        let labels = [
            titleLabel,
            requestTitleLabel,
            requestDescriptionLabel,
            referenceTitleLabel,
            referenceDescriptionLabel,
            additionalInfoTitleLabel,
            additionalInfoDescriptionLabel
        ]
        
        for label in labels {
            addSubview(label)
        }
        
        // Setup constraints
        setupConstraints(labels: labels)
    }
    
    private func setupConstraints(labels: [UILabel]) {
        labels[0].snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(111)
        }
        
        for i in 1..<labels.count {
            labels[i].snp.makeConstraints { make in
                make.top.equalTo(labels[i - 1].snp.bottom).offset(i % 2 == 0 ? 8 : 24)
                make.leading.equalToSuperview().offset(24)
                make.trailing.equalToSuperview().offset(-24)
            }
        }
        
        labels.last?.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    // MARK: - Public Methods
    func updateDetails(walkNote: String, walkRequest: String, additionalRequest: String) {
        requestDescriptionLabel.text = walkNote
        referenceDescriptionLabel.text = walkRequest
        additionalInfoDescriptionLabel.text = additionalRequest
    }
    
    // MARK: - Helper Method
    private static func createLabel(
        text: String,
        textColor: UIColor,
        font: UIFont?,
        lineHeightMultiple: CGFloat = 1.0,
        kern: CGFloat = 0.0,
        numberOfLines: Int = 0
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = font
        label.numberOfLines = numberOfLines
        label.lineBreakMode = .byCharWrapping // UILabel의 lineBreakMode 설정

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.lineBreakMode = .byCharWrapping // NSParagraphStyle의 lineBreakMode 설정

        let attributes: [NSAttributedString.Key: Any] = [
            .kern: kern,
            .paragraphStyle: paragraphStyle
        ]

        label.attributedText = NSAttributedString(string: text, attributes: attributes)
        
        return label
    }
}
