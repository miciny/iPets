//
//  sss.swift
//  iPets
//
//  Created by maocaiyuan on 2017/7/4.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//
//=====================================================================================================
/**
 MARK: - 自己定义的line图表的样式
 **/
//=====================================================================================================

import UIKit
import Charts

class MCYLineChartView: UIView {
    
    var lineChart: LineChartView!
    var delegate: ChartViewDelegate?
    var visibleXRangeMaximum = CGFloat(12) //设置的最大显示x
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, title: String, scaleEnabled: Bool) {
        self.init()
        setUpLineChart(frame, title: title, scaleEnabled: scaleEnabled)
    }
    
    func setUpLineChart(_ frame: CGRect, title: String, scaleEnabled: Bool){
        lineChart = LineChartView()
        lineChart.frame = frame
        lineChart.backgroundColor = UIColor(red: 255/255, green: 127/255, blue: 80/255, alpha: 1)
        
        lineChart.chartDescription?.text = title
        lineChart.chartDescription?.textColor = UIColor.white
        lineChart.noDataText = "无数据"
        lineChart.dragEnabled = false //不允许拖动
        lineChart.chartDescription?.font = UIFont.systemFont(ofSize: 20)
        lineChart.chartDescription?.position = CGPoint(x: lineChart.frame.width-20, y: 0)
        lineChart.layer.masksToBounds = true
        lineChart.layer.cornerRadius = 5
        lineChart.setScaleEnabled(scaleEnabled) //是否可放大
        lineChart.drawGridBackgroundEnabled = false //是否显示网格
        lineChart.pinchZoomEnabled = false //是否可放大
        lineChart.autoScaleMinMaxEnabled = false
        lineChart.delegate = delegate
        
        //图例
        let legend = lineChart.legend
        legend.enabled = false
        
        //X数据线
        let theXAxis = lineChart.xAxis
        theXAxis.labelTextColor = UIColor.white
        theXAxis.labelPosition = XAxis.LabelPosition.bottom //x轴位置
        theXAxis.drawGridLinesEnabled = false
        theXAxis.drawAxisLineEnabled = false
        
        //左侧数据线
        let leftAxis = lineChart.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.drawAxisLineEnabled = true
        leftAxis.labelTextColor = UIColor.white
        leftAxis.enabled = true
        
        lineChart.rightAxis.enabled = false
        lineChart.viewPortHandler.setMaximumScaleY(1.0)
        
        //用于点击之后显示数据
        let marker = BalloonMarker(color: UIColor.clear, font:UIFont.systemFont(ofSize: 12.0), insets:UIEdgeInsetsMake(20.0, 8.0, 8.0, 8.0))
        marker.minimumSize = CGSize(width: 80, height: 40)
        lineChart.marker = marker
        
        //        monthCostLine.legend.form = ChartLegend.ChartLegendForm.Line
        lineChart.animate(xAxisDuration: 2.0, easingOption: ChartEasingOption.easeInOutCubic)
        self.addSubview(lineChart)
    }
    
    func setLineChartData(_ xdata: [Double], ydata: [Double]){
        let count = xdata.count
        var yVals = [ChartDataEntry]()
        var index = 0  // 添加Y数据时的位置
        
        for i in 0 ..< count{
            yVals.append(ChartDataEntry(x: xdata[i], y: ydata[i]))
            index += 1
        }
        
        let set1 = LineChartDataSet(values: yVals, label: nil)
        set1.lineDashLengths = [5, 0] // 线条格式
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(UIColor.white)
        set1.setCircleColor(UIColor.white)
        set1.circleHoleColor = UIColor(red: 255/255, green: 127/255, blue: 80/255, alpha: 1)
        set1.lineWidth = 1.0
        set1.circleRadius = 3.0
        set1.drawCircleHoleEnabled = true
        set1.drawValuesEnabled = false
        set1.valueFont = UIFont.systemFont(ofSize: 9)
        set1.drawFilledEnabled = true
        set1.fillAlpha = 30/255.0
        set1.fillColor = UIColor.white
        
        var dataSets = [ChartDataSet]()
        dataSets.append(set1)
        
        lineChart.data = LineChartData(dataSets: dataSets)
        lineChart.setVisibleXRangeMaximum(Double(visibleXRangeMaximum))
    }
}
