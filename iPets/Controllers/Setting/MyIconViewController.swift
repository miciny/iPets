//
//  MyIconViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

//选择的协议
extension MyIconViewController : bottomMenuViewDelegate{
    func buttonClicked(tag: Int, eventFlag: Int) {
        switch eventFlag{
        case 0:
            switch tag{
            case 0:
                takePhoto()
            case 1:
                localPhoto()
            default:
                break
            }
        default:
            break
        }
    }
}

class MyIconViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate{

    private var imageView : UIImageView?
    private var picker:UIImagePickerController?
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setUpPic()
        
        // Do any additional setup after loading the view.
    }
    
    //定义title 导航栏等
    func setUpEles(){
        self.title = "个人头像"
        self.view.backgroundColor = UIColor.blackColor()
        
        //右上角添加按钮
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: #selector(MyIconViewController.addButtonClicked))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    //右上角的点击事件
    func addButtonClicked(){
        let bottomMenu = BottomMenuView(title: "", cancel: "取消", object: ["拍照","从手机相册选择"], target: self)
        bottomMenu.eventFlag = 0
    }
    
    //页面添加展示图片的iamgeVIew
    func setUpPic(){
        imageView = UIImageView(frame: CGRect(x: 0, y: Height/2 - Width/2 , width: Width, height: Width))
        imageView!.image = image
        
        self.view.addSubview(imageView!)
    }
    
    //拍照
    func takePhoto(){
        let sourceType : UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.Camera
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            picker = UIImagePickerController()
            picker?.delegate = self
            picker!.allowsEditing = true
            picker?.sourceType = sourceType
            self.presentViewController(picker!, animated:true, completion: nil)
        }else{
            print("模拟器中无法打开照相机，请在真机上使用")
        }
    }
    
    //选取当地的照片，想要页面中为，在info。plist 中Localized resources can be mixed 为YES
    func localPhoto(){
        picker = UIImagePickerController()
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker!.allowsEditing = true
        picker!.delegate = self
        self.presentViewController(picker!, animated:true, completion: nil)
    }
    
    //选取图片之后
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]){
        let type : NSString = info["UIImagePickerControllerMediaType"] as! NSString
        if(type.isEqualToString("public.image")){
            let image : UIImage = info["UIImagePickerControllerEditedImage"] as! UIImage
            let imageData = ChangeValue.imageToData(image)
            
            //从CoreData里读取数据
            let SettingDataArray = SQLLine.SelectAllData(entityNameOfSettingData)
            
            //保存到最后一行
            let result = SQLLine.UpdateSettingData(SettingDataArray.count-1, changeValue: imageData,
                                            changeEntityName: settingDataNameOfMyIcon)
            //给出提示
            result ? ToastView().showToast("保存成功！") : ToastView().showToast("保存失败！")
            
            imageView!.image = image    //展示
            myInfo = UserInfo(name: myInfo.username, icon: image, nickname: myInfo.nickname) //把改变的image保存到icon
            picker.dismissViewControllerAnimated(true, completion:nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
