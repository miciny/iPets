//
//  weatherViewController.swift
//  XueHealth
//
//  Created by maocaiyuan on 16/1/13.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

var WeatherCityID = "101010100"
let Apikey = "2de399fd666345de8e59b016cd9258eb"
let WeatherUrl = "http://jisutqybmf.market.alicloudapi.com/weather/query"

class WeatherViewController: UIViewController, UIScrollViewDelegate {
    
    var vImg = UIImageView()
    var cityNameLb = UILabel() //城市名
    var nowTmpTextLb = UILabel() //天气状况文字
    var nowTmpLb = UILabel() //现在温度
    var todayWeakLb = UILabel() // 今天星期几
    var maxTmpLb = UILabel() // 今天最高温度
    var minTmpLb = UILabel() // 今天最低温度
    
    var headerView: UIView!
    
    var mainScrollView = UIScrollView()
    
    var hourlyView = UIView() //添加三小时天气的view
    var hourlyScrollView = UIScrollView()
    
    var hourArray = NSMutableArray()
    var dayArray = NSMutableArray()
    var isDay = Bool()
    var countDay = Int()
    var countHour = Int()
    
    var tempResult = "" //现在气温
    var cityName = "" //城市名称
    var PM25 = "" //当前pm2.5
    var windDir = "" //当前风向
    var windSc = "" //当前风力
    var condition = "" //现在天气状况的文字
    var sunrise = "" //今天的日出时间
    var sunset = "" //今天的日落时间
    var tmpMax = "" //最高气温
    var tmpMin = "" //最低气温
    
    var quality = ""
    var affect = ""
    var measure = ""
    
    var netManager: SessionManager? //网络请求的manager
    var jsonResult: AnyObject = "" as AnyObject
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalTransitionStyle = .crossDissolve //进入页面时的动画效果
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        log.info("进入天气页面")
        
        self.setMainViewEle()
        self.setHourlyView()
        self.initNetManager()
        
        self.checkWeatherCache()
        
        self.setupHeaderView()
        setBar()
    }
    
    func checkIsDay(){
        
        guard sunrise != "" else {
            isDay = true
            return
        }
        
        let date = Date()
        
        let srArray = sunrise.components(separatedBy: ":")
        let ssArray = sunset.components(separatedBy: ":")
        
        let timeTmp = DateToToString.dateToStringBySelf(date, format: "HH:mm")
        let timeTmpArray = timeTmp.components(separatedBy: ":")

        
        if ((Int(srArray[0]))! < (Int(timeTmpArray[0]))! && (Int(ssArray[0]))! > (Int(timeTmpArray[0]))!) {
            isDay = true
        }else if((Int(srArray[0]))! == (Int(timeTmpArray[0]))! && (Int(ssArray[0]))! > (Int(timeTmpArray[0]))!){
            if((Int(srArray[1]))! < (Int(timeTmpArray[1]))!){
                isDay = true
            }else{
                isDay = false
            }
        }else if((Int(srArray[0]))! < (Int(timeTmpArray[0]))! && (Int(ssArray[0]))! == (Int(timeTmpArray[0]))!){
            if((Int(ssArray[1]))! > (Int(timeTmpArray[1]))!){
                isDay = true
            }else{
                isDay = false
            }
        }else{
            isDay = false
        }
    }
    
    //  headerView
    func setupHeaderView() {
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 64))
        headerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(headerView)
        
        let centerY = headerView.center.y + 5
        let defaultWidth: CGFloat = 40
        
        //  返回、摄像头调整、时间、闪光灯四个按钮
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        backButton.setBackgroundImage(UIImage(named: "iw_back"), for: UIControlState())
        backButton.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        backButton.center = CGPoint(x: 25, y: centerY+5)
        headerView.addSubview(backButton)
        
        let changeButton = UIButton(frame: CGRect(x: 0, y: 0, width: defaultWidth, height: defaultWidth * 68 / 90))
        changeButton.setBackgroundImage(UIImage(named: "iw_cameraSide"), for: UIControlState())
        changeButton.center = CGPoint(x: Width-50, y: centerY+5)
        changeButton.addTarget(self, action: #selector(self.addressClicked), for: .touchUpInside)
        headerView.addSubview(changeButton)
        
    }
    
    //初始化网络请求的manager
    func initNetManager(){
        netManager = NetFuncs.getDefaultAlamofireManager()
    }
    
    //顶部栏透明
    func setBar(){
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.view.backgroundColor = UIColor.white
    }
    
    //隐藏导航栏
    func hideNavBar(isHide : Bool) {
        self.navigationController?.navigationBar.isHidden = isHide
    }
    
    
    func setBackImg(){
        
        var img = UIImage()
        if(isDay){
            img = UIImage(named:"day.jpeg")!    //初始化图片
        }else{
            img = UIImage(named:"night.jpeg")!    //初始化图片
        }
        vImg.image = img
    }
    
    func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func getLB(textColor: UIColor, backColor: UIColor, textAlignment: NSTextAlignment, font: CGFloat) -> UILabel{
        let lb = UILabel()
        lb.textColor = textColor
        lb.backgroundColor = backColor
        lb.textAlignment = textAlignment
        lb.font = UIFont.systemFont(ofSize: font)
        return lb
    }
    
    
