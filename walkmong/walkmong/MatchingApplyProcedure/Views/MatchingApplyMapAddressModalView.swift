//
//  MatchingApplyMapAddressModalView.swift
//  walkmong
//
//  Created by 황채웅 on 11/10/24.
//

import UIKit

protocol MatchingApplyMapAddressModalViewDelegate: AnyObject {
    func didTapDecideButton()
    func didEndEditing(for textfield: UITextField)
}

class MatchingApplyMapAddressModalView: UIView {
    
    weak var delegate: MatchingApplyMapAddressModalViewDelegate?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 20
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private let innerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .locationIconMainBlue
        return imageView
    }()
    
    private let dongLabel: UILabel = {
        let label = UILabel()
        label.text = "동 주소"
        label.font = UIFont(name:"Pretendard-Bold",size:20)
        label.textColor = .mainBlue
        label.textAlignment = .left
        return label
    }()
    
    private let roadAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "도로명 주소"
        label.font = UIFont(name:"Pretendard-Bold",size:20)
        label.textColor = .gray600
        label.textAlignment = .left
        return label
    }()
    
    private let memoLabel: UILabel = {
        let label = UILabel()
        label.text = "자세한 만남 장소 포인트 메모 "
        label.font = UIFont(name:"Pretendard-SemiBold",size:16)
        label.textColor = .gray600
        label.textAlignment = .left
        return label
    }()
    
    private let memoTextField: UITextField = {
        let textField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 46))
        textField.addCharacterSpacing()
        textField.placeholder = "어디 앞에서 만날지 자세히 적어주세요."
        textField.setPlaceholderColor(.gray400)
        textField.leftView = paddingView
        textField.rightView = paddingView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.textColor = .gray500
        textField.font = UIFont(name:"Pretendard-Medium",size: 16)
        textField.backgroundColor = .gray200
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("만남장소 정하기", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .gray300
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraints()
        memoTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews(){
        addSubview(containerView)
        containerView.addSubview(innerView)
        innerView.addSubviews(iconImageView, dongLabel, memoLabel, roadAddressLabel, memoTextField, nextButton)
    }
    
    private func setConstraints(){
        containerView.snp.makeConstraints { make in
            make.height.equalTo(346)
            make.horizontalEdges.equalToSuperview()
        }
        innerView.snp.makeConstraints { make in
            make.height.equalTo(346)
            make.horizontalEdges.equalToSuperview()
        }
        dongLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(48)
        }
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(dongLabel)
            make.leading.equalToSuperview().offset(24)
            make.height.width.equalTo(20)
        }
        roadAddressLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(dongLabel.snp.bottom).offset(12)
        }
        memoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(roadAddressLabel.snp.bottom).offset(24)
        }
        memoTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(memoLabel.snp.bottom).offset(12)
            make.height.equalTo(46)
        }
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(memoTextField.snp.bottom).offset(24)
            make.height.equalTo(54)
        }
    }
    
    private func setTextFieldConfigure(){
        memoTextField.delegate = self
    }
    
    func updateButtonState(value: Bool){
        print(value)
        nextButton.backgroundColor = value ? .gray600 : .gray300
    }
    
    @objc func nextButtonTapped(){
        delegate?.didTapDecideButton()
    }
    
    func configure(with data: MatchingApplyMapModel){
        self.dongLabel.text = data.dongAddress
        self.roadAddressLabel.text = data.roadAddress
    }
}

extension MatchingApplyMapAddressModalView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 255
        guard let text = textField.text else { return true }
        let newlength = text.count + string.count - range.length
        if let keyword = textField.text {
            nextButton.backgroundColor = !keyword.trimmingCharacters(in: .whitespaces).isEmpty ? .gray600 : .gray300
        }
        return newlength < maxLength
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let keyword = textField.text {
            delegate?.didEndEditing(for: textField)
            nextButton.backgroundColor = !keyword.trimmingCharacters(in: .whitespaces).isEmpty ? .gray600 : .gray300
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 공백 값 필터링
        if let keyword = textField.text, !keyword.trimmingCharacters(in: .whitespaces).isEmpty {
            delegate?.didEndEditing(for: textField)
            endEditing(true)
            return true
        }
        return false
    }
}
