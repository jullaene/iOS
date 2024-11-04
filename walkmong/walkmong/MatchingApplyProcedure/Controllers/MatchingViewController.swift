import UIKit
import SnapKit

class MatchingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 바 숨기기
        self.navigationController?.navigationBar.isHidden = true

        // 배경 색상 설정
        self.view.backgroundColor = .white

        // MatchingView 추가
        let matchingView = MatchingView()
        self.view.addSubview(matchingView)

        // MatchingView 오토레이아웃 설정
        matchingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
