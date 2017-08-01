//
//  MyIconViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

//选择的协议
extension PersonInfo_IconViewController : bottomMenuViewDelegate{
    func buttonClicked(_ tag: Int, eventFlag: Int) {
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

class PersonInfo_IconViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate{

    fileprivate var imageView: UIImageView?
    fileprivate var picker: UIImagePickerController?
    
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
        self.view.backgroundColor = UIColor.black
        
        //右上角添加按钮
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.camera, target: self, action: #selector(self.addButtonClicked))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    //右上角的点击事件
    func addButtonClicked(){
        let bottomMenu = MyBottomMenuView()
        bottomMenu.showBottomMenu("", cancel: "取消", object: ["拍照","从手机相册选择"], eventFlag: 0, target: self)
    }
    
    //页面添加展示图片的iamgeVIew
    func setUpPic(){
        imageView = UIImageView(frame: CGRect(x: 0, y: Height/2 - Width/2 , width: Width, height: Width))
        imageView!.image = image
        
        self.view.addSubview(imageView!)
    }
    
    //拍照
    func takePhoto(){
        let sourceType : UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker = UIImagePickerController()
            picker?.delegate = self
            picker!.allowsEditing = true
            picker?.sourceType = sourceType
            self.present(picker!, animated:true, completion: nil)
        }else{
            logger.info("模拟器中无法打开照相机，请在真机上使用")
        }
    }
    
    //选取当地的照片，想要页面中为，在info。plist 中Localized resources can be mixed 为YES
    func localPhoto(){
        picker = UIImagePickerController()
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker!.allowsEditing = true
        picker!.delegate = self
        self.present(picker!, animated:true, completion: nil)
    }
    
    //选取图片之后
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]){
        let type : NSString = info["UIImagePickerControllerMediaType"] as! NSString
        if(type.isEqual(to: "public.image")){
            
            let image : UIImage = info["UIImagePickerControllerEditedImage"] as! UIImage
            let imageData = ChangeValue.imageToData(image)
            
            var result = Bool()
            //保存联系人
            result = SQLLine.UpdateDataWithCondition("nickname='"+myNikename+"'", entityName: entityNameOfContectors, changeValue: imageData as AnyObject, changeEntityName: "icon")
            result ? ToastView().showToast("保存成功！") : ToastView().showToast("保存失败！")
            
            imageView!.image = image    //展示
            myInfo = UserInfo(name: myInfo.username, icon: image, nickname: myInfo.nickname) //把改变的image保存到icon
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
