//
//  PetOwnerDetailReviewViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit

class PetOwnerDetailReviewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let detailReviewView = PetOwnerDetailReviewView()
    private let networkManager = NetworkManager()
    private var selectedHashtags: [String] = []
    private let maxHashtagSelection = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCameraTapGesture()
        setupSubmitButtonAction()
        setupHashtagSelection()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
    
    private func setupSubmitButtonAction() {
        detailReviewView.submitButton.addTarget(self, action: #selector(handleSubmitButtonTap), for: .touchUpInside)
    }
    
    private func setupHashtagSelection() {
        for button in detailReviewView.hashtagView.hashtagButtons {
            button.addTarget(self, action: #selector(handleHashtagButtonTap(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func handleHashtagButtonTap(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        
        if selectedHashtags.contains(title) {
            selectedHashtags.removeAll { $0 == title }
            sender.updateStyle(type: .tag, style: .light)
            sender.setTitleColor(.mainBlack, for: .normal)
        } else {
            guard selectedHashtags.count < maxHashtagSelection else { return }
            selectedHashtags.append(title)
            sender.updateStyle(type: .tag, style: .dark)
            sender.setTitleColor(.white, for: .normal)
        }
    }
    
    @objc private func handleSubmitButtonTap() {
        guard let walkerId = getWalkerId(),
              let boardId = getBoardId(),
              let ratings = collectRatings(),
              let content = collectReviewContent() else { return }
        
        let hashtags = collectSelectedHashtags()
        let images = collectImages()
        
        let requestBody: [String: Any] = [
            "walkerId": walkerId,
            "boardId": boardId,
            "timePunctuality": ratings["timePunctuality"] ?? 0.0,
            "communication": ratings["communication"] ?? 0.0,
            "attitude": ratings["attitude"] ?? 0.0,
            "taskCompletion": ratings["taskCompletion"] ?? 0.0,
            "photoSharing": ratings["photoSharing"] ?? 0.0,
            "hashtags": hashtags,
            "images": images,
            "content": content
        ]
        
        sendReviewDataToServer(requestBody: requestBody)
    }
    
    private func getWalkerId() -> [Int64]? {
        return [1]
    }
    
    private func getBoardId() -> [Int64]? {
        return [1]
    }
    
    private func collectRatings() -> [String: Float]? {
        return [
            "timePunctuality": 4.5,
            "communication": 4.0,
            "attitude": 5.0,
            "taskCompletion": 4.5,
            "photoSharing": 3.5
        ]
    }
    
    private func collectSelectedHashtags() -> [String] {
        return ["LIKED_BY_DOG", "POLITE"]
    }
    
    private func collectImages() -> [String] {
        return []
    }
    
    private func collectReviewContent() -> String? {
        let content = detailReviewView.reviewPhotoView.reviewTextView.text
        return content?.count ?? 0 >= 20 ? content : nil
    }
    
    private func sendReviewDataToServer(requestBody: [String: Any]) {
        networkManager.fetchBoardDetail(boardId: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                print("후기가 성공적으로 등록되었습니다.")
                DispatchQueue.main.async {
                    self.navigateToMatchingViewController()
                }
            case .failure(let error):
                print("후기를 등록하지 못했습니다. 오류: \(error.localizedDescription)")
            }
        }
    }
    
    private func navigateToMatchingViewController() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        if let mainTabBarController = sceneDelegate.window?.rootViewController as? MainTabBarController {
            mainTabBarController.selectedIndex = 0
            navigationController?.popToRootViewController(animated: true)
        }
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
