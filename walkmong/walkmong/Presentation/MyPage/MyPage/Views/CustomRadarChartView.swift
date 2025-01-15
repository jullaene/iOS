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

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        radarChartView.renderer = CustomRadarChartRenderer(
            chart: radarChartView,
            animator: radarChartView.chartAnimator,
            viewPortHandler: radarChartView.viewPortHandler
        )

        configureAxes()
    }

    private func configureAxes() {
        let yAxis = radarChartView.yAxis
        yAxis.axisMaximum = Double(maxScore)
        yAxis.axisMinimum = 0.0
        yAxis.drawLabelsEnabled = false

        let xAxis = radarChartView.xAxis
        xAxis.drawLabelsEnabled = false

        radarChartView.webLineWidth = 0.5
        radarChartView.innerWebLineWidth = 0.5
        radarChartView.webColor = UIColor(hexCode: "EEF9FF", alpha: 0.4)
        radarChartView.innerWebColor = UIColor(hexCode: "EEF9FF", alpha: 0.4)
    }

    // MARK: - Public Methods
    func updateScores(_ scores: [CGFloat]) {
        guard scores.count == titles.count else {
            radarChartView.data = nil
            return
        }

        self.scores = scores
        updateChart()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCustomLabelPositions()
    }

    // MARK: - Private Methods
    private func updateChart() {
        let normalizedScores = scores.map { min(max($0, 0), maxScore) }
        let entries = normalizedScores.map { RadarChartDataEntry(value: Double($0)) }

        guard !entries.isEmpty else {
            radarChartView.data = nil
            return
        }

        let dataSet = createDataSet(entries: entries)
        radarChartView.data = RadarChartData(dataSet: dataSet)
        updateCustomLabels()
    }

    private func createDataSet(entries: [RadarChartDataEntry]) -> RadarChartDataSet {
        let dataSet = RadarChartDataSet(entries: entries, label: "")
        dataSet.colors = [.mainBlue]
        dataSet.fillColor = .mainBlue
        dataSet.drawFilledEnabled = true
        dataSet.fillAlpha = 1.0
        dataSet.lineWidth = 0
        dataSet.valueTextColor = .clear
        return dataSet
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
        let maxDistance: CGFloat = 86.0
        let datasetOffset: CGFloat = -10.0
        let baseRadius = chartRadius - maxDistance + datasetOffset

        for (index, label) in customLabels.enumerated() {
            guard index < scores.count else { continue }

            let angle = CGFloat(index) * (2 * .pi / CGFloat(titles.count)) - .pi / 2
            let labelCenterX = chartCenter.x + (baseRadius + maxDistance) * cos(angle)
            let labelCenterY = chartCenter.y + (baseRadius + maxDistance) * sin(angle)
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
}

class CustomRadarChartRenderer: RadarChartRenderer {
    override func drawData(context: CGContext) {
        super.drawData(context: context)
    }

    override func drawWeb(context: CGContext) {
        super.drawWeb(context: context)
    }
}
