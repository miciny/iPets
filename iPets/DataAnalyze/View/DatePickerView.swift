//
//  da.swift
//  iPets
//
//  Created by maocaiyuan on 2017/7/5.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

protocol DatePickerViewDelegate{
    
    func doneClicked(_ yyyymm : String)
}


class DatePickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate: DatePickerViewDelegate?
    
    var addressPicker = UIPickerView()
    var arrayYear = NSMutableArray()
    var arrayMonth = NSArray()
    var selectedDateString = String()
    
    var buttonYear = Int()  //日历显示的的年份
    var buttonMonth = Int()  //日历显示的的月份
    
    let kFirstComponent = 0
    let kSubComponent = 1
    
    
    init(view: UIView, target: DatePickerViewDelegate){
        super.init(frame: UIScreen.main.bounds)
        self.delegate = target
        view.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setElements(){
        
        let backGroudView = UIView()
        backGroudView.frame = CGRect(x: 0, y: Height-310, width: Width, height: 310)
        backGroudView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        backGroudView.layer.cornerRadius = 10
        self.addSubview(backGroudView)
        
        let cancelButton = UIButton(type:UIButtonType.custom)
        cancelButton.setTitle("取消", for:UIControlState())
        cancelButton.frame = CGRect(x: 5, y: 0, width: 64, height: 44)
        cancelButton.setTitleColor(UIColor(red:13/255.0, green:95/255.0, blue:253/255.0, alpha:1.0), for:UIControlState())
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for:.touchUpInside)
        backGroudView.addSubview(cancelButton)
        
        let titleLable = UILabel()
        titleLable.text = "时间"
        titleLable.frame = CGRect(x: 70, y: 0, width: Width-140, height: 44)
        titleLable.textAlignment = NSTextAlignment.center
        titleLable.font = UIFont.systemFont(ofSize: 20)
        backGroudView.addSubview(titleLable)
        
        let DoneButton = UIButton(type:UIButtonType.custom)
        DoneButton.setTitle("确定", for:UIControlState())
        DoneButton.frame = CGRect(x: Width-69, y: 0, width: 64, height: 44)
        DoneButton.setTitleColor(UIColor(red:13/255.0, green:95/255.0, blue:253/255.0, alpha:1.0), for:UIControlState())
        DoneButton.addTarget(self, action: #selector(DoneButtonClicked), for:.touchUpInside)
        backGroudView.addSubview(DoneButton)
        
        let calendar = Calendar.current
        let localeComp: DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.year ,NSCalendar.Unit.month, NSCalendar.Unit.day], from:Date())
        let year = localeComp.year!  //当前的年份
        let month = localeComp.month!  //当前的月份
        
        for k in 1988-year ..< 0{
            arrayYear.add("\(year+k)年")
        }
        for i in 0 ..< 5 {
            arrayYear.add("\(year+i)年")
        }
        
        arrayMonth = ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]
        addressPicker.frame = CGRect(x: 0, y: 44, width: Width, height: 200)
        addressPicker.delegate = self
        addressPicker.dataSource = self
        backGroudView.addSubview(addressPicker)
        
        self.addressPicker.selectRow(arrayYear.index(of: "\(buttonYear)年"), inComponent:0, animated:true)
        self.addressPicker.selectRow(arrayMonth.index(of: "\(buttonMonth)月"), inComponent:1, animated:true)
        selectedDateString = String(year) + "年" + String(month) + "月"
        
        
        // Do any additional setup after loading the view.
    }
    
    func cancelButtonClicked(){
        self.removeFromSuperview()
    }
    
    //点击处理
    func DoneButtonClicked(){
        self.removeFromSuperview()
        self.delegate?.doneClicked(selectedDateString)
    }
    
    //返回几列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //返回列的行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == kFirstComponent) {
            return arrayYear.count
        }else{
            return arrayMonth.count
        }
    }
    
    //显示的标题
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == kFirstComponent){
            let yearStr = arrayYear.object(at: row)
            return yearStr as? String
        }else{
            let monthStr = arrayMonth.object(at: row)
            return monthStr as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let yearComponent : NSInteger = pickerView.selectedRow(inComponent: kFirstComponent)
        let monthComponent : NSInteger = pickerView.selectedRow(inComponent: kSubComponent)
        let yearString : NSString = arrayYear.object(at: yearComponent) as! NSString
        let monthString : NSString = arrayMonth.object(at: monthComponent) as! NSString
        selectedDateString = "\(yearString)\(monthString)"
    }
}