//==================================主View======================================
    func setMainViewEle(){
        log.info("设置天气主界面")
        
        vImg = UIImageView()   //初始化图片View
        vImg.frame = CGRect(x: 0, y: 0, width: Width, height: Height)   //指定图片的位置以及显示的大小
        self.view.addSubview(vImg)
        
        mainScrollView.frame = CGRect(x: 0, y: 0, width: Width, height: Height)
        mainScrollView.backgroundColor = UIColor.clear
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.delegate = self
        mainScrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(mainScrollView)
        
        cityNameLb = UILabel(frame: CGRect(x: 50, y: 100, width: Width-100, height: 44))
        cityNameLb.textColor = UIColor.white
        cityNameLb.textAlignment = NSTextAlignment.center
        cityNameLb.font = UIFont.systemFont(ofSize: 35)
        cityNameLb.text = "- -"
        self.view.addSubview(cityNameLb)
        
        nowTmpTextLb = UILabel(frame: CGRect(x: 50, y: 144, width: Width-100, height: 30))
        nowTmpTextLb.textColor = UIColor.white
        nowTmpTextLb.textAlignment = NSTextAlignment.center
        nowTmpTextLb.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(nowTmpTextLb)
        
        nowTmpLb = UILabel(frame: CGRect(x: 50, y: 180, width: Width-100, height: 100))
        nowTmpLb.textColor = UIColor.white
        nowTmpLb.textAlignment = NSTextAlignment.center
        nowTmpLb.font = UIFont.systemFont(ofSize: 100)
        self.view.addSubview(nowTmpLb)
    
    }
    

//==================================小时 View======================================
    func setHourlyView(){
        log.info("设置天气小时界面")
        
        hourlyView = UIView(frame: CGRect(x: 0, y: 303.5, width: Width, height: CGFloat(127)))
        hourlyView.backgroundColor = UIColor.clear
        
        todayWeakLb = getLB(textColor: .white, backColor: .clear, textAlignment: .left, font: 15)
        todayWeakLb.frame = CGRect(x: 20, y: 0, width: 100, height: 20)
        self.hourlyView.addSubview(todayWeakLb)
        
        maxTmpLb = getLB(textColor: .white, backColor: .clear, textAlignment: .right, font: 15)
        maxTmpLb.frame = CGRect(x: Width-80, y: 0, width: 30, height: 20)
        self.hourlyView.addSubview(maxTmpLb)
        
        minTmpLb = getLB(textColor: .white, backColor: .clear, textAlignment: .right, font: 15)
        minTmpLb.frame = CGRect(x: Width-50, y: 0, width: 30, height: 20)
        self.hourlyView.addSubview(minTmpLb)
        
        let line1 = UIView(frame: CGRect(x: 0, y: 20.5, width: Width, height: 0.5))
        line1.backgroundColor = UIColor.white
        self.hourlyView.addSubview(line1)
        
        let line2 = UIView(frame: CGRect(x: 0, y: 125.5, width: Width, height: 0.5))
        line2.backgroundColor = UIColor.white
        self.hourlyView.addSubview(line2)
        
        self.view.addSubview(hourlyView)//保证hourlyScroll后加
        
        hourlyScrollView.frame = CGRect(x: 0, y: 21, width: Width, height: 104)
        hourlyScrollView.backgroundColor = UIColor.clear
        hourlyScrollView.showsVerticalScrollIndicator = false
        hourlyScrollView.showsHorizontalScrollIndicator = false
        hourlyScrollView.contentOffset = CGPoint(x: 0, y: 0)
        self.hourlyView.addSubview(hourlyScrollView)
        
    }
    
