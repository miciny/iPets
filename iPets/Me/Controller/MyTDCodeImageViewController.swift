//
//  MyTDCodeImageViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/25.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

//选择的协议
extension MyTDCodeImageViewController : bottomMenuViewDelegate{
    func buttonClicked(_ tag: Int, eventFlag: Int) {
        switch eventFlag{
        case 0:
            switch tag{
            case 0:
                //保存图片到本地相册
                UIImageWriteToSavedPhotosAlbum(imageView!.image!, self,
                                               #selector(MyTDCodeImageViewController.image), nil)
            case 1:
                ToastView().showToast("扫描二维码")
            default:
                break
            }
        default:
            break
        }
    }
}

class MyTDCodeImageViewController: UIViewController {
    
    fileprivate var imageView : UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setUpPic()
        // Do any additional setup after loading the view.
    }
    
    //定义title 导航栏等
    func setUpEles(){
        self.title = "个人二维码"
        self.view.backgroundColor = UIColor.white
        
        //右上角添加按钮
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self,
                                      action: #selector(MyIconViewController.addButtonClicked))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    //右上角的点击事件
    func addButtonClicked(){
        let bottomMenu = MyBottomMenuView()
        bottomMenu.showBottomMenu("", cancel: "取消", object: ["保存图片","扫描二维码"], eventFlag: 0, target: self)
    }
    
    //页面添加展示图片的iamgeVIew
    func setUpPic(){
        
        //从CoreData里读取数据
        let SettingDataArray = SQLLine.SelectAllData(entityNameOfSettingData)
        let myIconData = (SettingDataArray.lastObject! as AnyObject).value(forKey: settingDataNameOfMyIcon)! as! Data
        let myIconImage = UIImage(data: myIconData)!
        
        //生成二维码，存储
        let TDCodeImage = createQRForString(myOwnUrl, qrImage: myIconImage)
        
        imageView = UIImageView(frame: CGRect(x: 40, y: Height/2 - Width/2 , width: Width-80, height: Width-80))
        imageView!.image = TDCodeImage
        
        self.view.addSubview(imageView!)
    }

    func image(_ image: UIImage, didFinishSavingWithError: NSError?,contextInfo: AnyObject){
        
        if didFinishSavingWithError != nil{
            ToastView().showToast("保存出错！")
            return
        }
        ToastView().showToast("保存成功！")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
