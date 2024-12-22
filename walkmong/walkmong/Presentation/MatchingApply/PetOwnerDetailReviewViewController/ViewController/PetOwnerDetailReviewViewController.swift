//
//  PetOwnerDetailReviewViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit

class PetOwnerDetailReviewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let detailReviewView = PetOwnerDetailReviewView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCameraTapGesture()

    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(detailReviewView)
        
        detailReviewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addCustomNavigationBar(
            titleText: "산책 후기 쓰기",
            showLeftBackButton: false,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false
        )
    }

    // MARK: - Camera Tap Gesture Setup
    private func setupCameraTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCameraTap))
        detailReviewView.reviewPhotoView.cameraContainerView.isUserInteractionEnabled = true
        detailReviewView.reviewPhotoView.cameraContainerView.addGestureRecognizer(tapGesture)
    }

    @objc private func handleCameraTap() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            // 선택한 이미지를 처리하는 로직
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