//==================================小时View 的 data
    func setHourlyScrollViewData(){
        
        for sub in self.hourlyScrollView.subviews{
            sub.removeFromSuperview()
        }
        
        var hourlyScrollInnerViewWidth = CGFloat()
        if(countHour>6){
            hourlyScrollInnerViewWidth = CGFloat(Float(Width/6) * Float(countHour))
        }else{
            hourlyScrollInnerViewWidth = CGFloat(Float(Width/6) * Float(6))+1
        }
        
        let hourlyScrollInnerView = UIScrollView()
        hourlyScrollInnerView.frame = CGRect(x: 0, y: 0, width: hourlyScrollInnerViewWidth, height: 104)
        hourlyScrollInnerView.backgroundColor = UIColor.clear
        hourlyScrollView.contentSize = hourlyScrollInnerView.bounds.size //重新调整大小
        self.hourlyScrollView.addSubview(hourlyScrollInnerView)
        
        
        for i in 0 ..< countHour{
            
            let hourlyTimeLb = getLB(textColor: .white, backColor: .clear, textAlignment: .center, font: 15)
            hourlyTimeLb.frame = CGRect(x: CGFloat(Int(Width/6) * (i)), y: 0, width: Width/6, height: 104/3)
            hourlyScrollInnerView.addSubview(hourlyTimeLb)
            
            let hourlyCondImage = UIImageView()
            hourlyCondImage.frame.size = CGSize(width: 28, height: 28)
            hourlyCondImage.center.x = hourlyTimeLb.centerXX
            hourlyCondImage.frame.origin.y = 104/3
            hourlyScrollInnerView.addSubview(hourlyCondImage)
            
            let hourlyTempLb = getLB(textColor: .white, backColor: .clear, textAlignment: .center, font: 15)
            hourlyTempLb.frame = CGRect(x: CGFloat(Int(Width/6) * (i)), y: 104/3*2, width: Width/6, height: 104/3)
            hourlyScrollInnerView.addSubview(hourlyTempLb)
            
            hourlyTimeLb.text = (hourArray[i] as! NSArray)[0] as? String
            hourlyCondImage.image = UIImage(named: (hourArray[i] as! NSArray)[1] as! String)
            hourlyTempLb.text = (hourArray[i] as! NSArray)[2] as? String
        }
        
    }
    
