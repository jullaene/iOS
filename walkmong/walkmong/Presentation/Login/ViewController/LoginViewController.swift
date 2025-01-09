//
//  LoginViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/9/25.
//

import UIKit

final class LoginViewController: UIViewController {

    private let loginView = LoginView()
    private let service = AuthService()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setConstraints()
        addCustomNavigationBar(titleText: "로그인", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        dismissKeyboardOnTap()
        loginView.delegate = self
    }
    
    private func addSubview() {
        view.addSubview(loginView)
    }
    
    private func setConstraints() {
        loginView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(123)
        }
    }
}

extension LoginViewController: LoginViewDelegate {
    func didTapLoginButton(email: String, password: String, keepLogin: Bool, keepEmail: String?) async {
        showLoading()
        defer { hideLoading() }
        
        do {
            // 로그인 API 호출 및 디코딩
            let response = try await service.login(email: email, password: password)
            
            // 로그인 성공 처리
            handleLoginSuccess(response: response, keepLogin: keepLogin, keepEmail: keepEmail)
        } catch let error as NetworkError {
            // 로그인 관련 오류 처리
            CustomAlertViewController.CustomAlertBuilder(viewController: self)
                .setButtonState(.singleButton)
                .setTitleState(.useTitleAndSubTitle)
                .setSingleButtonTitle("돌아가기")
                .setTitleText("로그인 실패")
                .setSubTitleText("이메일 및 비밀번호를 확인해주세요.")
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
    
    private func handleLoginSuccess(response: RefreshAccessTokenResponse, keepLogin: Bool, keepEmail: String? = nil) {
        if keepLogin {
            AuthManager.shared.accessToken = response.data.accessToken
            AuthManager.shared.refreshToken = response.data.refreshToken
        }
        if let keepEmail = keepEmail {
            UserDefaults.setValue(keepEmail, forKey: "USER_EMAIL")
        }
        let mainTabBarController = MainTabBarController()
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.changeRootViewController(mainTabBarController, animated: true)
    }
    
}
