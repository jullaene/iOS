//
//  ReviewPhotoView.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit
import SnapKit

class ReviewPhotoView: UIView, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - UI Elements
    private let detailedReviewLabel: SmallTitleLabel = {
        let label = SmallTitleLabel(text: "김철수님에 대한 자세한 후기를 남겨주세요.", textColor: .mainBlack)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let cameraContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.gray100.cgColor
        return view
    }()
    
    private let cameraIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cameraIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let photoCountLabel: BaseTitleLabel = {
        return BaseTitleLabel(
            text: "사진 0/2",
            font: UIFont(name: "Pretendard-Regular", size: 12)!,
            textColor: .gray600
        )
    }()
    
    let placeholderText = "작성한 산책 후기는 닉네임, 프로필 이미지와 함께 누구나 볼 수 있도록 공개됩니다. 내용에 민감한 개인정보가 포함되지 않도록 조심해주세요. (최소 20자 이상)"
    
    lazy var reviewTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.text = placeholderText
        textView.textColor = .gray500
        textView.backgroundColor = .gray100
        textView.layer.cornerRadius = 5
        textView.font = UIFont(name: "Pretendard-Regular", size: 14)
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.delegate = self
        return textView
    }()
    
    private let charCountLabel = MainParagraphLabel(text: "(0/\(CharacterCountManager.maxCharacterCount))", textColor: .gray400)
    
    private var photoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var addedPhotos: [UIImageView] = []
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubviews(detailedReviewLabel, cameraContainerView, photoContainer, reviewTextView, charCountLabel)
        cameraContainerView.addSubviews(cameraIcon, photoCountLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCameraTapped))
        cameraContainerView.addGestureRecognizer(tapGesture)

        setupConstraints()
    }
    
    private func setupConstraints() {
        detailedReviewLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        cameraContainerView.snp.makeConstraints { make in
            make.top.equalTo(detailedReviewLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        cameraIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        photoCountLabel.snp.makeConstraints { make in
            make.top.equalTo(cameraIcon.snp.bottom).offset(9)
            make.centerX.equalToSuperview()
        }
        
        photoContainer.snp.makeConstraints { make in
            make.leading.equalTo(cameraContainerView.snp.trailing).offset(12)
            make.centerY.equalTo(cameraContainerView)
            make.height.equalTo(80)
        }
        
        reviewTextView.snp.makeConstraints { make in
            make.top.equalTo(cameraContainerView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(224)
        }
        
        charCountLabel.snp.makeConstraints { make in
            make.bottom.equalTo(reviewTextView.snp.bottom).offset(-12)
            make.trailing.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - Photo Handling
    func addPhoto(image: UIImage) {
        guard addedPhotos.count < 2 else { return }

        let photoView = UIImageView()
        photoView.image = image
        photoView.layer.cornerRadius = 5
        photoView.clipsToBounds = true
        photoView.contentMode = .scaleAspectFill
        photoContainer.addSubview(photoView)

        let deleteImageBtn = UIButton()
        deleteImageBtn.setImage(UIImage(named: "deleteImageBtn"), for: .normal)
        deleteImageBtn.addTarget(self, action: #selector(handleDeleteImage(_:)), for: .touchUpInside)
        photoContainer.addSubview(deleteImageBtn)

        deleteImageBtn.accessibilityIdentifier = String(addedPhotos.count)

        let offset = addedPhotos.isEmpty ? cameraContainerView.snp.trailing : addedPhotos.last!.snp.trailing
        let spacing = addedPhotos.isEmpty ? 12 : 24

        photoView.snp.makeConstraints { make in
            make.leading.equalTo(offset).offset(spacing)
            make.width.height.equalTo(80)
            make.centerY.equalToSuperview()
        }

        deleteImageBtn.snp.makeConstraints { make in
            make.top.equalTo(photoView.snp.top).offset(-4)
            make.trailing.equalTo(photoView.snp.trailing).offset(12)
            make.width.height.equalTo(20)
        }

        addedPhotos.append(photoView)
        photoCountLabel.text = "사진 \(addedPhotos.count)/2"

        self.layoutIfNeeded()
    }

    @objc private func handleDeleteImage(_ sender: UIButton) {
        guard let identifier = sender.accessibilityIdentifier,
              let index = Int(identifier),
              index < addedPhotos.count else {
            print("Error: Associated photoView not found")
            return
        }

        let photoView = addedPhotos[index]

        addedPhotos.remove(at: index)

        photoView.removeFromSuperview()
        sender.removeFromSuperview()

        photoCountLabel.text = "사진 \(addedPhotos.count)/2"

        rearrangePhotos()

        layoutIfNeeded()
    }

    private func rearrangePhotos() {
        for (index, photoView) in addedPhotos.enumerated() {
            let offset: ConstraintRelatableTarget = index == 0 ? cameraContainerView.snp.trailing : addedPhotos[index - 1].snp.trailing
            let spacing = index == 0 ? 12 : 24

            photoView.snp.remakeConstraints { make in
                make.leading.equalTo(offset).offset(spacing)
                make.width.height.equalTo(80)
                make.centerY.equalToSuperview()
            }
        }
    }
    
    @objc private func handleCameraTapped() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        if let viewController = self.findViewController() {
            viewController.present(picker, animated: true, completion: nil)
        }
    }

    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let editedImage = info[.editedImage] as? UIImage {
            addPhoto(image: editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            addPhoto(image: originalImage)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .mainBlack
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .gray500
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let isPlaceholder = textView.text == placeholderText
        let textToCount = isPlaceholder ? "" : textView.text
        let characterCount = textToCount?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0

        CharacterCountManager.updateCountLabel(
            textView: textView,
            remainLabel: charCountLabel
        )
        
        let isValid = characterCount > 0 && !isPlaceholder
    }
    
}