//==================================日 View======================================
    
    func setDailyView(){
        
        for sub in self.mainScrollView.subviews{
            sub.removeFromSuperview()
        }
        let maxY = CGFloat(430.5)
        
        let srLb = UILabel(frame: CGRect(x: Width/2, y: maxY+CGFloat((countDay+1)*25), width: Width/2, height: 30))
        srLb.textColor = UIColor.white
        srLb.textAlignment = NSTextAlignment.left
        srLb.font = UIFont.systemFont(ofSize: 17)
        self.mainScrollView.addSubview(srLb)
        
        let ssLb = UILabel(frame: CGRect(x: Width/2, y: maxY+CGFloat((countDay+1)*25)+30, width: Width/2, height: 30))
        ssLb.textColor = UIColor.white
        ssLb.textAlignment = NSTextAlignment.left
        ssLb.font = UIFont.systemFont(ofSize: 17)
        self.mainScrollView.addSubview(ssLb)
        
        let windLb = UILabel(frame: CGRect(x: Width/2, y: maxY+CGFloat((countDay+1)*25)+60, width: Width/2, height: 30))
        windLb.textColor = UIColor.white
        windLb.textAlignment = NSTextAlignment.left
        windLb.font = UIFont.systemFont(ofSize: 17)
        self.mainScrollView.addSubview(windLb)
        
        let pm25Lb = UILabel(frame: CGRect(x: Width/2, y: maxY+CGFloat((countDay+1)*25)+90, width: Width/2, height: 30))
        pm25Lb.textColor = UIColor.white
        pm25Lb.textAlignment = NSTextAlignment.left
        pm25Lb.font = UIFont.systemFont(ofSize: 17)
        self.mainScrollView.addSubview(pm25Lb)
        
        let srLb1 = UILabel(frame: CGRect(x: 0, y: maxY+CGFloat((countDay+1)*25), width: Width/2-10, height: 30))
        srLb1.textColor = UIColor.white
        srLb1.textAlignment = NSTextAlignment.right
        srLb1.font = UIFont.systemFont(ofSize: 20)
        self.mainScrollView.addSubview(srLb1)
        
        let ssLb1 = UILabel(frame: CGRect(x: 0, y: maxY+CGFloat((countDay+1)*25)+30, width: Width/2-10, height: 30))
        ssLb1.textColor = UIColor.white
        ssLb1.textAlignment = NSTextAlignment.right
        ssLb1.font = UIFont.systemFont(ofSize: 20)
        self.mainScrollView.addSubview(ssLb1)
        
        let windLb1 = UILabel(frame: CGRect(x: 0, y: maxY+CGFloat((countDay+1)*25)+60, width: Width/2-10, height: 30))
        windLb1.textColor = UIColor.white
        windLb1.textAlignment = NSTextAlignment.right
        windLb1.font = UIFont.systemFont(ofSize: 20)
        self.mainScrollView.addSubview(windLb1)
        
        let pm25Lb1 = UILabel(frame: CGRect(x: 0, y: maxY+CGFloat((countDay+1)*25)+90, width: Width/2-10, height: 30))
        pm25Lb1.textColor = UIColor.white
        pm25Lb1.textAlignment = NSTextAlignment.right
        pm25Lb1.font = UIFont.systemFont(ofSize: 20)
        self.mainScrollView.addSubview(pm25Lb1)
        

        srLb1.text = "日出："
        ssLb1.text = "日落："
        windLb1.text = windDir + "：  "
        pm25Lb1.text = "PM2.5："
        
        srLb.text = sunrise
        ssLb.text = sunset
        
        
        let pollutionView = UIView(frame: CGRect(x: 0, y: maxY+CGFloat((countDay+1)*25)+130, width: Width, height: 300))
        pollutionView.frame.origin = CGPoint(x: 0, y: maxY+CGFloat((countDay+1)*25)+130)
        
        let line1 = UIView(frame: CGRect(x: 0, y: 1, width: Width, height: 0.5))
        line1.backgroundColor = UIColor.white
        pollutionView.addSubview(line1)
        
        let p1 = getPollutionLb(str: quality)
        p1.center.x = pollutionView.width/2
        p1.frame.origin.y = 9
        pollutionView.addSubview(p1)
        
        let p2 = getPollutionLb(str: affect)
        p2.center.x = pollutionView.width/2
        p2.frame.origin.y = p1.maxYY+15
        pollutionView.addSubview(p2)
        
        let p3 = getPollutionLb(str: measure)
        p3.center.x = pollutionView.width/2
        p3.frame.origin.y = p2.maxYY+15
        pollutionView.addSubview(p3)
        
        let line2 = UIView(frame: CGRect(x: 0, y: p3.maxYY+8, width: Width, height: 0.5))
        line2.backgroundColor = UIColor.white
        pollutionView.addSubview(line2)
        
        pollutionView.frame.size = CGSize(width: Width, height: line2.maxYY+1)
        self.mainScrollView.addSubview(pollutionView)
        mainScrollView.contentSize = CGSize(width: 0, height: pollutionView.maxYY+10)
        
        windLb.text = windSc
        pm25Lb.text = PM25
    }
    
    func getPollutionLb(str: String) -> UILabel{
        let p1Size = sizeWithText(str, font: UIFont.systemFont(ofSize: 16), maxSize: CGSize(width: Width-20, height: Height))
        let p1 = UILabel()
        p1.frame.size = p1Size
        p1.textColor = UIColor.white
        p1.font = UIFont.systemFont(ofSize: 16)
        p1.text = str
        p1.numberOfLines = 0
        
        return p1
    }
    
