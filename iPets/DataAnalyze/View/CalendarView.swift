//
//  CanlenderView.swift
//  iPets
//
//  Created by maocaiyuan on 2017/7/4.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit



protocol CalendarViewDelegate{
    
    func itemClicked(_ dd: String, yyyymm : String)
}


class CalendarView: UIView{
    
    fileprivate var delegate: CalendarViewDelegate?
    fileprivate var CalendarView = UIView()   //日历view
    fileprivate var TopView = UIView()        //头顶view
    fileprivate var MainView = UIView()       //中间view
    fileprivate var BottomView = UIView()     //底部view
    
    fileprivate var btnleft = UIButton()      //上一月
    fileprivate var btnright = UIButton()   //下一月
    fileprivate var btnyyyymmdd = UIButton()  //年月日
    fileprivate var btnToToday = UIButton()  //回到今天
    
    fileprivate var getOneweek = 0     //获取到年月的1号是周几
    fileprivate var daycount = 0        //获取到年月的总天数
    
    var nowDate = Date()
    var ischeck = false   //是否已经选择过
    
    init(frame: CGRect, target: CalendarViewDelegate){
        super.init(frame: frame)
        self.frame = frame
        self.delegate = target
        self.setUpTable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpTable() {
        CalendarView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        CalendarView.backgroundColor = UIColor.white
        
        TopView.frame = CGRect(x:0, y: 0, width: CalendarView.frame.width, height: 70)
        TopView.backgroundColor = UIColor.white
        CalendarView.addSubview(TopView)
        MainView.frame = CGRect(x:0, y: 70, width: CalendarView.frame.width, height: CalendarView.frame.height-110)
        MainView.backgroundColor = UIColor.white
        CalendarView.addSubview(MainView)
        
        self.addSubview(CalendarView)
        
        initLoadDate()//初始化日期
        AddTop()//添加头部试图信息
        AddMain() //添加日历内容
    }
    
    func initLoadDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //得到年月的1号
        let date = dateFormatter.date(from: "\(nowDate.currentYear)-\(nowDate.currentMonth)-01 23:59:59")
        getOneweek = date!.toMonthOneDayWeek(date!)
        
        daycount = date!.TotaldaysInThisMonth(date!)
        
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(_handleSwipeGesture))
        swipeGestureRight.direction = UISwipeGestureRecognizerDirection.right //滑动的样式
        self.CalendarView.addGestureRecognizer(swipeGestureRight)
        
