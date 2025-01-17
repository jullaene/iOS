//
//  ProgressBar.swift
//  walkmong
//
//  Created by 황채웅 on 11/10/24.
//

import UIKit

extension UIViewController {
    func addProgressBar(currentStep:Int, totalSteps:Int, backgroundColor: UIColor = .white){
        
        view.subviews.filter { $0.tag == 9999 }.forEach { $0.removeFromSuperview() }

        let backgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .clear
            view.tag = 9999
            return view
        }()
        let progressBackgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .gray200
            view.layer.cornerRadius = 2
            return view
        }()
        let progressView: UIView = {
            let view = UIView()
            view.backgroundColor = .mainBlue
            view.layer.cornerRadius = 2
            return view
        }()
        
        self.view.addSubview(backgroundView)
        backgroundView.addSubview(progressBackgroundView)
        backgroundView.addSubview(progressView)
        
        backgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(119)
            make.height.equalTo(36)
        }
        progressBackgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(4)
        }
        progressView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(16)
            make.width.equalTo((view.bounds.width-40)*CGFloat(currentStep)/CGFloat(totalSteps))
            make.height.equalTo(4)
        }
    }
}
