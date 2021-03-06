//
//  MyTDCodeImageViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/25.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Social

//选择的协议
extension PersonInfo_TDCodeImageViewController: bottomMenuViewDelegate{
    func buttonClicked(_ tag: Int, eventFlag: Int) {
        switch eventFlag{
        case 0:
            switch tag{
            case 0:
                //保存图片到本地相册
                UIImageWriteToSavedPhotosAlbum(imageView!.image!, self,
                                               #selector(PersonInfo_TDCodeImageViewController.image), nil)
            case 1:
                self.share()
            default:
                break
            }
        default:
            break
        }
    }
}

class PersonInfo_TDCodeImageViewController: UIViewController {
    
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
                                      action: #selector(self.addButtonClicked))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    //右上角的点击事件
    @objc func addButtonClicked(){
        let bottomMenu = MyBottomMenuView()
        bottomMenu.showBottomMenu("", cancel: "取消", object: ["保存图片","分享"], eventFlag: 0, target: self)
    }
    
    //页面添加展示图片的iamgeVIew
    func setUpPic(){
        
        //从CoreData里读取数据
        var myIconData = Data()
        if let data = SQLLine.SelectedCordData("nickname='"+myNikename+"'", entityName: entityNameOfContectors){
            if data.count == 1{
                myIconData = (data[0] as! Contectors).icon! as Data
            }
        }
        
        let myIconImage = UIImage(data: myIconData)!
        
        //生成二维码，存储
        let TDCodeImage = createQRForString(myOwnUrl, qrImage: myIconImage)
        
        imageView = UIImageView(frame: CGRect(x: 40, y: Height/2 - Width/2 , width: Width-80, height: Width-80))
        imageView!.image = TDCodeImage
        
        self.view.addSubview(imageView!)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError: NSError?,contextInfo: AnyObject){
        
        if didFinishSavingWithError != nil{
            ToastView().showToast("保存出错！")
            return
        }
        ToastView().showToast("保存成功！")
    }
    
    
//=====================================分享=======================================
    
    func share(){
        let image = (imageView!.image)!
        
        let activityViewController = shareImage(image: image)
        self.present(activityViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