        let swipeGestureleft = UISwipeGestureRecognizer(target: self, action: #selector(_handleSwipeGesture))
        swipeGestureleft.direction = UISwipeGestureRecognizerDirection.left //滑动的样式
        self.CalendarView.addGestureRecognizer(swipeGestureleft)
        
    }
    
    
    func AddTop(){
        let  _width = (TopView.frame.width*(1+1)-TopView.frame.width) / CGFloat(7) //整个TopView宽度的100% / 7
        for i in 0 ..< 7{
            let lb  = UILabel(frame: CGRect(x: CGFloat(i)*_width, y: TopView.frame.height-30, width: _width, height: 30))
            lb.textColor=UIColor.black
            var str=""
            switch(i){
            case 0: str="周日";lb.textColor=UIColor.gray;break
            case 1: str="周一";break
            case 2: str="周二";break
            case 3: str="周三";break
            case 4: str="周四";break
            case 5: str="周五";break
            case 6: str="周六";lb.textColor=UIColor.gray;break
            default:
                break
            }
            
            lb.text=str
            lb.font=UIFont.systemFont(ofSize: 13)
            lb.textAlignment = .center
            
            TopView.addSubview(lb)
        }
        
        for i in 0 ..< 4{
            var str=""
            switch(i){
            case 1:
                str="◀"
                btnleft.frame=CGRect(x: TopView.frame.width/2, y: TopView.frame.height-60, width: TopView.frame.width/6, height: 30)
                btnleft.titleLabel?.font=UIFont.systemFont(ofSize: 20)
                btnleft.setTitleColor(UIColor.blue, for: UIControlState())
                btnleft.setTitle(str, for: UIControlState())
                TopView.addSubview(btnleft)
                break
            case 0:
                str="nyyyymmdd"
                btnyyyymmdd.frame=CGRect(x: 0, y: TopView.frame.height-60, width: TopView.frame.width/2, height: 30)
                btnyyyymmdd.titleLabel?.font=UIFont.boldSystemFont(ofSize: 20)
                btnyyyymmdd.setTitleColor(UIColor.red, for: UIControlState())
                TopView.addSubview(btnyyyymmdd)
                break
            case 3:
                str="▶"
                btnright.frame=CGRect(x: TopView.frame.width*5/6, y: TopView.frame.height-60, width: TopView.frame.width/6, height: 30)
                btnright.titleLabel?.font=UIFont.systemFont(ofSize: 20)
                btnright.setTitleColor(UIColor.blue, for: UIControlState())
                btnright.setTitle(str, for: UIControlState())
                TopView.addSubview(btnright)
                break
            case 2:
                str="今天"
                btnToToday.frame=CGRect(x: TopView.frame.width*2/3, y: TopView.frame.height-60, width: TopView.frame.width/6, height: 30)
                btnToToday.titleLabel?.font=UIFont.systemFont(ofSize: 15)
                btnToToday.setTitleColor(UIColor.red, for: UIControlState())
                btnToToday.setTitle(str, for: UIControlState())
                TopView.addSubview(btnToToday)
                break
            default:
                break
            }
            
        }
        btnleft.addTarget(self, action: #selector(btnLeft_Click), for: .touchUpInside)
        btnright.addTarget(self, action: #selector(btnRight_Click), for: .touchUpInside)
        btnyyyymmdd.addTarget(self, action: #selector(btnyyyymmdd_Click), for: .touchUpInside)
        btnToToday.addTarget(self, action: #selector(btnToToday_Click), for: .touchUpInside)
    }
    
    
    func AddMain(){
        btnyyyymmdd.setTitle("\(nowDate.currentYear)年\(nowDate.currentMonth)月", for: UIControlState()) //更改年月
        
        for sub in MainView.subviews{   //如果存在子项先清空当前子项的内容
            sub.removeFromSuperview()
            ischeck=false
        }
        
        let toYear=Date().currentYear //当前日期的年
        let toMonth=Date().currentMonth   //当前月
        let today=Date().currentDay       //当前日
        let  _width = (MainView.frame.width) / CGFloat(7) //整个MainView宽度的100% / 7
        let _heigth=MainView.frame.height/6
        var indexday=0  //第0位开始
        
        for index in 0...5 {
            for i in 0 ..< 7{
                let btn  = UILabel(frame: CGRect(x: CGFloat(i)*_width, y: CGFloat(index)*_heigth, width: _width, height: _heigth))
                btn.font=UIFont.systemFont(ofSize: 13)
                btn.numberOfLines = 0
                if(i==0 || i==6){
                    btn.textColor = UIColor.gray
                }else{
                    btn.textColor = UIColor.black
                }
                btn.backgroundColor = UIColor.clear
                btn.tag = indexday
                btn.layer.cornerRadius = 0
                btn.textAlignment = NSTextAlignment.center
                btn.isUserInteractionEnabled = true //打开点击事件
                let tap = UITapGestureRecognizer(target: self, action: #selector(selectedCheck))
                btn.addGestureRecognizer(tap)
                
                MainView.addSubview(btn)
                indexday += 1
            }
            
            if index == 0{
                let line = UIView(frame: CGRect(x: 0, y: 70, width: MainView.frame.width, height: 1))
                self.CalendarView.addSubview(line)
                line.backgroundColor = UIColor(red: 51/255, green: 161/255, blue: 202/255, alpha: 1)
            }
        }
        
        indexday=1
        var lastTag = Int()
        var firstTag = Int()
        var hang = Int() //行数
        for sub in MainView.subviews{
            
            let btn =  sub as! UILabel
            //每月第一天
            if(btn.tag==getOneweek){
                firstTag = btn.tag //第一日的tag
                
                if(getLunarDay(Int(indexday.description)!, month: nowDate.currentMonth, year: nowDate.currentYear)[0] == "初一"){
                    btn.text = (indexday.description + "\n" + getLunarDay(Int(indexday.description)!, month: nowDate.currentMonth, year: nowDate.currentYear)[1]) //写阳
                }else{
                    btn.text = (indexday.description + "\n" + getLunarDay(Int(indexday.description)!, month: nowDate.currentMonth, year: nowDate.currentYear)[0]) //写阳
                }
                
                if(Int(indexday.description) == today){ //特殊显示今天
                    if(toYear==nowDate.currentYear&&toMonth==nowDate.currentMonth){ //判断是否是今年今月
                        btn.frame  = CGRect(x: btn.frame.minX+_width/6, y: btn.frame.minY+(_heigth-_width*2/3)/2, width: _width*2/3, height: _width*2/3)
                        btn.backgroundColor = UIColor.red
                        btn.textColor = UIColor.white
                        btn.layer.masksToBounds = true
                        btn.layer.cornerRadius = _width/3
                    }
                }
                indexday += 1
                continue
            }
            //其他天数 小于总天数
            if(indexday>1){
                if(indexday<=daycount){ //当前的天数如果小于等于当月总天数
                    
                    //写数字
                    if(getLunarDay(Int(indexday.description)!, month: nowDate.currentMonth, year: nowDate.currentYear)[0] == "初一"){
                        btn.text = (indexday.description + "\n" + getLunarDay(Int(indexday.description)!, month: nowDate.currentMonth, year: nowDate.currentYear)[1]) //写阳历
                    }else{
                        btn.text = (indexday.description + "\n" + getLunarDay(Int(indexday.description)!, month: nowDate.currentMonth, year: nowDate.currentYear)[0]) //写阳历
                    }
                    
                    if(Int(indexday.description) == today){  //特殊现实今天
                        if(toYear==nowDate.currentYear&&toMonth==nowDate.currentMonth){ //判断是否是今年今月
                            btn.frame  = CGRect(x: btn.frame.minX+_width/6, y: btn.frame.minY+(_heigth-_width*2/3)/2, width: _width*2/3, height: _width*2/3)
                            btn.backgroundColor = UIColor.red
                            btn.textColor = UIColor.white
                            btn.layer.masksToBounds = true
                            btn.layer.cornerRadius = _width/3
                            
                        }
                    }
                    indexday += 1
                    lastTag = btn.tag
                }
            }
        }
        
        //获取每个月的行数
        if(lastTag < 35){
            hang = 5
        }else{
            hang = 6
        }
        
        for index in 1 ..< hang+1 {  //首尾线长度
            
            let line = UIView() //第1根线条
            line.backgroundColor = UIColor.gray
            self.MainView.addSubview(line)
            if(index == 1){
                line.frame = CGRect(x: CGFloat(firstTag)*_width, y: CGFloat(index)*_heigth, width: MainView.frame.width-CGFloat(firstTag)*_width, height: 1)
            }else if(index == hang && hang == 5){
                line.frame = CGRect(x: 0, y: CGFloat(index)*_heigth, width: MainView.frame.width-CGFloat(hang*7-1-lastTag)*_width, height: 1)
            }else if(index == 5 && hang == 6){
                line.frame = CGRect(x: 0, y: CGFloat(index)*_heigth, width: MainView.frame.width, height: 1)
            }else if(index == hang && hang == 6){
                line.frame = CGRect(x: 0, y: CGFloat(index)*_heigth, width: MainView.frame.width-CGFloat(hang*7-1-lastTag)*_width, height: 1)
            }else if(index>1 && index<5){
                line.frame = CGRect(x: 0, y: CGFloat(index)*_heigth, width: MainView.frame.width, height: 1)
            }
        }
    }
    
    @objc func btnToToday_Click(){
        
        var date = Date()
        var conpare = Int()
        if((nowDate.currentYear > date.currentYear) || (nowDate.currentYear == date.currentYear && nowDate.currentMonth > date.currentMonth)){
            conpare = 1
        }else if(nowDate.currentYear == date.currentYear && nowDate.currentMonth == date.currentMonth){
            conpare = 2
        }else{
            conpare = 3
        }
        date = DateToToString.stringToDate(String(date.currentYear) + "-" + String(date.currentMonth) + "-01", format: "yyyy-MM-dd")    //更新当前的年月
        nowDate = date
        getOneweek = date.toMonthOneDayWeek(date)   //更新当前年月周
        daycount = date.TotaldaysInThisMonth(date)  //更新当前年月天数
        if(conpare == 1){
            MoveAnimation(CalendarView ,Type: UIViewAnimationTransition.curlDown)
        }else if(conpare == 3){
            MoveAnimation(CalendarView ,Type: UIViewAnimationTransition.curlUp)
        }
        AddMain()
    }
    
    @objc func btnLeft_Click(){
        
        var date = Date()
        //得到年月的1号
        if((nowDate.currentMonth-1)==0){
            let str:String="\(nowDate.currentYear-1)-\(12)-01"
            date =  DateToToString.stringToDate(str, format: "yyyy-MM-dd")
        }
        else{
            let str:String="\(nowDate.currentYear)-\(nowDate.currentMonth-1)-01"
            date =  DateToToString.stringToDate(str, format: "yyyy-MM-dd")
        }
        nowDate = date    //更新当前的年月
        getOneweek = date.toMonthOneDayWeek(date)   //更新当前年月周
        daycount = date.TotaldaysInThisMonth(date)  //更新当前年月天数
        MoveAnimation(CalendarView ,Type: UIViewAnimationTransition.curlDown)
        AddMain()
    }
    
    @objc func btnRight_Click(){
        
        var date = Date()
        //得到年月的1号
        if((nowDate.currentMonth+1)==13){
            date =  DateToToString.stringToDate("\(nowDate.currentYear+1)-\(01)-01", format: "yyyy-MM-dd")
        }
        else{
            date =  DateToToString.stringToDate("\(nowDate.currentYear)-\(nowDate.currentMonth+1)-01", format: "yyyy-MM-dd")
        }
        nowDate=date    //更新当前的年月
        getOneweek = date.toMonthOneDayWeek(date)    //更新当前年月周
        daycount = date.TotaldaysInThisMonth(date)   //更新当前年月天数
        MoveAnimation(CalendarView ,Type: UIViewAnimationTransition.curlUp)
        AddMain()
    }
    
    @objc func btnyyyymmdd_Click(){
        let pickerView = DatePickerView(view: self, target: self)
        pickerView.buttonYear = nowDate.currentYear
        pickerView.buttonMonth = nowDate.currentMonth
        pickerView.setElements()
        self.superview!.addSubview(pickerView)
    }
    
    //点击处理
    @objc func selectedCheck(_ sender: UITapGestureRecognizer){
        let btn = sender.view as! UILabel
        if(btn.text != nil){
            self.delegate?.itemClicked(btn.text! as String , yyyymm: (btnyyyymmdd.titleLabel?.text)! as String)
        }
    }
    
    func MoveAnimation (_ view:UIView ,Type: UIViewAnimationTransition){
        //开始动画
        UIView.beginAnimations("",context: nil)
        //动画时长
        UIView.setAnimationDuration(0.7)
        // FlipFromRight
        // CurlUp
        //动画样式
        UIView.setAnimationTransition(Type,
                                      for :  view,
                                      cache:true)
        
        //更改view顺序
        view.exchangeSubview(at: 0,withSubviewAt :1)
        //提交动画
        UIView.commitAnimations()
    }
    
    
    //划动手势
    @objc func _handleSwipeGesture(_ sender: UISwipeGestureRecognizer){
        //划动的方向
        let direction = sender.direction
        //判断是上下左右
        switch (direction){
        case UISwipeGestureRecognizerDirection.right:   //右
            btnLeft_Click()
            break
        case UISwipeGestureRecognizerDirection.left:   //左
            btnRight_Click()
            break
        default:
            break;
        }
    }
    
    /**
     获取农历
     */
    func getLunarDay(_ day : Int, month:Int, year:Int) -> [String]{
        var chineseDays = NSArray()
        var chineseMonths = NSArray()
        chineseDays = [ "初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十","十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十","廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
        chineseMonths = [ "正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月","冬月", "腊月"]
        var string : String = ""
        if(month<10){
            if (day < 10) {
                string = (String(year) + "0" + String(month) + "0" + String(day) + "23")
            }else{
                string = (String(year) + "0" + String(month) + String(day) + "23")
            }
        }else{
            if (day < 10) {
                string = (String(year) + String(month) + "0" + String(day) + "23")
            }else{
                string = (String(year) + String(month) + String(day) + "23")
            }
        }
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyyMMddHH"
        
        let inputDate : Date = inputFormatter.date(from: string)!
        let localeCalendar : Calendar = Calendar.init(identifier: Calendar.Identifier.chinese)
        
        let localeComp : DateComponents = (localeCalendar as NSCalendar).components([NSCalendar.Unit.year ,NSCalendar.Unit.month, NSCalendar.Unit.day], from: inputDate)
        
        let d_str : NSString = chineseDays.object(at: localeComp.day! - 1) as! NSString
        let m_str : NSString = chineseMonths.object(at: localeComp.month! - 1) as! NSString
        return [d_str as String, m_str as String]
    }
    
    
}


// MARK: - 拓展日期类
extension Date {
    /**
     这个月有几天
     - parameter date: nsdate
     - returns: 天数
     */
    func TotaldaysInThisMonth(_ date : Date ) -> Int {
        let totaldaysInMonth: NSRange = (Calendar.current as NSCalendar).range(of: .day, in: .month, for: date)
        return totaldaysInMonth.length
    }
    
    /**
     得到本月的第一天的是第几周
     - parameter date: nsdate
     - returns: 第几周
     */
    func toMonthOneDayWeek (_ date:Date) ->Int {
        let Week: NSInteger = (Calendar.current as NSCalendar).ordinality(of: .day, in: NSCalendar.Unit.weekOfMonth, for: date)
        return Week-1
    }
    
    /**
     获取yyyy  MM  dd  HH mm ss
     - parameter format: 比如 GetFormatDate(yyyy) 返回当前日期年份
     - returns: 返回值
     */
    func getFormatDate(_ format:String)->Int{
        let dateFormatter:DateFormatter = DateFormatter();
        dateFormatter.dateFormat = format;
        let dateString:String = dateFormatter.string(from: self);
        var dates:[String] = dateString.components(separatedBy: "")
        let Value  = dates[0]
        if(Value==""){
            return 0
        }
        return Int(Value)!
    }
}

//选择的协议
extension CalendarView: DatePickerViewDelegate{
    
    func doneClicked(_ yyyymm: String) {
        let yyyymmArray = yyyymm.components(separatedBy: "年")
        let yyyy = yyyymmArray[0]
        let mm = yyyymmArray[1].components(separatedBy: "月")[0]
        let date = DateToToString.stringToDate(yyyy + "-" + mm + "-01", format: "yyyy-MM-dd")
        var conpare = Int()
        
        if((nowDate.currentYear > date.currentYear) || (nowDate.currentYear == date.currentYear && nowDate.currentMonth > date.currentMonth)){
            conpare = 1
        }else if(nowDate.currentYear == date.currentYear && nowDate.currentMonth == date.currentMonth){
            conpare = 2
        }else{
            conpare = 3
        }
        nowDate = date
        getOneweek = date.toMonthOneDayWeek(date)   //更新当前年月周
        daycount = date.TotaldaysInThisMonth(date)  //更新当前年月天数
        if(conpare == 1){
            MoveAnimation(CalendarView ,Type: UIViewAnimationTransition.curlDown)
        }else if(conpare == 3){
            MoveAnimation(CalendarView ,Type: UIViewAnimationTransition.curlUp)
        }
        AddMain()
    }
}
