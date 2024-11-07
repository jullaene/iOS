import UIKit
import SnapKit

class MatchingViewController: UIViewController {

    private var matchingFilterView: MatchingFilterView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 바 숨기기
        self.navigationController?.navigationBar.isHidden = true

        // 배경 색상 설정
        self.view.backgroundColor = .white

        // MatchingView 추가
        let matchingView = MatchingView()
        matchingView.filterButtonAction = { [weak self] in
            self?.showMatchingFilterView()
        }
        
        self.view.addSubview(matchingView)

        // MatchingView 오토레이아웃 설정
        matchingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func showMatchingFilterView() {
        guard matchingFilterView == nil else { return } // 이미 뷰가 있다면 추가하지 않음

        let filterView = MatchingFilterView()
        filterView.layer.cornerRadius = 30
        filterView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.view.addSubview(filterView)
        self.matchingFilterView = filterView
        
        // 초기 위치: 화면 아래쪽
        filterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(605)
            make.bottom.equalToSuperview().offset(605) // 화면 아래에 위치
        }
        
        // 레이아웃 강제 업데이트 (초기 상태 적용)
        self.view.layoutIfNeeded()
        
        // 애니메이션으로 스르륵 올라오는 효과
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
            filterView.snp.updateConstraints { make in
                make.bottom.equalToSuperview() // 화면 하단에 위치
            }
            self.view.layoutIfNeeded() // 레이아웃 변경 즉시 반영
        })
    }
    
    private func hideMatchingFilterView() {
        guard let filterView = matchingFilterView else { return }
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn], animations: {
            filterView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(605) // 다시 화면 아래로 내려감
            }
            self.view.layoutIfNeeded()
        }, completion: { _ in
            filterView.removeFromSuperview()
            self.matchingFilterView = nil
        })
    }
}
