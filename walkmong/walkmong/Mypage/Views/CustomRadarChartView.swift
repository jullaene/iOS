//
//  CustomRadarChartView.swift
//  walkmong
//
//  Created by 신호연 on 12/12/24.
//

import UIKit
import Charts

class CustomRadarChartView: UIView {
    // MARK: - Properties
    private let radarChartView = RadarChartView()
    private let titles = ["신뢰도", "친절함", "의사소통", "시간준수", "책임감"]
    private let maxScore: CGFloat = 5.0
    private var scores: [CGFloat] = []
    private var customLabels: [UILabel] = []
    private var axisLayer: CAShapeLayer?

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    // MARK: - Configuration
    private func configureView() {
        backgroundColor = .clear
        setupRadarChartView()
    }

    private func setupRadarChartView() {
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
        radarChartView.legend.enabled = false

        let yAxis = radarChartView.yAxis
        yAxis.axisMaximum = Double(maxScore)
        yAxis.axisMinimum = 0.0
        yAxis.drawLabelsEnabled = false

        let xAxis = radarChartView.xAxis
        xAxis.drawLabelsEnabled = false

        radarChartView.webLineWidth = 0.5
        radarChartView.innerWebLineWidth = 0.5
        radarChartView.webColor = .clear
        radarChartView.innerWebColor = .clear
    }

    // MARK: - Public Methods
    func updateScores(_ scores: [CGFloat]) {
        guard scores.count == titles.count else {
            radarChartView.data = nil
            return
        }

        self.scores = scores

        let normalizedScores = scores.map { min(max($0 / maxScore, 0), 1) * maxScore }

        let entries = normalizedScores.map { RadarChartDataEntry(value: Double($0)) }
        let dataSet = RadarChartDataSet(entries: entries, label: "")
        configureDataSet(dataSet)

        radarChartView.data = RadarChartData(dataSet: dataSet)
        updateCustomLabels()
        drawAxisLines()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCustomLabelPositions()
        drawAxisLines()
    }

    // MARK: - Private Methods
    private func configureDataSet(_ dataSet: RadarChartDataSet) {
        dataSet.colors = [.mainBlue]
        dataSet.fillColor = .mainBlue
        dataSet.drawFilledEnabled = true
        dataSet.fillAlpha = 1.0
        dataSet.lineWidth = 0
        dataSet.valueTextColor = .clear
    }

    private func updateCustomLabels() {
        customLabels.forEach { $0.removeFromSuperview() }
        customLabels = titles.map { title in
            let label = UILabel()
            label.textAlignment = .center
            label.numberOfLines = 2
            label.text = title
            addSubview(label)
            return label
        }
        updateCustomLabelPositions()
    }

    private func updateCustomLabelPositions() {
        guard !customLabels.isEmpty else { return }

        let chartCenter = CGPoint(x: radarChartView.bounds.midX, y: radarChartView.bounds.midY)
        let chartRadius = min(radarChartView.bounds.width, radarChartView.bounds.height) / 2.0
        let offset: CGFloat = 10.0

        for (index, label) in customLabels.enumerated() {
            guard index < scores.count else { continue }
            let angle = CGFloat(index) * (2 * .pi / CGFloat(titles.count)) - .pi / 2
            let labelCenterX = chartCenter.x + (chartRadius + offset) * cos(angle)
            let labelCenterY = chartCenter.y + (chartRadius + offset) * sin(angle)
            label.attributedText = makeAttributedText(for: titles[index], score: scores[index])
            label.sizeToFit()
            label.center = CGPoint(x: labelCenterX, y: labelCenterY)
        }
    }

    private func makeAttributedText(for title: String, score: CGFloat) -> NSAttributedString {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Pretendard-Medium", size: 12)!,
            .foregroundColor: UIColor.gray600
        ]
        let scoreAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Pretendard-SemiBold", size: 16)!,
            .foregroundColor: UIColor.mainBlue
        ]

        let attributedText = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        let scoreText = NSAttributedString(string: String(format: "%.1f", score), attributes: scoreAttributes)
        attributedText.append(scoreText)
        return attributedText
    }

    private func drawAxisLines() {
        axisLayer?.removeFromSuperlayer()

        guard radarChartView.data != nil else { return }

        let chartCenter = radarChartView.center
        let chartRadius = min(radarChartView.frame.width, radarChartView.frame.height) / 2.0
        let sliceAngle = 2 * .pi / CGFloat(titles.count)

        let axisPath = UIBezierPath()
        for i in 0..<titles.count {
            let angle = CGFloat(i) * sliceAngle - .pi / 2
            let x = chartCenter.x + chartRadius * cos(angle)
            let y = chartCenter.y + chartRadius * sin(angle)
            axisPath.move(to: chartCenter)
            axisPath.addLine(to: CGPoint(x: x, y: y))
        }

        let axisLayer = createLayer(with: axisPath.cgPath, lineWidth: 0.5, color: UIColor(red: 0.93, green: 0.98, blue: 1, alpha: 0.4).cgColor)
        radarChartView.layer.addSublayer(axisLayer)
        self.axisLayer = axisLayer

        let stepPath = UIBezierPath()
        for step in 1...Int(maxScore) {
            let stepRadius = chartRadius * CGFloat(step) / maxScore
            let polygonPath = createPolygonPath(center: chartCenter, radius: stepRadius, sliceAngle: sliceAngle)
            stepPath.append(polygonPath)
        }

        let stepLayer = createLayer(with: stepPath.cgPath, lineWidth: 0.5, color: UIColor(red: 0.93, green: 0.98, blue: 1, alpha: 0.4).cgColor, isDashed: true)
        radarChartView.layer.addSublayer(stepLayer)
    }

    private func createPolygonPath(center: CGPoint, radius: CGFloat, sliceAngle: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        for i in 0..<titles.count {
            let angle = CGFloat(i) * sliceAngle - .pi / 2
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            i == 0 ? path.move(to: CGPoint(x: x, y: y)) : path.addLine(to: CGPoint(x: x, y: y))
        }
        path.close()
        return path
    }

    private func createLayer(with path: CGPath, lineWidth: CGFloat, color: CGColor, isDashed: Bool = false) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = path
        layer.strokeColor = color
        layer.lineWidth = lineWidth
        layer.fillColor = UIColor.clear.cgColor
        if isDashed {
            layer.lineDashPattern = [2, 2]
        }
        return layer
    }
}
