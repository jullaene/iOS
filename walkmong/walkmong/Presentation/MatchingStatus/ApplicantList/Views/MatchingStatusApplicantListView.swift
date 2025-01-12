//
//  MatchingStatusApplicantListView.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit
import SnapKit

final class MatchingStatusApplicantListView: UIView {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let dogProfileView = UIView()
    private let applicantsLabel = SmallTitleLabel(text: "지원한 산책자 (n)")
    
    private let cellContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    private let applicantListCell = MatchingStatusApplicantListCell()
    
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
        backgroundColor = .white
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    // MARK: - Configure Content
    func configureDogProfile(with data: BoardList) {
        dogProfileView.backgroundColor = .gray100
        dogProfileView.layer.cornerRadius = 10
        contentView.addSubviews(dogProfileView, applicantsLabel, cellContainerView)
        
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
        
        applicantsLabel.snp.makeConstraints { make in
            make.top.equalTo(dogProfileView.snp.bottom).offset(52)
            make.leading.equalToSuperview().inset(20)
        }
    }

    func configureApplicantsList(with applicants: [MatchingStatusApplicantDetail]) {
        applicantsLabel.text = "지원한 산책자 (\(applicants.count))"
        
        contentView.subviews.filter { $0 !== dogProfileView && $0 !== applicantsLabel }.forEach { $0.removeFromSuperview() }
        
        var previousContainer: UIView?
        
        for applicant in applicants {
            let cellContainerView = UIView()
            cellContainerView.backgroundColor = .gray100
            cellContainerView.layer.cornerRadius = 10
            cellContainerView.layer.masksToBounds = true
            
            let containerView = UIView()
            containerView.backgroundColor = .clear
            
            let cell = MatchingStatusApplicantListCell()
            cell.updateOwnerInfo(
                ownerProfile: applicant.ownerProfile ?? "defaultProfileImage",
                ownerName: applicant.ownerName,
                ownerAge: applicant.ownerAge,
                ownerGender: applicant.ownerGender,
                ownerRate: applicant.ownerRate ?? 1.0,
                dongAddress: applicant.dongAddress,
                distance: applicant.distance
            )
            
            containerView.addSubview(cell)
            cell.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            cellContainerView.addSubview(containerView)
            containerView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(12)
            }
            
            contentView.addSubview(cellContainerView)
            cellContainerView.snp.makeConstraints { make in
                if let previous = previousContainer {
                    make.top.equalTo(previous.snp.bottom).offset(12)
                } else {
                    make.top.equalTo(applicantsLabel.snp.bottom).offset(12)
                }
                make.leading.trailing.equalToSuperview().inset(20)
            }
            
            previousContainer = cellContainerView
        }
        
        if let lastContainer = previousContainer {
            lastContainer.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-16)
            }
        }
    }
}
