//
//  sss.swift
//  iPets
//
//  Created by maocaiyuan on 2017/7/4.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit
import MCYRefresher

class LineChartsViewController: UIViewController {
    
    fileprivate var monthCostLine: MCYLineChartView!  //月支出表
    fileprivate var dayCostLine: MCYLineChartView! //日支出表
    
    fileprivate var yearCostPie: MCYPiePolyLineChartView!  //支出百分比
    
    fileprivate var scrollView: UIScrollView!
    fileprivate var refreshView: MCYRefreshView? //自己写的
    
    let waitView = WaitView()
    
    //line项数据源
    var months = [Double]()
    var monthsCost = [Double]()
    var days = [Double]()
    var daysCost = [Double]()
    
    //pie
    var dataDic = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setEle()
        setScroll()
        addDayCostLine()
        addMonthCostLine()
        addMonthPreLine()
        self.addFourthChart()
        calculateData()
        
    }
    
    func setEle(){
        self.title = "数据分析"
    }
    
    func calculateData(){
        if days.count == 0 {
            waitView.showWait("计算中...")
        }
        
        let LinePageQueue: DispatchQueue = DispatchQueue(label: "LinePageQueue", attributes: [])
        LinePageQueue.async(execute: {
            self.getData()
            
            mainQueue.async(execute: {
                self.setData()
                self.waitView.hideView()
                self.endFresh()
            })
        })
    }
    
    //初始化数据
    func getData(){
        months = [1,2,3,4,5,6,7,8,9,10,11,12]
        days = [1,2,3,4,5,6,7,8,9,10,11,12]
        monthsCost = [11,12,13,14,15,16,17,18,19,10,11,12]
        daysCost = [11,12,13,14,15,16,17,18,19,10,11,12]
        
        for i in 5 ..< 8{
            dataDic.setValue(Double(i), forKey: "指出"+String(i))
        }
    }
    
    //设置显示数据
    func setData(){
        self.monthCostLine.setLineChartData(self.months, ydata: self.monthsCost)
        self.dayCostLine.setLineChartData(self.days, ydata: self.daysCost)
        self.monthCostLine.setNeedsDisplay()
        self.dayCostLine.setNeedsDisplay()
        
        self.yearCostPie.setPieChartData(dataDic, holeText: "年度花费")
        self.yearCostPie.setNeedsDisplay()
    }
    
    // 设置整个scrollView
    func setScroll(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: Width, height: Height))
        scrollView.backgroundColor = UIColor.white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        refreshView = MCYRefreshView(subView: scrollView, target: self, imageName: "tableview_pull_refresh")  //添加下拉刷新
    }
    
    //设置第一个表格
    func addDayCostLine(){
        dayCostLine = MCYLineChartView()
        let viewFrame = CGRect(x: 5, y: 0, width: Width-10, height: Width/2)
        dayCostLine = MCYLineChartView(frame: viewFrame, title: "日现金支出", scaleEnabled: false)
        dayCostLine.frame = CGRect(x: 0, y: 5, width: Width, height: Width/2)
        dayCostLine.visibleXRangeMaximum = CGFloat(Date().currentDay)  //能看到的最大
        scrollView.addSubview(dayCostLine)
    }
    
    //设置第二个表格
    func addMonthCostLine(){
        let viewFrame = CGRect(x: 5, y: 0, width: Width-10, height: Width/2)
        monthCostLine = MCYLineChartView(frame: viewFrame, title: "月现金支出", scaleEnabled: false)
        monthCostLine.frame = CGRect(x: 0, y: dayCostLine.frame.maxY+20, width: Width, height: Width/2)
        scrollView.addSubview(monthCostLine)
    }
    
    //设置第三个表格
    func addMonthPreLine(){
        
        let viewFrame = CGRect(x: 0, y: 0, width: Width, height: Width*2/3)
        yearCostPie = MCYPiePolyLineChartView(frame: viewFrame, title: "今年花费比例")
        yearCostPie.frame = CGRect(x: 0, y: monthCostLine.frame.maxY+20, width: Width, height: Width*2/3)
        self.scrollView.addSubview(yearCostPie)
    }
    
    func addFourthChart(){
        let pieView = UIView(frame: CGRect(x: 0, y: yearCostPie.frame.maxY+20, width: Width, height: 100))
        
        let titles = ["", ""]
        let values: [Double] = [4, 6]
        let viewFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let pie = MCYPieChartView(frame: viewFrame, title: "", holeText: "2\n6")
        pie.setPieChartData(titles, values: values)
        pie.center = CGPoint(x: pieView.frame.width/2, y: pieView.frame.height/2)
        
        pieView.addSubview(pie)
        self.scrollView.addSubview(pieView)
        scrollView.contentSize = CGSize(width: Width, height: pieView.frame.maxY+30)
    }
    
    //结束刷新时调用
    func endFresh(){
        self.refreshView?.endRefresh()
        ToastView().showToast("刷新完成！")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LineChartsViewController: MCYRefreshViewDelegate{
    
    func reFreshing(){
        self.calculateData()
    }
}
