//
//  CustomRadarChartView.swift
//  walkmong
//
//  Created by 신호연 on 12/12/24.
//

import UIKit
import Charts

class CustomRadarChartView: UIView {
    private let radarChartView = RadarChartView()
    private let titles = ["신뢰도", "친절함", "의사소통", "시간준수", "책임감"] // 고정된 축 이름
    private let maxScore: CGFloat = 5.0 // 만점
    private let maxChartLength: CGFloat = 87.75 // 만점일 때의 길이
    private var scores: [CGFloat] = [] // 점수 저장
    private var customLabels: [UILabel] = [] // 커스텀 라벨 저장

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupChartView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
        setupChartView()
    }

    private func setupChartView() {
        addSubview(radarChartView)
        radarChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            radarChartView.topAnchor.constraint(equalTo: topAnchor),
            radarChartView.bottomAnchor.constraint(equalTo: bottomAnchor),
            radarChartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            radarChartView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        radarChartView.backgroundColor = .clear
        radarChartView.chartDescription.enabled = false
        radarChartView.rotationEnabled = false
        radarChartView.isUserInteractionEnabled = false

        // Y축 값 설정
        radarChartView.yAxis.axisMaximum = Double(maxChartLength)
        radarChartView.yAxis.axisMinimum = 0.0
        radarChartView.yAxis.drawLabelsEnabled = false

        // X축 값 숨김
        radarChartView.xAxis.drawLabelsEnabled = false

        // 범례 제거
        radarChartView.legend.enabled = false

        // 내부 선 제거
        radarChartView.webLineWidth = 0
        radarChartView.innerWebLineWidth = 0
    }

    func updateScores(_ scores: [CGFloat]) {
        guard scores.count == titles.count else {
            print("Error: Scores count must match titles count")
            radarChartView.data = RadarChartData() // 비어 있는 데이터 설정
            return
        }

        // 점수 저장
        self.scores = scores

        // 점수 데이터를 기반으로 RadarChartDataEntry 생성
        let entries = scores.map { score -> RadarChartDataEntry in
            let normalizedValue = (score / maxScore) * maxChartLength
            return RadarChartDataEntry(value: Double(normalizedValue))
        }

        let dataSet = RadarChartDataSet(entries: entries, label: "")
        dataSet.colors = [UIColor.mainBlue]
        dataSet.fillColor = .mainBlue
        dataSet.drawFilledEnabled = true
        dataSet.fillAlpha = 0.7

        // 외곽선 제거
        dataSet.lineWidth = 0

        // 데이터 값 숨김
        dataSet.valueFont = UIFont(name: "Pretendard-Medium", size: 12)!
        dataSet.valueTextColor = .clear // 값 숨김

        // 데이터 적용
        let data = RadarChartData(dataSet: dataSet)
        radarChartView.data = data

        // 기존 라벨 제거
        customLabels.forEach { $0.removeFromSuperview() }
        customLabels = []

        // 새로운 라벨 추가
        addCustomLabels()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCustomLabelPositions()
    }

    private func addCustomLabels() {
        for title in titles {
            let label = UILabel()
            label.textAlignment = .center
            label.numberOfLines = 2
            addSubview(label)
            customLabels.append(label)
        }

        updateCustomLabelPositions()
    }

    private func updateCustomLabelPositions() {
        guard !customLabels.isEmpty else { return }

        let center = radarChartView.center
        let radius = radarChartView.bounds.width / 2.0

        for (index, label) in customLabels.enumerated() {
            guard titles.indices.contains(index), scores.indices.contains(index) else { continue }

            // 각도 계산
            let angle = CGFloat(index) * (2 * .pi / CGFloat(titles.count)) - .pi / 2

            // 라벨 위치 계산
            let labelCenterX = center.x + radius * cos(angle)
            let labelCenterY = center.y + radius * sin(angle)

            // 축 이름 및 점수 설정
            let score = scores[index]
            label.attributedText = makeCustomAttributedString(title: titles[index], score: score)
            label.sizeToFit()

            // 라벨 위치 설정
            label.center = CGPoint(x: labelCenterX, y: labelCenterY)
        }
    }

    private func makeCustomAttributedString(title: String, score: CGFloat) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(
            string: "\(title)\n",
            attributes: [
                .font: UIFont(name: "Pretendard-Medium", size: 12)!,
                .foregroundColor: UIColor.gray600
            ]
        )
        let scoreText = NSAttributedString(
            string: String(format: "%.1f", score),
            attributes: [
                .font: UIFont(name: "Pretendard-SemiBold", size: 16)!,
                .foregroundColor: UIColor.mainBlue
            ]
        )
        attributedText.append(scoreText)
        return attributedText
    }
}

extension CustomRadarChartView: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        // 축 이름 유효성 검사
        guard titles.indices.contains(Int(value)) else { return "" }
        guard scores.indices.contains(Int(value)) else { return "\(titles[Int(value)])\n0.0" }

        // 해당 점수 가져오기
        let score = scores[Int(value)]

        // 반환 문자열 (점수는 MainHighlightParagraphLabel 스타일로 적용)
        return """
        \(titles[Int(value)])
        \(String(format: "%.1f", score))
        """
    }
}