//==================================日View 的 data
    
    func setDailyScrollViewData(){
        let maxY = CGFloat(430.5)
        
        for i in 0 ..< countDay{
            
            let nextDayLb = UILabel(frame: CGRect(x: 20, y: maxY+CGFloat(i*25), width: 100, height: 25))
            nextDayLb.textColor = UIColor.white
            nextDayLb.textAlignment = NSTextAlignment.left
            nextDayLb.font = UIFont.systemFont(ofSize: 18)
            self.mainScrollView.addSubview(nextDayLb)
            
            let nextDayConditionImage = UIImageView(frame: CGRect(x: self.mainScrollView.width/2, y: maxY+CGFloat(i*25), width: 20, height: 20))
            self.mainScrollView.addSubview(nextDayConditionImage)
            
            let nextDayMaxTmpLb = UILabel(frame: CGRect(x: Width-80, y: maxY+CGFloat(i*25), width: 30, height: 25))
            nextDayMaxTmpLb.textColor = UIColor.white
            nextDayMaxTmpLb.textAlignment = NSTextAlignment.right
            nextDayMaxTmpLb.font = UIFont.systemFont(ofSize: 15)
            self.mainScrollView.addSubview(nextDayMaxTmpLb)
            
            let nextDayMinTmpLb = UILabel(frame: CGRect(x: Width-50, y: maxY+CGFloat(i*25), width: 30, height: 25))
            nextDayMinTmpLb.textColor = UIColor.white
            nextDayMinTmpLb.textAlignment = NSTextAlignment.right
            nextDayMinTmpLb.font = UIFont.systemFont(ofSize: 15)
            self.mainScrollView.addSubview(nextDayMinTmpLb)
            
            nextDayLb.text = (dayArray[i] as! NSArray)[0] as? String
            nextDayConditionImage.image = UIImage(named: (dayArray[i] as! NSArray)[1] as! String)
            nextDayMaxTmpLb.text = (dayArray[i] as! NSArray)[2] as? String
            nextDayMinTmpLb.text = (dayArray[i] as! NSArray)[3] as? String
        }
        
    }
    
    func addressClicked(){
        self.checkAddressCache()
    }
    
