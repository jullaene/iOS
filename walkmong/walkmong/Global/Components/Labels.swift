import UIKit

class BaseTitleLabel: UILabel {
    init(text: String, font: UIFont, textColor: UIColor = .gray600) {
        super.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = textColor
        self.numberOfLines = 0
        applyTextAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyTextAttributes() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = (self.font?.lineHeight ?? 0) * 0.4 // 행간 140%
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineBreakStrategy = .hangulWordPriority

        let attributedText = NSMutableAttributedString(
            string: self.text ?? "오류",
            attributes: [
                .font: self.font ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: self.textColor ?? .gray400,
                .paragraphStyle: paragraphStyle,
                .kern: -0.32 // 자간 설정
            ]
        )

        self.attributedText = attributedText
    }
}

class LargeTitleLabel: BaseTitleLabel {
    init(text: String, textColor: UIColor = .mainBlack) {
        super.init(text: text, font: UIFont(name: "Pretendard-Bold", size: 28)!, textColor: textColor)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MiddleTitleLabel: BaseTitleLabel {
    init(text: String, textColor: UIColor = .mainBlack) {
        super.init(text: text, font: UIFont(name: "Pretendard-Bold", size: 24)!, textColor: textColor)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SmallTitleLabel: BaseTitleLabel {
    init(text: String, textColor: UIColor = .mainBlack) {
        super.init(text: text, font: UIFont(name: "Pretendard-Bold", size: 20)!, textColor: textColor)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UpperTitleLabel: BaseTitleLabel {
    init(text: String, textColor: UIColor = .mainBlack) {
        super.init(text: text, font: UIFont(name: "Pretendard-SemiBold", size: 20)!, textColor: textColor)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MainParagraphLabel: BaseTitleLabel {
    init(text: String, textColor: UIColor = .mainBlack) {
        super.init(text: text, font: UIFont(name: "Pretendard-Medium", size: 16)!, textColor: textColor)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MainHighlightParagraphLabel: BaseTitleLabel {
    init(text: String, textColor: UIColor = .mainBlack) {
        super.init(text: text, font: UIFont(name: "Pretendard-SemiBold", size: 16)!, textColor: textColor)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SmallMainParagraphLabel: BaseTitleLabel {
    init(text: String, textColor: UIColor = .mainBlack) {
        super.init(text: text, font: UIFont(name: "Pretendard-Regular", size: 14)!, textColor: textColor)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SmallMainHighlightParagraphLabel: BaseTitleLabel {
    init(text: String, textColor: UIColor = .mainBlack) {
        super.init(text: text, font: UIFont(name: "Pretendard-SemiBold", size: 14)!, textColor: textColor)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CaptionLabel: BaseTitleLabel {
    init(text: String, textColor: UIColor = .mainBlack) {
        super.init(text: text, font: UIFont(name: "Pretendard-SemiBold", size: 12)!, textColor: textColor)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
