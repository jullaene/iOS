import UIKit

class BaseTitleLabel: UILabel {
    init(text: String, font: UIFont, textColor: UIColor = .mainBlack) {
        super.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = textColor
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle() {
        self.addCharacterSpacing(-0.32)
        self.setLineSpacing(ratio: 1.4)
    }
}

class LargeTitleLabel: BaseTitleLabel {
    init(text: String, textColor: UIColor = .mainBlack) {
        super.init(text: text, font: UIFont(name: "Pretendard-Bold", size: 24)!, textColor: textColor)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MiddleTitleLabel: BaseTitleLabel {
    init(text: String, textColor: UIColor = .mainBlack) {
        super.init(text: text, font: UIFont(name: "Pretendard-Bold", size: 20)!, textColor: textColor)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SmallTitleLabel: BaseTitleLabel {
    init(text: String, textColor: UIColor = .mainBlack) {
        super.init(text: text, font: UIFont(name: "Pretendard-Bold", size: 18)!, textColor: textColor)
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
