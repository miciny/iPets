//
//  MCYPieChartView.swift
//  iPets
//
//  Created by maocaiyuan on 2017/7/4.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

//=====================================================================================================
/**
 MARK: - 自己定义的pei图表的样式
 **/
//=====================================================================================================

import UIKit
import Charts

class MCYPieChartView: UIView {
    
    var pieChart: PieChartView!
    
    let periodsFont = UIFont.systemFont(ofSize: standardFontNo+2) //周期字体
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, title: String, holeText: String) {
        self.init()
        
        self.frame = frame
        
        setUpPieChart(title, holeText: holeText)
    }
    
    func setUpPieChart(_ title: String, holeText: String){
        
        pieChart = PieChartView()
        pieChart.frame.origin = CGPoint(x: 0, y: 0)
        pieChart.frame.size = self.frame.size
        
        pieChart.usePercentValuesEnabled = true  //百分百显示
        pieChart.drawSlicesUnderHoleEnabled = false
        pieChart.holeRadiusPercent = 0.9 //图表中间的半径
        pieChart.transparentCircleRadiusPercent = 0.68
        pieChart.chartDescription?.text = title
        pieChart.setExtraOffsets(left: -10, top: 0, right: -10, bottom: -10)
        pieChart.noDataText = "无数据"
        pieChart.isUserInteractionEnabled = false //不影响cell的交互
        
        pieChart.drawCenterTextEnabled = true
        
        let strs = holeText.components(separatedBy: "\n")
        let length = (strs[0] as NSString).length
        
        let centerText = NSMutableAttributedString(string: holeText)
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 5
        
        centerText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, centerText.length))
        centerText.addAttribute(NSAttributedStringKey.font, value: periodsFont, range: NSMakeRange(0, length))
        
        pieChart.centerAttributedText = centerText
        
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
    }
    
    func setPieChartData(_ titles: [String], values: [Double]){
        var yVals = [ChartDataEntry]()
        var xVals = [String]()
        let count = titles.count
        for i in 0 ..< count{
            yVals.append(ChartDataEntry(x: Double(i), y: values[i]))
        }
        
        for i in 0 ..< count{
            xVals.append(titles[i])
        }
        
        let dataSet = PieChartDataSet(values: yVals, label: nil)
        dataSet.sliceSpace = 0 //每个弧度的间隔
        var colors = [UIColor]()
        colors.append(UIColor.green)
        colors.append(UIColor.red)
        colors.append(UIColor.yellow)
        dataSet.colors = colors
        
        let data = PieChartData(dataSet: dataSet)
        data.setDrawValues(false) //不显示每个弧度的values
        
        pieChart.data = data
        pieChart.highlightValues(nil)
    }
}
