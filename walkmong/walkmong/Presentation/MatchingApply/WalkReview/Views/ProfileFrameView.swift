//
//  ProfileFrameView.swift
//  walkmong
//
//  Created by 신호연 on 12/8/24.
//

import UIKit
import SnapKit
import Kingfisher

class ProfileFrameView: UIView {

    // MARK: - Subviews
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 22
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "defaultImage")
        return imageView
    }()

    private let reviewerIdLabel = MainHighlightParagraphLabel(text: "", textColor: .gray600)
    private let walkDateLabel = SmallMainParagraphLabel(text: "", textColor: .gray500)
    
    private let reportLabel: UILabel = {
        let label = UILabel()
        label.text = "신고하기"
        label.textColor = UIColor.gray400
        label.font = UIFont(name: "Pretendard-Medium", size: 12)
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray400
        return view
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    private func configureView() {
        backgroundColor = .clear
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        [profileImageView, reviewerIdLabel, walkDateLabel, reportLabel, underlineView].forEach { addSubview($0) }
    }

    func configure(with data: DogReviewModel.ProfileData) {
        if let imageURL = data.image {
            profileImageView.kf.setImage(
                with: imageURL,
                placeholder: UIImage(named: "defaultImage"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ],
                progressBlock: { receivedSize, totalSize in
                    print("Loading progress: \(receivedSize)/\(totalSize)")
                },
                completionHandler: { result in
                    switch result {
                    case .success(let value):
                        print("Image loaded successfully: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Image loading failed: \(error.localizedDescription)")
                        self.profileImageView.image = UIImage(named: "defaultImage")
                    }
                }
            )
        } else {
            profileImageView.image = UIImage(named: "defaultImage")
        }
        reviewerIdLabel.text = data.reviewerId
        walkDateLabel.text = data.walkDate
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        reviewerIdLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(9)
            make.top.equalToSuperview()
            make.height.equalTo(22)
        }
        
        walkDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(reviewerIdLabel)
            make.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
        
        reportLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(reportLabel.snp.bottom).offset(1)
            make.centerX.equalTo(reportLabel)
            make.width.equalTo(reportLabel)
            make.height.equalTo(0.5)
        }
    }
    
    // MARK: - Gesture Setup
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(reportLabelTapped))
        reportLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func reportLabelTapped() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController as? UINavigationController else { return }

        let reportVC = MyPageReportViewController()
        rootViewController.pushViewController(reportVC, animated: true)
    }
}
