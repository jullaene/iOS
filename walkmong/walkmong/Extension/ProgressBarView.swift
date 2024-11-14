//
//  ProgressBarView.swift
//  walkmong
//
//  Created by 황채웅 on 11/15/24.
//

import UIKit

class ProgressBarView: UIView {
    
    private let progressBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let progressView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlue
        view.layer.cornerRadius = 2
        return view
    }()
    
    private var currentStep: Int = 0
    private var totalSteps: Int = 1
    
    init(currentStep: Int, totalSteps: Int) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .white
        self.addSubview(progressBackgroundView)
        self.addSubview(progressView)
        
        progressBackgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(4)
        }
        
        progressView.snp.makeConstraints { make in
            make.leading.equalTo(progressBackgroundView.snp.leading)
            make.centerY.equalTo(progressBackgroundView.snp.centerY)
            make.height.equalTo(progressBackgroundView.snp.height)
            make.width.equalTo((bounds.width - 40) * CGFloat(currentStep) / CGFloat(totalSteps))
        }
    }
}
