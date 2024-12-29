//
//  PetOwnerDetailReviewViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit

class PetOwnerDetailReviewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let detailReviewView = PetOwnerDetailReviewView()
    private let networkProvider = NetworkProvider<ReviewAPI>()
    private var selectedHashtags: [String] = []
    private var selectedImages: [UIImage] = []
    private let maxHashtagSelection = 3
    private let maxImageSelection = 2
    private var walkerId: [Int64] = []
    private var boardId: [Int64] = []
    private var basicRatings: [String: Float] = [:]
    
    init(walkerId: [Int64], boardId: [Int64], basicRatings: [String: Float]) {
        self.walkerId = walkerId
        self.boardId = boardId
        self.basicRatings = basicRatings
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        guard selectedImages.count < maxImageSelection else {
            print("이미지는 최대 \(maxImageSelection)개까지 추가할 수 있습니다.")
            return
        }
        
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
        guard !walkerId.isEmpty, !boardId.isEmpty else {
            print("필수 데이터(walkerId 또는 boardId)가 설정되지 않았습니다.")
            return
        }

        let ratings = collectRatings() ?? [:]
        let content = collectReviewContent() ?? ""

        let requestBody: [String: Any] = collectDetailedReviewData(
            walkerId: walkerId,
            boardId: boardId,
            ratings: ratings,
            content: content
        )

        Task {
            await sendReviewData(requestBody: requestBody)
        }
    }

    private func collectDetailedReviewData(
        walkerId: [Int64],
        boardId: [Int64],
        ratings: [String: Float],
        content: String
    ) -> [String: Any] {
        let hashtags = collectSelectedHashtags()
        let images = selectedImages.map { $0.pngData()?.base64EncodedString() ?? "" }
        
        return [
            "walkerId": walkerId,
            "boardId": boardId,
            "timePunctuality": basicRatings["timePunctuality"] ?? 0.0,
            "communication": basicRatings["communication"] ?? 0.0,
            "attitude": basicRatings["attitude"] ?? 0.0,
            "taskCompletion": basicRatings["taskCompletion"] ?? 0.0,
            "photoSharing": basicRatings["photoSharing"] ?? 0.0,
            "hashtags": hashtags,
            "images": images,
            "content": content
        ]
    }
    
    private func collectRatings() -> [String: Float]? {
        let ratingTitles = [
            "timePunctuality",
            "communication",
            "attitude",
            "taskCompletion",
            "photoSharing"
        ]

        let ratings = detailReviewView.reviewPhotoView.ratingStackView.arrangedSubviews
            .compactMap { $0 as? RatingQuestionView }
            .enumerated()
            .reduce(into: [String: Float]()) { result, item in
                let (index, view) = item
                guard index < ratingTitles.count else { return }
                let rating = Float(view.getSelectedRating())
                if rating > 0 {
                    result[ratingTitles[index]] = rating
                }
            }

        return ratings.count == ratingTitles.count ? ratings : nil
    }
    
    private func collectSelectedHashtags() -> [String] {
        return selectedHashtags
    }
    
    private func collectReviewContent() -> String? {
        let content = detailReviewView.reviewPhotoView.reviewTextView.text
        return content?.count ?? 0 >= 20 ? content : nil
    }
    
    private func sendReviewData(requestBody: [String: Any]) async {
        // 디버깅용 로그 추가
        print("전송할 데이터 (상세 리뷰):")
        requestBody.forEach { key, value in
            print("\(key): \(value)")
        }
        
        do {
            let response: APIResponse<EmptyDTO> = try await networkProvider.request(
                target: .registerReview(requestBody: requestBody),
                responseType: APIResponse<EmptyDTO>.self
            )
            print("후기 등록 성공: \(response.message)")
            navigateToMatchingViewController()
        } catch {
            print("후기 등록 실패: \(error.localizedDescription)")
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
            selectedImages.append(selectedImage)
            detailReviewView.reviewPhotoView.addPhoto(image: selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
