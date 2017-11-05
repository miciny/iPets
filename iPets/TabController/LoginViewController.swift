////
////  LoginViewController.swift
////  iPets
////
////  Created by maocaiyuan on 2017/8/27.
////  Copyright © 2017年 maocaiyuan. All rights reserved.
////
//
//import UIKit
//import Alamofire
//
//class LoginViewController: UIViewController {
//
//    var account = UITextField()
//    var pw = UITextField()
//    var manager: SessionManager!
//    
//    var userIcon = UIImageView()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        manager = NetFuncs.getDefaultAlamofireManager()
//        setUpEles()
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        hideNavigator()
//    }
//    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return UIStatusBarStyle.lightContent
//    }
//    
//    func hideNavigator(){
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//    
//    //设置元素
//    func setUpEles(){
//        self.view.backgroundColor = UIColor.white
//        
//        let settingBtnSize = sizeWithText("设置网络", font: standardFont, maxSize: CGSize(width: Width, height: Height))
//        let settingBtn = UIButton(frame: CGRect(x: Width-20-settingBtnSize.width, y: 54, width: settingBtnSize.width, height: settingBtnSize.height))
//        settingBtn.setTitle("设置网络", for: UIControlState())
//        settingBtn.setTitleColor(UIColor(red: 0/255, green: 191/255, blue: 255/255, alpha: 1), for: UIControlState())
//        settingBtn.titleLabel?.font = standardFont
//        settingBtn.addTarget(self, action: #selector(self.settingNet), for: .touchUpInside)
//        self.view.addSubview(settingBtn)
//        
//        
//        userIcon.frame = CGRect(x: Width/2-50, y: 100, width: 100, height: 100)
//        userIcon.image = ChangeValue.dataToImage(nil)
//        userIcon.layer.masksToBounds = true
//        userIcon.layer.cornerRadius = 5
//        self.view.addSubview(userIcon)
//        
//        let nameLabelSize = sizeWithText("账号", font: standardFont, maxSize: CGSize(width: Width, height: Height))
//        let nameLabel = UILabel(frame: CGRect(x: 10, y: userIcon.frame.maxY+20, width: nameLabelSize.width, height: 44))
//        nameLabel.font = standardFont
//        nameLabel.text = "账号"
//        self.view.addSubview(nameLabel)
//        
//        account.frame = CGRect(x: nameLabel.frame.maxX + 50, y: nameLabel.frame.minY, width: Width-nameLabel.frame.maxX - 50, height: 44)
//        account.placeholder = "请输入账号"
//        account.font = standardFont
//        account.delegate = self
//        account.tag = 1
//        account.clearButtonMode = .whileEditing
//        self.view.addSubview(account)
//        
//        let line1 = UIView(frame: CGRect(x: 10, y: nameLabel.frame.maxY, width: Width-10, height: 1))
//        line1.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
//        self.view.addSubview(line1)
//        
//        let pwLabelSize = sizeWithText("密码", font: standardFont, maxSize: CGSize(width: Width, height: Height))
//        let pwLabel = UILabel(frame: CGRect(x: 10, y: nameLabel.frame.maxY+1, width: pwLabelSize.width, height: 44))
//        pwLabel.font = standardFont
//        pwLabel.text = "密码"
//        self.view.addSubview(pwLabel)
//        
//        pw.frame = CGRect(x: account.frame.minX, y: pwLabel.frame.minY, width: account.frame.width, height: 44)
//        pw.placeholder = "请输入登录密码"
//        pw.font = standardFont
//        pw.tag = 2
//        pw.delegate = self
//        pw.clearButtonMode = .whileEditing
//        pw.isSecureTextEntry = true
//        self.view.addSubview(pw)
//        
//        let line2 = UIView(frame: CGRect(x: 10, y: pwLabel.frame.maxY, width: Width-10, height: 1))
//        line2.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
//        self.view.addSubview(line2)
//        
//        
//        let backColor = UIColor(red: 0/255, green: 191/255, blue: 255/255, alpha: 1)
//        let titleColor = UIColor.white
//        let loginBtn = self.getBtn(title: "登陆", backcolor: backColor, titlecolor: titleColor, action: #selector(self.login))
//        loginBtn.frame.origin = CGPoint(x: 10, y: line2.frame.maxY+10)
//        self.view.addSubview(loginBtn)
//        
//        let rbackColor = UIColor.white
//        let rtitleColor = UIColor(red: 0, green: 191/255, blue: 255/255, alpha: 1)
//        let registBtn = self.getBtn(title: "注册", backcolor: rbackColor, titlecolor: rtitleColor, action: nil)
//        registBtn.frame.origin = CGPoint(x: 10, y: Height-64)
//        self.view.addSubview(registBtn)
//    }
//    
//    
//    private func getBtn(title: String, backcolor: UIColor, titlecolor: UIColor, action: Selector?) -> UIButton{
//        let btn = UIButton()
//        btn.frame.size = CGSize(width: Width-20, height: 44)
//        btn.setTitle(title, for: UIControlState())
//        btn.layer.masksToBounds = true
//        btn.layer.borderWidth = 0.8
//        btn.layer.borderColor = UIColor.gray.cgColor
//        btn.layer.cornerRadius = 5
//        btn.backgroundColor = UIColor.white
//        if let action = action{
//            btn.addTarget(self, action: action, for: .touchUpInside)
//        }
//        btn.setTitleColor(titlecolor, for: UIControlState())
//        return btn
//    }
//    
//    
//    
//    
////=================================设置网络===========================
//    func settingNet(){
//        let vc = SettingNetViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    //键盘上的完成按钮 相应事件 收起键盘
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        //收起键盘
//        textField.resignFirstResponder()
//        return true
//    }
//    
//    //输入框字符改变了
//    //    要获取最新内容，则需要String的 stringByReplacingCharactersInRange 方法，但这个方法在Swift的String中又不支持。
//    //    要解决这个问题，就要先替 NSRange 做个扩展。
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
//                   replacementString string: String) -> Bool {
//        if textField.tag == 1 {
//            let newText = textField.text!.replacingCharacters(
//                in: range.toRange(textField.text!), with: string)
//            //加载图片
//            if let imageData = SaveDataToCacheDir.loadIconFromCacheDir(newText){
//                userIcon.image = ChangeValue.dataToImage(imageData)
//            }else{
//                userIcon.image = ChangeValue.dataToImage(nil)
//            }
//        }
//        
//        return true
//    }
//    
//    //login
//    func login(){
//        
//        if checkNet() != networkType.wifi{
//            textAlertView("请连接Wi-Fi登录")
//            return
//        }
//        
//        account.resignFirstResponder()
//        pw.resignFirstResponder()
//        
//        guard let accountStr = account.text, accountStr != "" else{
//            textAlertView("请输入账号！")
//            return
//        }
//        
//        guard let pwStr = pw.text, pwStr != "" else{
//            textAlertView("请输入密码！")
//            return
//        }
//        
//        let para = [
//            "account": "\(accountStr)",
//            "pw": "\(pwStr)"
//        ]
//        
//        let waitView = MyWaitView()
//        waitView.showWait("登录中")
//        NetWork.showNetIndicator()
//        
//        manager.request(.GET, NetWork.loginUrl, parameters: para)
//            .responseJSON { response in
//                
//                waitView.hideView()
//                NetWork.hidenNetIndicator()
//                
//                switch response.result{
//                case .Success:
//                    let code = String((response.response?.statusCode)!)
//                    if code == "200"{
//                        MyToastView().showToast("登录成功")
//                        User.insertUserData(accountStr, name: nil, nickname: nil, address: nil, location: nil, pw: pwStr, sex: nil, time: getTime(), motto: nil, pic: nil, http: nil, picPath: nil)
//                        self.dismissViewControllerAnimated(false, completion: nil)
//                        
//                    }else if code == "201" || code == "202"{
//                        MyToastView().showToast("用户名或密码错误")
//                    }else {
//                        let str = getErrorCodeToString(code)
//                        MyToastView().showToast("\(str)")
//                    }
//                    
//                case .Failure:
//                    NetWork.networkFailed(response.response)
//                    print(response.response)
//                }
//        }
//    }
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
