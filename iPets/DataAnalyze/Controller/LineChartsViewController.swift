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
    fileprivate var monthPreLine: MCYLineChartView! //月预计支出表
    fileprivate var dayCostLine: MCYLineChartView! //日支出表
    
    fileprivate var scrollView: UIScrollView!
    fileprivate var refreshView: MCYRefreshView? //自己写的
    
    let waitView = WaitView()
    
    //五项数据源
    var months = NSArray()
    var monthsCost = NSArray()
    var monthsPreCost = NSArray()
    var days = [String]()
    var daysCost = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScroll()
        addDayCostLine()
        addMonthCostLine()
        addMonthPreLine()
        
        calculateData()
        
    }
    
    func calculateData(){
        if days.count == 0 {
            wiatView.showWait("计算中...")
        }
        
        let LinePageQueue: DispatchQueue = DispatchQueue(label: "LinePageQueue", attributes: [])
        LinePageQueue.async(execute: {
            self.getData()
            
            let thisYearCreditPayTotal = GetAnalyseData.getCreditThisYearTotalPay()
            let thisYearCashPayTotal = GetAnalyseData.getThisYearPayTotal()
            let thisYearPayTotal = thisYearCashPayTotal + thisYearCreditPayTotal
            let thisMonthPayTotal = GetAnalyseData.getThisMonthUse()
            
            mainQueue.async(execute: {
                self.monthCostLine.lineChart.descriptionText = "月现金支出(\(thisYearCashPayTotal))"
                self.monthPreLine.lineChart.descriptionText = "预计月支出(\(thisYearPayTotal))"
                self.dayCostLine.lineChart.descriptionText = "日现金支出(\(thisMonthPayTotal))"
                
                self.setData()
                
                self.wiatView.hideView()
                self.endFresh()
            })
        })
    }
    
    //初始化数据
    func getData(){
        months = ["1","2","3","4","5","6","7","8","9","10","11","12"]
        days = []
        for i in 0 ..< getTime().currentDay {
            days.append("\(i+1)")
        }
        
        monthsCost = GetAnalyseData.getEveryMonthPay() as NSArray
        monthsPreCost = GetAnalyseData.getPreEveryMonthPay() as NSArray
        daysCost = GetAnalyseData.getEveryDayPay() as NSArray
    }
    
    //设置显示数据
    func setData(){
        self.monthCostLine.setLineChartData(self.months, ydata: self.monthsCost)
        self.monthPreLine.setLineChartData(self.months, ydata: self.monthsPreCost)
        self.dayCostLine.setLineChartData(self.days, ydata: self.daysCost)
        
        self.monthCostLine.setNeedsDisplay()
        self.monthPreLine.setNeedsDisplay()
        self.dayCostLine.setNeedsDisplay()
    }
    
    // 设置整个scrollView
    func setScroll(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: Width, height: Height-100-60))
        scrollView.backgroundColor = UIColor.white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        refreshView =  RefreshHeaderView(frame: scrollView.frame, subView: scrollView, target: self)  //添加下拉刷新
    }
    
    //设置第一个表格
    func addDayCostLine(){
        dayCostLine = MCYLineChartView()
        let viewFrame = CGRect(x: 5, y: 0, width: Width-10, height: Width/2)
        dayCostLine = MCYLineChartView(frame: viewFrame, title: "日现金支出", scaleEnabled: false)
        dayCostLine.frame = CGRect(x: 0, y: 5, width: Width, height: Width/2)
        dayCostLine.visibleXRangeMaximum = CGFloat(getTime().currentDay)
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
        monthPreLine = MCYLineChartView()
        let viewFrame = CGRect(x: 5, y: 0, width: Width-10, height: Width/2)
        monthPreLine = MCYLineChartView(frame: viewFrame, title: "预计月支出", scaleEnabled: false)
        monthPreLine.frame = CGRect(x: 0, y: monthCostLine.frame.maxY+20, width: Width, height: Width/2)
        scrollView.addSubview(monthPreLine)
        
        scrollView.contentSize = CGSize(width: Width, height: monthPreLine.frame.maxY+20)
    }
    
    //结束刷新时调用
    func endFresh(){
        self.scrollView.isScrollEnabled = true
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        self.refreshView?.endRefresh()
        let toast = MyToastView()
        toast.showToast("刷新完成！")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LineChartsViewController: MCYRefreshViewDelegate{
    
    func reFreshing(){
        
        self.calculateData()
        
        //这里做你想做的事
        let _ = delay(0.5){
            self.refreshView?.endRefresh()
            ToastView().showToast("刷新完成！")
        }
    }
}
