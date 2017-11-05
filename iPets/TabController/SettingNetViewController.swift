////
////  SettingNetViewController.swift
////  iPets
////
////  Created by maocaiyuan on 2017/8/27.
////  Copyright © 2017年 maocaiyuan. All rights reserved.
////
//
//import UIKit
//
//class SettingNetViewController: UIViewController {
//
//    var account = UITextField()
//    var pw = UITextField()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setUpEles()
//        setData()
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//    }
//    
//    
//    func setUpEles(){
//        self.view.backgroundColor = UIColor.white
//        
//        let nameLabelSize = sizeWithText("IP", font: standardFont, maxSize: CGSize(width: Width, height: Height))
//        let nameLabel = UILabel(frame: CGRect(x: 10, y: 100, width: nameLabelSize.width, height: 44))
//        nameLabel.font = standardFont
//        nameLabel.text = "IP"
//        self.view.addSubview(nameLabel)
//        
//        account.frame = CGRect(x: nameLabel.frame.maxX + 50, y: nameLabel.frame.minY, width: Width-nameLabel.frame.maxX - 60, height: 44)
//        account.placeholder = "请输入IP地址"
//        account.font = standardFont
//        account.clearButtonMode = .whileEditing
//        self.view.addSubview(account)
//        
//        let line1 = UIView(frame: CGRect(x: 10, y: nameLabel.frame.maxY, width: Width-10, height: 1))
//        line1.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
//        self.view.addSubview(line1)
//        
//        let pwLabelSize = sizeWithText("Port", font: standardFont, maxSize: CGSize(width: Width, height: Height))
//        let pwLabel = UILabel(frame: CGRect(x: 10, y: nameLabel.frame.maxY+1, width: pwLabelSize.width, height: 44))
//        pwLabel.font = standardFont
//        pwLabel.text = "Port"
//        self.view.addSubview(pwLabel)
//        
//        pw.frame = CGRect(x: account.frame.minX, y: pwLabel.frame.minY, width: account.frame.width, height: 44)
//        pw.placeholder = "请输入Port"
//        pw.font = standardFont
//        pw.clearButtonMode = .whileEditing
//        self.view.addSubview(pw)
//        
//        let line2 = UIView(frame: CGRect(x: 10, y: pwLabel.frame.maxY, width: Width-10, height: 1))
//        line2.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
//        self.view.addSubview(line2)
//        
//        let loginBtn = UIButton(frame: CGRect(x: 10, y: line2.frame.maxY+10, width: Width-20, height: 44))
//        loginBtn.setTitle("保存", for: UIControlState())
//        loginBtn.layer.masksToBounds = true
//        loginBtn.layer.cornerRadius = 5
//        loginBtn.backgroundColor = UIColor(red: 0/255, green: 191/255, blue: 255/255, alpha: 1)
//        loginBtn.setTitleColor(UIColor.white, for: UIControlState())
//        loginBtn.addTarget(self, action: #selector(self.save), for: .touchUpInside)
//        self.view.addSubview(loginBtn)
//    }
//    
//    func setData(){
//        let data = DataToModel.getURLModel()
//        let ip = data.ip
//        let port = data.port
//        
//        account.text = ip
//        pw.text = port
//    }
//    
//    func save(){
//        guard let ip = account.text, ip != "" else{
//            textAlertView("请输入IP地址！")
//            return
//        }
//        
//        guard let port = pw.text, port != "" else{
//            textAlertView("请输入Port端口号！")
//            return
//        }
//        
//        InternetSetting.updateuserData(0, changeValue: ip, changeFieldName: internetSettingNameOfIP)
//        InternetSetting.updateuserData(0, changeValue: port, changeFieldName: internetSettingNameOfPort)
//        
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//}
