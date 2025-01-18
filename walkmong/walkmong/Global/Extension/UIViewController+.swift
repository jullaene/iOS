//
//  UIViewController+.swift
//  walkmong
//
//  Created by 황채웅 on 11/10/24.
//

import UIKit

extension UIViewController {
    
    func dismissKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showLoading() {
        let loadingView = UIActivityIndicatorView(style: .large)
        loadingView.color = .gray
        loadingView.startAnimating()
        loadingView.tag = 999 // 로딩 뷰 식별용 태그
        loadingView.center = self.view.center
        self.view.addSubview(loadingView)
    }
    
    func hideLoading() {
        self.view.viewWithTag(999)?.removeFromSuperview()
    }
    
    func createChatroom(boardId: Int) {
        let service = WalktalkService()
        Task {
            do {
                _ = try await service.createChatroom(boardId: boardId)
                self.navigationController?.popToRootViewController(animated: true)
                self.tabBarController?.selectedIndex = 2
            } catch let error as NetworkError {
                CustomAlertViewController.CustomAlertBuilder(viewController: self)
                    .setButtonState(.singleButton)
                    .setTitleState(.useTitleAndSubTitle)
                    .setSingleButtonTitle("돌아가기")
                    .setTitleText("채팅방 생성 실패")
                    .setSubTitleText(error.message)
                    .showAlertView()
            } catch {
                // 기타 알 수 없는 오류 처리
                CustomAlertViewController.CustomAlertBuilder(viewController: self)
                    .setButtonState(.singleButton)
                    .setTitleState(.useTitleAndSubTitle)
                    .setSingleButtonTitle("돌아가기")
                    .setTitleText("오류 발생")
                    .setSubTitleText("알 수 없는 오류가 발생했습니다.\n다시 시도해주세요.")
                    .showAlertView()
            }
        }
    }

}
