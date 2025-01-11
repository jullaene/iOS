//
//  MatchingStatusApplicantDetailView.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit
import SnapKit
import Charts

final class MatchingStatusApplicantDetailView: UIView {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let dogProfileView = UIView()
    private let applicantInfoLabel = SmallTitleLabel(text: "지원한 산책 정보", textColor: .gray600)
    private let applicantInfoCell = MatchingStatusApplicantDetailCell()
    private let walkerReviewTitle = SmallTitleLabel(text: "김철수님의 산책자 후기")
    private let walkerReviewCount = MainHighlightParagraphLabel(text: "3개", textColor: .gray600)
    private let arrowImageView = UIImageView(image: UIImage(named: "MyPageReviewArrow"))
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        setupScrollView()
        setupContentView()
    }
    
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    func configureDogProfileSection(with data: MatchingData) {
        dogProfileView.backgroundColor = .white
        dogProfileView.layer.cornerRadius = 10
        
        contentView.addSubviews(dogProfileView, applicantInfoLabel)
        
        dogProfileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(187)
        }
        
        let dogProfileCell = MatchingCell()
        dogProfileCell.configure(with: data)
        dogProfileCell.setCustomViewAppearance(
            hideSizeLabel: true,
            hideDistanceLabel: true,
            hideTimeLabel: true,
            backgroundColor: .clear
        )
        dogProfileView.addSubview(dogProfileCell)
        dogProfileCell.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        applicantInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(dogProfileView.snp.bottom).offset(48)
            make.leading.equalToSuperview().inset(20)
        }
    }
    
    func configureReviewSection() {
        contentView.addSubviews(walkerReviewTitle, walkerReviewCount, arrowImageView)
        
        walkerReviewTitle.snp.makeConstraints { make in
            make.top.equalTo(applicantInfoCell.snp.bottom).offset(48)
            make.leading.equalTo(applicantInfoCell)
            make.bottom.equalTo(0)
        }
        
        walkerReviewCount.snp.makeConstraints { make in
            make.centerY.equalTo(walkerReviewTitle)
            make.leading.equalTo(walkerReviewTitle.snp.trailing).offset(4)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(walkerReviewTitle)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Configure Applicant Info Section
    func configureApplicantsList(with applicant: MatchingStatusApplicantInfo) {
        clearApplicantRelatedSubviews()
        setupApplicantInfoCell(with: applicant)
        
        contentView.addSubview(applicantInfoCell)
        applicantInfoCell.snp.makeConstraints { make in
            make.top.equalTo(applicantInfoLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func clearApplicantRelatedSubviews() {
        contentView.subviews.filter { $0 !== dogProfileView && $0 !== applicantInfoLabel }.forEach { $0.removeFromSuperview() }
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
        
        contentView.addSubview(applicantInfoCell)
        applicantInfoCell.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(applicantInfoLabel.snp.bottom).offset(20)
        }
    }
}
