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
    private let titles = ["신뢰도", "친절함", "의사소통", "시간준수", "책임감"]
    private let maxScore: CGFloat = 5.0
    private let maxChartLength: CGFloat = 86
    private var scores: [CGFloat] = []
    private var customLabels: [UILabel] = []
    private var axisLayer: CAShapeLayer?

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
        radarChartView.yAxis.axisMaximum = Double(maxChartLength)
        radarChartView.yAxis.axisMinimum = 0.0
        radarChartView.yAxis.drawLabelsEnabled = false
        radarChartView.xAxis.drawLabelsEnabled = false
        radarChartView.legend.enabled = false
        radarChartView.webLineWidth = 0.5
        radarChartView.innerWebLineWidth = 0.5
        radarChartView.webColor = .clear // 내부 선 숨김
        radarChartView.innerWebColor = .clear // 내부 선 숨김
    }

    func updateScores(_ scores: [CGFloat]) {
        guard scores.count == titles.count else {
            radarChartView.data = RadarChartData()
            return
        }

        self.scores = scores

        let entries = scores.map { score -> RadarChartDataEntry in
            let normalizedValue = (score / maxScore) * maxChartLength
            return RadarChartDataEntry(value: Double(normalizedValue))
        }

        let dataSet = RadarChartDataSet(entries: entries, label: "")
        dataSet.colors = [UIColor.mainBlue]
        dataSet.fillColor = .mainBlue
        dataSet.drawFilledEnabled = true
        dataSet.fillAlpha = 1.0
        dataSet.lineWidth = 0
        dataSet.valueTextColor = .clear

        radarChartView.data = RadarChartData(dataSet: dataSet)

        customLabels.forEach { $0.removeFromSuperview() }
        customLabels = []
        addCustomLabels()
        drawAxisLines() // 축 선 다시 그리기
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCustomLabelPositions()
        drawAxisLines()
    }

    private func addCustomLabels() {
        for _ in titles {
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
        let offset: CGFloat = 6.0

        for (index, label) in customLabels.enumerated() {
            guard titles.indices.contains(index), scores.indices.contains(index) else { continue }

            let angle = CGFloat(index) * (2 * .pi / CGFloat(titles.count)) - .pi / 2
            let labelCenterX = center.x + (radius + offset) * cos(angle)
            let labelCenterY = center.y + (radius + offset) * sin(angle)

            let score = scores[index]
            label.attributedText = makeCustomAttributedString(title: titles[index], score: score)
            label.sizeToFit()
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

    private func drawAxisLines() {
        axisLayer?.removeFromSuperlayer()

        guard let chartData = radarChartView.data, !chartData.dataSets.isEmpty else { return }

        let chartCenter = radarChartView.centerOffsets // RadarChartView 중심 좌표
        let factor = radarChartView.factor // 데이터 변환 비율
        let rotationAngle = radarChartView.rotationAngle // 차트 회전 각도
        let sliceAngle = 360.0 / Double(titles.count) // 각 데이터 포인트의 각도

        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()

        for i in 0..<titles.count {
            let angle = CGFloat(rotationAngle + Double(i) * sliceAngle).radians // 각도 계산
            let x = chartCenter.x + CGFloat(cos(angle)) * radarChartView.chartYMax * factor
            let y = chartCenter.y + CGFloat(sin(angle)) * radarChartView.chartYMax * factor
            path.move(to: chartCenter)
            path.addLine(to: CGPoint(x: x, y: y))
        }

        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor(red: 0.93, green: 0.98, blue: 1, alpha: 0.4).cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.fillColor = UIColor.clear.cgColor

        radarChartView.layer.addSublayer(shapeLayer)
        axisLayer = shapeLayer
    }
}

extension Double {
    var radians: CGFloat {
        return CGFloat(self * .pi / 180.0)
    }
}

extension CGFloat {
    var radians: CGFloat {
        return self * .pi / 180.0
    }
}
