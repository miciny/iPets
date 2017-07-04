//
//  sss.swift
//  iPets
//
//  Created by maocaiyuan on 2017/7/4.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

//=====================================================================================================
/**
 MARK: - 自己定义的pie图表的样式
 **/
//=====================================================================================================

import UIKit
import Charts

class MCYPiePolyLineChartView: UIView {
    var pieChart: PieChartView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, title: String) {
        self.init()
        setUpPieChart(frame, title: title)
    }
    
    func setUpPieChart(_ frame: CGRect, title: String){
        pieChart = PieChartView()
        pieChart.frame = frame
        
        pieChart.usePercentValuesEnabled = true  //百分百显示
        pieChart.drawSlicesUnderHoleEnabled = false
        pieChart.holeRadiusPercent = 0.5 //图表中间的半径
        pieChart.transparentCircleRadiusPercent = 0.5
        pieChart.chartDescription?.text = title
        pieChart.setExtraOffsets(left: 5, top: 5, right: 5, bottom: 5)
        pieChart.noDataText = "无数据"
        pieChart.isUserInteractionEnabled = false //不影响cell的交互
        
        pieChart.drawCenterTextEnabled = true
        
        pieChart.drawHoleEnabled = true //允许中间的文字
        pieChart.rotationAngle = 270 //开始的角度
        pieChart.rotationEnabled = true
        pieChart.highlightPerTapEnabled = false //点击之后高亮
        
        let l = pieChart.legend  // 图例，暂时不需要
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.xEntrySpace = 7.0
        l.yEntrySpace = 0.0
        l.yOffset = 0.0
        l.enabled = false //显不显示
        
        self.addSubview(pieChart)
        pieChart.animate(xAxisDuration: 1.4, easingOption: ChartEasingOption.easeOutBack) //动画
    }
    
    func setPieChartData(_ dic: NSMutableDictionary, holeText: String){
        
        let centerText = NSMutableAttributedString(string: holeText)
        pieChart.centerAttributedText = centerText
        
        let titles = dic.allKeys
        let count = titles.count
        
        var yVals = [ChartDataEntry]()
        var xVals = [String]()
        
        for i in 0 ..< count{
            let key = titles[i] as! String
            let value = dic.value(forKey: key) as! Double
            
            yVals.append(ChartDataEntry(x: Double(i), y: value))
            xVals.append(key)
        }
        
        let dataSet = PieChartDataSet(values: yVals, label: nil)
        dataSet.sliceSpace = 0
        
        var colors = [UIColor]()
        colors.append(UIColor.green)
        colors.append(UIColor.orange)
        colors.append(UIColor.yellow)
        colors.append(UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1))
        colors.append(UIColor(red: 255/255, green: 218/255, blue: 185/255, alpha: 1))
        dataSet.colors = colors
        
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.3
        dataSet.valueLinePart2Length = 0.4
        dataSet.yValuePosition = .outsideSlice
        
        let data = PieChartData(dataSet: dataSet)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = "%"
        
        data.setValueFormatter(pFormatter as? IValueFormatter)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size:11))
        data.setValueTextColor(UIColor.black)
        
        pieChart.data = data
        pieChart.highlightValues(nil)
    }
}
