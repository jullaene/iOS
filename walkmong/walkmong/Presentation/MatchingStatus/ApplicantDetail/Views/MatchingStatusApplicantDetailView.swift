import UIKit
import SnapKit
import Charts

protocol MatchingStatusApplicantDetailViewDelegate: AnyObject {
    func didTapApplyButton()
    func didTapWalktalkButton()
}

final class MatchingStatusApplicantDetailView: UIView {
    
    weak var delegate: MatchingStatusApplicantDetailViewDelegate?
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let dogProfileView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    private let applicantInfoLabel = SmallTitleLabel(text: "지원한 산책 정보", textColor: .gray600)
    private let applicantInfoCell = MatchingStatusApplicantDetailCell()
    private let myPageReviewView = MyPageReviewView()
    
    private let meetingPlace: UIView = CustomView.createCustomView(
        titleText: "만남 장소",
        centerLabelText: "강남구 학동로 508",
        contentText: "스타벅스 로고 앞에서 만나요!",
        layoutOption: .centerAndLeftAligned
    )
    private let walkSuppliesProvided: UIView = CustomView.createCustomView(
        titleText: "산책 용품 제공",
        contentText: "배변봉투, 입마개, 리드줄(목줄)이 필요해요.",
        contentTextAlignment: .center
    )
    private let preMeeting: UIView = CustomView.createCustomView(
        titleText: "사전 만남",
        warningText: "매칭 확정 후 산책자와 상의하여 사전 만남을 진행해 주세요",
        warningColor: .mainBlue,
        contentText: "산책일 전 사전 만남이 필요해요.",
        contentTextAlignment: .center
    )
    private let sendMessage: UIView = CustomView.createCustomView(
        titleText: "반려인에게 전달할 메시지",
        contentText: "저 열심히 산책 시킬 수 있습니다!! 강아지를 좋아해서 꼭 산책시키고 싶어요. 책임지고 열심히 임할 수 있습니다 꼭 시켜주세요!!!!!!",
        contentTextColor: .gray500,
        layoutOption: .leftAlignedContent
    )
    
    private let buttonFrame = UIView()
    private let walkTalkButton = CustomButtonView(
        backgroundColor: UIColor.gray200,
        cornerRadius: 15,
        text: "워크톡",
        textColor: UIColor.gray400,
        iconName: "messageIcon"
    )
    private let applyWalkButton = UIButton.createStyledButton(type: .large, style: .dark, title: "매칭 확정")

    // User Rating
    private let userRatingView = UIView.createRoundedView(backgroundColor: .white, cornerRadius: 15)
    private let userRatingTitleLabel = SmallTitleLabel(text: "전체 사용자 평가", textColor: .gray600)
    private let participantCountLabel = SmallMainParagraphLabel(text: "참여자수", textColor: .gray400)
    private let starRatingLabel = MainHighlightParagraphLabel(text: "평점", textColor: .gray600)
    private let radarChart = CustomRadarChartView()
    private let starIcon = UIImage.createImageView(named: "MyPageStarIcon")
    
    // Keyword
    private let keywordView = UIView.createRoundedView(backgroundColor: .white, cornerRadius: 15)
    private let keywordTitleLabel = SmallTitleLabel(text: "()님의 키워드 TOP 3", textColor: .gray600)
    private let keywordBubbleContainer = UIView()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewHierarchy()
        setupButtonActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupViewHierarchy() {
        addSubviews(scrollView, buttonFrame)
        scrollView.addSubview(contentView)
        contentView.addSubviews(dogProfileView, applicantInfoLabel, applicantInfoCell, myPageReviewView, meetingPlace, walkSuppliesProvided, preMeeting, sendMessage)
        
        // User Rating View
        addSubviews(userRatingView)
        userRatingView.addSubviews(userRatingTitleLabel, participantCountLabel, starRatingLabel, starIcon, radarChart)
        
        // Keyword View
        addSubview(keywordView)
        keywordView.addSubviews(keywordTitleLabel, keywordBubbleContainer)
        
        
        myPageReviewView.setupChartView()
        myPageReviewView.setupWalkerReviewTapAction()
        myPageReviewView.setupDonutChart()
        setupConstraints()
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 102, right: 0))
        }
        
        buttonFrame.backgroundColor = .gray100
        buttonFrame.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(78)
        }
        
        buttonFrame.addSubviews(walkTalkButton, applyWalkButton)
        walkTalkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(buttonFrame.snp.leading).offset(20)
            make.width.equalTo(93)
            make.height.equalTo(54)
        }
        applyWalkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(walkTalkButton.snp.trailing).offset(12)
            make.trailing.equalTo(buttonFrame.snp.trailing).inset(17)
            make.height.equalTo(54)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        dogProfileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(187)
        }

        applicantInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(dogProfileView.snp.bottom).offset(48)
            make.leading.equalToSuperview().inset(20)
        }

        applicantInfoCell.snp.makeConstraints { make in
            make.top.equalTo(applicantInfoLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        myPageReviewView.snp.makeConstraints { make in
            make.top.equalTo(applicantInfoCell.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        meetingPlace.snp.makeConstraints { make in
            make.top.equalTo(myPageReviewView.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        walkSuppliesProvided.snp.makeConstraints { make in
            make.top.equalTo(meetingPlace.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        preMeeting.snp.makeConstraints { make in
            make.top.equalTo(walkSuppliesProvided.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        sendMessage.snp.makeConstraints { make in
            make.top.equalTo(preMeeting.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(43)
        }
    }

    // MARK: - Configure Methods
    func configureDogProfileSection(with data: BoardList) {
        setupDogProfileCell(with: data)
    }

    private func setupDogProfileCell(with data: BoardList) {
        let dogProfileCell = MatchingCell()
        dogProfileCell.configure(with: data, selectedDate: "수정")
        dogProfileCell.setCustomViewAppearance(hideSizeLabel: true, backgroundColor: .clear)

        dogProfileView.addSubview(dogProfileCell)
        dogProfileCell.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(12)
        }
    }

    func configureApplicantsList(with applicant: MatchingStatusApplicantInfo) {
        setupApplicantInfoCell(with: applicant)
    }

    private func setupApplicantInfoCell(with applicant: MatchingStatusApplicantInfo) {
        applicantInfoCell.backgroundColor = .white
        applicantInfoCell.layer.cornerRadius = 10
        applicantInfoCell.layer.masksToBounds = true

        applicantInfoCell.updateOwnerInfo(
            ownerProfile: applicant.ownerProfile ?? "defaultProfileImage",
            ownerName: applicant.ownerName,
            ownerAge: applicant.ownerAge,
            ownerGender: applicant.ownerGender,
            dongAddress: applicant.dongAddress,
            distance: applicant.distance
        )
    }

    func updateOwnerInfo(
        ownerProfile: String?,
        ownerName: String,
        ownerAge: Int,
        ownerGender: String,
        dongAddress: String,
        distance: Double
    ) {
//        walkerReviewTitle.text = "\(ownerName)님의 산책자 후기"
    }
    
    private func setupButtonActions() {
        let tapGesture = UITapGestureRecognizer(target: self.walkTalkButton, action: #selector(didTapWalkTalkButton))
        self.walkTalkButton.addGestureRecognizer(tapGesture)
        applyWalkButton.addTarget(self, action: #selector(didTapApplyWalkButton), for: .touchUpInside)
    }
    
    @objc private func didTapWalkTalkButton() {
        delegate?.didTapWalktalkButton()
    }
    
    @objc private func didTapApplyWalkButton() {
        delegate?.didTapApplyButton()
    }
}
