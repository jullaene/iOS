import UIKit
import SnapKit
import Kingfisher

protocol MatchingDogInformationViewDelegate: AnyObject {
    func applyWalkButtonTapped()
}

final class MatchingDogInformationView: UIView, UIScrollViewDelegate {

    // MARK: - Delegate
    weak var delegate: MatchingDogInformationViewDelegate?
    
    // MARK: - UI Components
    private let mainScrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()

    private let profileFrame = ProfileView()
    private let walkInfoFrame = WalkInfoView()
    private let relatedInfoFrame = RelatedInfoView()
    private let walkReviewFrame = WalkReviewFrame()
    private let ownerInfoFrame = OwnerInfoView()
    private let buttonFrame = UIView()

    private let walkTalkButton: UIView = UIView.createRoundedView(backgroundColor: UIColor.gray100, cornerRadius: 15)
    
    private let applyWalkButton = UIButton.createStyledButton(type: .large, style: .dark, title: "산책 지원하기")
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupFrames()
        setupButtonActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Private Methods
    private func setupButtonActions() {
        applyWalkButton.addTarget(self, action: #selector(applyWalkButtonTapped), for: .touchUpInside)
    }

    func setWalkInfoDelegate(
        date: String,
        startTime: String,
        endTime: String,
        locationNegotiationYn: String,
        suppliesProvidedYn: String,
        preMeetAvailableYn: String
    ) {
        walkInfoFrame.updateDetails(
            date: date,
            startTime: startTime,
            endTime: endTime,
            locationNegotiationYn: locationNegotiationYn,
            suppliesProvidedYn: suppliesProvidedYn,
            preMeetAvailableYn: preMeetAvailableYn
        )
    }
    
    func setOwnerInfoDetails(
        ownerProfile: String?,
        ownerName: String,
        ownerAge: Int,
        ownerGender: String,
        ownerRate: Double,
        dongAddress: String,
        distance: Double
    ) {
        ownerInfoFrame.updateOwnerInfo(
            ownerProfile: ownerProfile,
            ownerName: ownerName,
            ownerAge: ownerAge,
            ownerGender: ownerGender,
            ownerRate: ownerRate,
            dongAddress: dongAddress,
            distance: distance
        )
    }
    
    func getProfileFrame() -> ProfileView {
        return profileFrame
    }
    
    @objc private func applyWalkButtonTapped() {
        delegate?.applyWalkButtonTapped()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .white

        addSubview(mainScrollView)
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 102, right: 0))
        }

        mainScrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(imageView.snp.width).multipliedBy(0.757)
        }
        
    }

    // MARK: - Public Method
    func setProfileDelegate(_ delegate: ProfileViewDelegate) {
        profileFrame.setDelegate(delegate)
    }

    func getProfileView() -> ProfileView {
        return profileFrame
    }
    
    func setRelatedInfoDetails(walkNote: String, walkRequest: String, additionalRequest: String) {
        relatedInfoFrame.updateDetails(
            walkNote: walkNote,
            walkRequest: walkRequest,
            additionalRequest: additionalRequest
        )
    }
    
    private func setupFrames() {
        addFramesToContentView([
            (profileFrame, 102, imageView.snp.bottom, 32),
            (walkInfoFrame, nil, profileFrame.snp.bottom, 34),
            (relatedInfoFrame, nil, walkInfoFrame.snp.bottom, 16),
            (walkReviewFrame, 204, relatedInfoFrame.snp.bottom, 16),
            (ownerInfoFrame, 172, walkReviewFrame.snp.bottom, 16)
        ])

        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(ownerInfoFrame.snp.bottom).offset(32)
        }

        setupButtonFrame()
    }

    private func addFramesToContentView(_ frames: [(UIView, CGFloat?, ConstraintRelatableTarget, CGFloat)]) {
        for (frame, height, topAnchor, topOffset) in frames {
            contentView.addSubview(frame)
            frame.snp.makeConstraints { make in
                make.top.equalTo(topAnchor).offset(topOffset)
                make.centerX.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(20)
                if let height = height {
                    make.height.equalTo(height)
                }
            }
        }
    }

    private func setupButtonFrame() {
        addSubview(buttonFrame)
        buttonFrame.backgroundColor = .white
        buttonFrame.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(78)
        }
        
        setupWalkTalkButton()

        applyWalkButton.removeConstraints(applyWalkButton.constraints)
        buttonFrame.addSubview(applyWalkButton)
        applyWalkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(walkTalkButton.snp.trailing).offset(12)
            make.trailing.equalTo(buttonFrame.snp.trailing).inset(17)
            make.height.equalTo(54)
        }

        setupButtonLabel(applyWalkButton, text: "산책 지원하기", textColor: UIColor.gray100)
    }
    
    private func setupWalkTalkButton() {
        buttonFrame.addSubview(walkTalkButton)
        walkTalkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(buttonFrame.snp.leading).offset(20)
            make.width.equalTo(93)
            make.height.equalTo(54)
        }

        let label = UILabel()
        label.text = "워크톡"
        label.textColor = UIColor.gray400
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        
        let icon = UIImageView()
        icon.image = UIImage(named: "messageIcon")
        icon.contentMode = .scaleAspectFit

        let stackView = UIStackView(arrangedSubviews: [label, icon])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        walkTalkButton.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupButtonLabel(_ button: UIView, text: String, textColor: UIColor) {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.textAlignment = .center

        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    // MARK: - Helper Methods
    func configureImages(with imageUrls: [String?]) {
        guard let firstImageUrl = imageUrls.first else {
            imageView.image = UIImage(named: "placeholder")
            return
        }

        if let url = URL(string: firstImageUrl ?? "") {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
}