//==================================整个View 的 data
    func setLableData(){
        cityNameLb.text = cityName
        nowTmpTextLb.text = condition
        nowTmpLb.text = "\(tempResult)°"
        todayWeakLb.text = DateToToString.dateToStringBySelf(Date(), format: "EEEE") + "  今天"
        maxTmpLb.text = tmpMax
        minTmpLb.text = tmpMin
    }
    
    
    //数据
    func setData(){
        let json = JSON(self.jsonResult)
        
        tempResult = json["result"]["temp"].stringValue //现在气温
        cityName = json["result"]["city"].stringValue //城市名称
        PM25 = json["result"]["aqi"]["pm2_5"].stringValue //当前pm2.5
        windDir = json["result"]["winddirect"].stringValue //当前风向
        windSc = json["result"]["windpower"].stringValue //当前风力
        
        quality = json["result"]["aqi"]["quality"].stringValue
        affect = json["result"]["aqi"]["aqiinfo"]["affect"].stringValue
        measure = json["result"]["aqi"]["aqiinfo"]["measure"].stringValue
        
        condition = json["result"]["weather"].stringValue //现在天气状况的文字
        tmpMax = json["result"]["temphigh"].stringValue //最高气温
        tmpMin = json["result"]["templow"].stringValue //最低气温
        
        dayArray.removeAllObjects()
        hourArray.removeAllObjects()
        
        let tt = json["result"]["daily"].count
        for i in 0 ..< tt{
            
            if i == 0{
                sunrise = json["result"]["daily"][i]["sunrise"].stringValue //今天的日出时间
                sunset = json["result"]["daily"][i]["sunset"].stringValue //今天的日落时间
            }else{
                let nextDay = json["result"]["daily"][i]["week"].stringValue //第i天日期
                let nextDay1Condition = json["result"]["daily"][i]["day"]["img"].stringValue //第i天白天天气状况
                let nextDay1Max = json["result"]["daily"][i]["day"]["temphigh"].stringValue //第i天最高气温
                let nextDay1Min = json["result"]["daily"][i]["night"]["templow"].stringValue //第i天最低气温
                dayArray.add([nextDay, nextDay1Condition, nextDay1Max, nextDay1Min])
            }
        }
        
        let ttt = json["result"]["hourly"].count
        for i in 0 ..< ttt{
            let hour = json["result"]["hourly"][i]["time"].stringValue //每三小时
            let hour1 = DateToToString.dateToStringBySelf(DateToToString.stringToDate(hour, format: "HH:mm"), format: "HH")
            let conditionCode = json["result"]["hourly"][i]["img"].stringValue //每
            let hour1Tmp = json["result"]["hourly"][i]["temp"].stringValue //每三小时温度
            
            hourArray.add([hour1+"时", conditionCode, hour1Tmp])
        }
        countDay = dayArray.count
        countHour = hourArray.count
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let theNewOffset = scrollView.contentOffset
        let startChangeOffset = CGFloat(435)
        let destinaOffset = CGFloat(Height/3)
        var myNewOffset = CGPoint()
        if(-theNewOffset.y + startChangeOffset > startChangeOffset){
            myNewOffset = CGPoint(x: theNewOffset.x, y: startChangeOffset)
        } else if (-theNewOffset.y  + startChangeOffset < destinaOffset){
            myNewOffset = CGPoint(x: theNewOffset.x, y: destinaOffset)
        } else {
            myNewOffset = CGPoint(x: theNewOffset.x, y: -theNewOffset.y  + startChangeOffset)
        }
        let myAlpha = (startChangeOffset - myNewOffset.y)/(startChangeOffset - destinaOffset)
        
        self.nowTmpLb.alpha = 1-myAlpha*2
        self.todayWeakLb.alpha = 1-myAlpha*3
        self.maxTmpLb.alpha = 1-myAlpha*3
        self.minTmpLb.alpha = 1-myAlpha*3
        self.nowTmpTextLb.alpha = 1 - myAlpha
        
        if(theNewOffset.y > 435-Height/3){
            self.hourlyView.frame = CGRect(x: 0, y: 303.5-435+Height/3, width: Width, height: CGFloat(127))
            self.cityNameLb.frame = CGRect(x: 50, y: 70, width: Width-100, height: 44)
            self.nowTmpTextLb.frame = CGRect(x: 50, y: 114, width: Width-100, height: 30)
        }else{
            self.hourlyView.frame = CGRect(x: 0, y: 303.5-theNewOffset.y, width: Width, height: CGFloat(127))
            self.cityNameLb.frame = CGRect(x: 50, y: 100-30*myAlpha, width: Width-100, height: 44)
            self.nowTmpTextLb.frame = CGRect(x: 50, y: 144-30*myAlpha, width: Width-100, height: 30)
        }
        
    }
    
