//
//  SignupProfileImageViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/8/25.
//

import UIKit

final class SignupProfileImageViewController: UIViewController {
    
    private let signupProfileImageView = SignupProfileImageView()
    private let service = AuthService()
    private let memberService = MemberService()
    private var signupData: SignupRequest!
    private var addressData: PostAddressRequest!
    
    init(signupData: SignupRequest, addressData: PostAddressRequest) {
        super.init(nibName: nil, bundle: nil)
        self.signupData = signupData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setConstraints()
        addCustomNavigationBar(titleText: "가입하기", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: false)
        addProgressBar(currentStep: 5, totalSteps: 7)
        signupProfileImageView.delegate = self
    }
    
    private func addSubview() {
        view.addSubview(signupProfileImageView)
    }
    
    private func setConstraints() {
        signupProfileImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(156)
            make.bottom.equalToSuperview()
        }
    }

}

extension SignupProfileImageViewController: SignupProfileImageViewDelegate {
    func didTapNextButton(with image: UIImage) {
        signupData.profile = image
        showLoading()
        defer { hideLoading() }

        Task {
            do {
                print("회원가입 요청 시작: \(String(describing: signupData))")
                let signupResponse = try await service.signup(request: signupData)
                print("회원가입 성공: \(signupResponse)")

                print("로그인 요청 시작:\(signupData.email)/\(signupData.password)")
                let loginResponse = try await service.login(email: signupData.email, password: signupData.password)
                print("로그인 성공: \(loginResponse)")

                print("토큰 저장")
                AuthManager.shared.accessToken = loginResponse.data.accessToken
                AuthManager.shared.refreshToken = loginResponse.data.refreshToken

                print("주소 정보 저장 시작:\(String(describing: self.addressData))")

                let addressResponse = try await memberService.postAddress(request: addressData)
                print("주소 정보 저장 성공: \(addressResponse)")

                // 성공 알림 표시
                CustomAlertViewController.CustomAlertBuilder(viewController: self)
                    .setButtonState(.singleButton)
                    .setTitleState(.useTitleOnly)
                    .setSingleButtonTitle("워크멍 시작하기")
                    .setTitleText("모든 로직 성공")
                    .setSingleButtonAction({
                        let mainTabBarController = MainTabBarController()
                        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                        sceneDelegate?.changeRootViewController(mainTabBarController, animated: true)
                    })
                    .showAlertView()
            } catch let error as NetworkError {
                // 실패 알림 표시
                CustomAlertViewController.CustomAlertBuilder(viewController: self)
                    .setButtonState(.singleButton)
                    .setTitleState(.useTitleAndSubTitle)
                    .setSingleButtonTitle("돌아가기")
                    .setTitleText("회원가입 실패")
                    .setSubTitleText("다시 시도해주세요.")
                    .showAlertView()
            } catch {
                print("알 수 없는 에러 발생: \(error.localizedDescription)")
                CustomAlertViewController.CustomAlertBuilder(viewController: self)
                    .setButtonState(.singleButton)
                    .setTitleState(.useTitleAndSubTitle)
                    .setSingleButtonTitle("돌아가기")
                    .setTitleText("회원가입 실패")
                    .setSubTitleText("다시 시도해주세요.")
                    .showAlertView()
            }
        }
    }
}
