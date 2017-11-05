//
//  addressPickerView.swift
//  XueHealth
//
//  Created by maocaiyuan on 16/1/26.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol AddressPickerViewDelegate{
    func doneClicked()
}

let AddressCache = "AddressCache"
let WeatherCache = "WeatherCache"

class AddressPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource{

    var delegate: AddressPickerViewDelegate?
    var data: JSON?
    
    var addressPicker = UIPickerView()
    
    var provence = [AddressDataModel]()
    var city = [AddressDataModel]()
    var town = [AddressDataModel]()
    
    var dataModels = [AddressDataModel]()
    
    let kFComponent = 0
    let kSComponent = 1
    let kTComponent = 2
    
    var cityId: String?
    
    init(data: JSON?, target: AddressPickerViewDelegate){
        super.init(frame: UIScreen.main.bounds)
        self.delegate = target
        self.data = data
        
        self.setElements()
        self.setData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setElements(){
        
        let backGroudView = UIView()
        backGroudView.frame = CGRect(x: 0, y: Height-250, width: Width, height: 250)
        backGroudView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        self.addSubview(backGroudView)
        
        let cancelButton = UIButton(type: UIButtonType.custom)
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.frame = CGRect(x: 5, y: 0, width: 64, height: 44)
        cancelButton.setTitleColor(UIColor(red: 13/255.0, green: 95/255.0, blue:253/255.0, alpha: 1.0), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        backGroudView.addSubview(cancelButton)
        
        let titleLable = UILabel()
        titleLable.text = "地址"
        titleLable.frame = CGRect(x: 70, y: 0, width: Width-140, height: 44)
        titleLable.textAlignment = NSTextAlignment.center
        titleLable.font = UIFont.systemFont(ofSize: 20)
        backGroudView.addSubview(titleLable)
        
        let DoneButton = UIButton(type:UIButtonType.custom)
        DoneButton.setTitle("确定", for: .normal)
        DoneButton.frame = CGRect(x: Width-69, y: 0, width: 64, height: 44)
        DoneButton.setTitleColor(UIColor(red:13/255.0, green:95/255.0, blue:253/255.0, alpha:1.0), for: .normal)
        DoneButton.addTarget(self, action:#selector(self.DoneButtonClicked), for: .touchUpInside)
        backGroudView.addSubview(DoneButton)
        
        addressPicker.frame = CGRect(x: 0, y: 44, width: Width, height: 200)
        addressPicker.delegate = self
        addressPicker.dataSource = self
        backGroudView.addSubview(addressPicker)
    }
    
    //处理JSON数据
    func setData(){
        dataModels.removeAll()
        let json = self.data!
        
        let waitView = WaitView()
        waitView.showWait("处理中")
        
        //多线程
        let myQueue = DispatchQueue(label: "myQueue")  //
        myQueue.async {
            
            let count = json["result"].count
            let data = json["result"]
            for i in 0 ..< count{
                let city = data[i]["city"].stringValue
                let cityCode = data[i]["citycode"].stringValue
                let cityID = data[i]["cityid"].stringValue
                let parentID = data[i]["parentid"].stringValue
                
                let dataModel = AddressDataModel(cityCode: cityCode, cityID: cityID, parentID: parentID, cityName: city)
                self.dataModels.append(dataModel)
            }
            
            self.progressProData()
            
            self.progressCityData(cityId: "1")
            self.progressTownData(cityId: "501")
            
            mainQueue.async {
                waitView.hideView()
                
                self.addressPicker.reloadComponent(self.kFComponent)
                self.addressPicker.reloadComponent(self.kTComponent)
                self.addressPicker.reloadComponent(self.kSComponent)
            }
        }
    }
    
    //处理省
    func progressProData(){
        provence.removeAll()
        for data in self.dataModels {
            let parentID = data.parentID
            if parentID == "0"{
                provence.append(data)
            }
        }
    }
    
    //处理市
    func progressCityData(cityId: String){
        city.removeAll()
        
        for data in self.dataModels {
            let parentID = data.parentID
            if parentID == cityId{
                city.append(data)
            }
        }
    }
    
    func progressTownData(cityId: String){
        town.removeAll()
        
        for data in self.dataModels {
            let parentID = data.parentID
            if parentID == cityId{
                town.append(data)
            }
        }
        
        //没有数据
        if town.count == 0{
            let cityParentId = city[0].parentID
            town.removeAll()
            town = city
            for data in provence {
                let parentID = data.cityID
                if parentID == cityParentId{
                    city.removeAll()
                    city.append(data)
                    break  //肯定只有一个
                }
            }
        }
    }
    
    @objc func cancelButtonClicked(){
        self.removeFromSuperview()
    }
    
    @objc func DoneButtonClicked(){
        self.removeFromSuperview()
        WeatherCityID = (cityId == nil ? "101010100" : cityId!)
        self.delegate?.doneClicked()
    }
    
    //返回几列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    //返回列的行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == kFComponent {
            return provence.count
        }else if component == kSComponent {
            return city.count
        }else{
            return town.count
        }
    }
    
    //显示的标题
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == kFComponent {
            return provence[row].cityName
        }else if component == kSComponent {
            return city[row].cityName
        }else {
            return town[row].cityName
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == kFComponent{
            pickerView.selectRow(0, inComponent: kSComponent, animated: false)
            pickerView.selectRow(0, inComponent: kTComponent, animated: false)
            
            let proComponent: NSInteger = pickerView.selectedRow(inComponent: kFComponent)
            let cityComponent: NSInteger = pickerView.selectedRow(inComponent: kSComponent)
            
            self.progressCityData(cityId: provence[proComponent].cityID)
            self.progressTownData(cityId: city[cityComponent].cityID)
            
            self.addressPicker.reloadComponent(self.kSComponent)
            self.addressPicker.reloadComponent(self.kTComponent)
        }
        
        if component == kSComponent{
            pickerView.selectRow(0, inComponent: kTComponent, animated: false)
            let cityComponent: NSInteger = pickerView.selectedRow(inComponent: kSComponent)
            self.progressTownData(cityId: city[cityComponent].cityID)
            
            self.addressPicker.reloadComponent(self.kTComponent)
        }
        
        let townComponent: NSInteger = pickerView.selectedRow(inComponent: kTComponent)
        cityId = town[townComponent].cityCode
    }
}