/*---------------------------天气请求---------------------------*/
    func updateWeatherInfo(){
        
        log.info("请求天气数据")
        
        let wait = WaitView()
        wait.showWait("请求中")
        
        let url = WeatherUrl
        let httpArg = "citycode=" + WeatherCityID
        
        var urlRequest = URLRequest(url: URL(string: url + "?" + httpArg)!)
        urlRequest.httpMethod = "GET"
        urlRequest.httpBody = nil
        urlRequest.addValue("APPCODE "+Apikey, forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        netManager!.request(urlRequest).responseJSON { response in
            switch response.result{
                
            case .success:
                
                if let res = response.response{
                    let code = res.statusCode
                    if code == 200 {
                        log.info("请求天气数据成功")
                        self.jsonResult = response.result.value! as AnyObject
                        
                        log.info(self.jsonResult)
                        
                        if JsonCache.savaJsonToCacheDirAddress(JSON(self.jsonResult), name: WeatherCache){
                            log.info("天气数据保存成功！")
                        }else{
                            log.info("天气数据保存失败！")
                            
                        }
                        
                        self.setData()
                        self.setHourlyScrollViewData()
                        self.setDailyView()
                        self.setDailyScrollViewData()
                        self.setLableData()
                        
                        self.checkIsDay()
                        self.setBackImg()
                        
                    }else{
                        log.info("请求天气数据失败，错误代码：" + String(code))
                        self.nowTmpTextLb.text = "错误代码" + String(code)
                    }
                }else{
                    self.nowTmpTextLb.text = "请求失败"
                }
                
                wait.hideView()
                
            case .failure:
                log.info("请求天气数据失败")
                self.nowTmpTextLb.text = "请求失败"
                log.info(response.result.error ?? "weather error nil")
                
                wait.hideView()
            }
        }
    }

/*---------------------------地址请求---------------------------*/
    
    func updateAddressInfo(){
        
        let wait = WaitView()
        wait.showWait("请求中")
        
        let url = "http://jisutqybmf.market.alicloudapi.com/weather/city"
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "GET"
        urlRequest.httpBody = nil
        urlRequest.addValue("APPCODE "+Apikey, forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        netManager!.request(urlRequest).responseJSON { response in
            
            switch response.result{
            case .success:
                
                if let res = response.response{
                    let code = res.statusCode
                    if code == 200 {
                        
                        let json = JSON(response.result.value! as AnyObject)
                        if JsonCache.savaJsonToCacheDirAddress(json, name: AddressCache){
                            log.info("地址数据保存成功！")
                        }else{
                            log.info("地址数据保存失败！")
                            
                        }
                        let pickerView = AddressPickerView(data: json, target: self)
                        self.view.addSubview(pickerView)
                        
                    }else{
                        ToastView().showToast("请求失败")
                    }
                }else{
                    ToastView().showToast("请求失败")
                }
                
                wait.hideView()
                
            case .failure:
                ToastView().showToast("请求失败")
                log.info(response.result.error ?? "weather error nil")
                
                wait.hideView()
            }
        }
    }

    func checkAddressCache(){
        if let json = JsonCache.loadjsonFromCacheDir(AddressCache){
            
            let wait = WaitView()
            wait.showWait("加载中")
            
            let pickerView = AddressPickerView(data: json, target: self)
            self.view.addSubview(pickerView)
            
            wait.hideView()
        }else{
            self.updateAddressInfo()
        }
    }
    
    func checkWeatherCache(){
        
        log.info("读取天气本地缓存")
        
        if let json = JsonCache.loadjsonFromCacheDir(WeatherCache){
            let addressCode = json["result"]["citycode"].stringValue
            WeatherCityID = addressCode
        }
        self.updateWeatherInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//选择的协议
extension WeatherViewController: AddressPickerViewDelegate{
    func doneClicked() {
        updateWeatherInfo()
    }
}
