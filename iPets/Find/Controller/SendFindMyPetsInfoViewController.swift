//
//  SendFindMyPetsInfoViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/30.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SendFindMyPetsInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SendFindMyPetsInfoCellViewDelegate, PassPhotosDelegate, UITextViewDelegate{
    
    fileprivate var mainTabelView: UITableView? //整个table
    fileprivate var tableData : NSMutableArray? //数据
    var images = [UIImage]() //保存选择的图片的缩略图
    fileprivate var imagesHighQData = [Data]() //高清图的nsdata

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setUpTable()
        setData()
        // Do any additional setup after loading the view.
    }
    
    func setUpEles(){
        UINavigationBar.appearance().barTintColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white  //导航栏左右按钮文字颜色
        self.view.backgroundColor = UIColor.white
        
        //取消按钮
        let leftBarBtn = UIBarButtonItem(title: "取消", style: .plain, target: self,
                                         action: #selector(SendFindMyPetsInfoViewController.backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        //发送按钮
        let rightBarBtn = UIBarButtonItem(title: "发送", style: .plain, target: self,
                                          action: #selector(SendFindMyPetsInfoViewController.sendFindMyPetsInfo))
        rightBarBtn.tintColor = getMainColor()
        self.navigationItem.rightBarButtonItem = rightBarBtn
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    
    //返回
    func backToPrevious() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //发送
    func sendFindMyPetsInfo(){
        let waitView = WaitView()
        waitView.showWait("发布中")
        
        globalQueue.async(execute: {
            let time = Date()
            
            //提取原来的寻宠数据
            let findMyPetsData = SaveDataModel()
            var oldData = findMyPetsData.loadFindMyPetsDataFromTempDirectory()
            
            if(self.imagesHighQData.count > 0){
                let timeStr = DateToToString.dateToStringBySelf(time, format: "yyyyMMddHHmmss")
                //保存图片到本地沙盒
                let saveCache = SaveCacheDataModel()
                var nameArray = [String]() //保存名字数组
                
                for j in 0 ..<  self.imagesHighQData.count{
                    if saveCache.savaImageToFindPetsCacheDir(self.imagesHighQData[j], imageName: "H\(timeStr)\(j).png"){
                        print("保存缓存成功！")
                    }else{
                        print("保存缓存失败！")
                    }
                    
                    if saveCache.savaImageToFindPetsCacheDir(self.images[j], imageName: "\(timeStr)\(j)", imageType: "png"){
                       print("保存缓存成功！")
                    }else{
                        print("保存缓存失败！")
                    }
                    
                    nameArray.append("\(timeStr)\(j).png")
                }
                
                let myFindPetsInfo = FindPetsCellModel(name: myInfo.username!, text: self.myText.text, picture: nameArray, date: time, nickname: myInfo.nickname!)
                oldData.append(myFindPetsInfo)
            }else{
                let myFindPetsInfo = FindPetsCellModel(name: myInfo.username!, text: self.myText.text, picture: nil, date: time, nickname: myInfo.nickname!)
                oldData.append(myFindPetsInfo)
            }
            
            //保存寻宠数据
            findMyPetsData.saveFindMyPetsToTempDirectory(oldData)
            
            mainQueue.async(execute: {
                
                waitView.hideView()
                self.backToPrevious()
            })
        })
    }
    
    //设置数据
    func setData(){
        tableData = NSMutableArray()
        
        let tableOne = SendFindMyPetInfoModel(pics: [])
        let tableOneTwo = SendFindMyPetInfoModel(name: "所在位置", lable: "", icon: "Location")
        let tableTwo = SendFindMyPetInfoModel(name: "谁可以看", lable: "公开", icon: "WhoCanSee")
        let tableTwoTwo = SendFindMyPetInfoModel(name: "提醒谁看", lable: "", icon: "MindWhoSee")
        
        tableData?.add([tableOne, tableOneTwo])
        tableData?.add([tableTwo, tableTwoTwo])
        
        mainTabelView?.reloadData()
        
        //有图片时，可点
        if tableOne.pics.count == 0{
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
//设置tableView
    func setUpTable(){
        mainTabelView = UITableView(frame: self.view.frame, style: .grouped)  //为group模式
        mainTabelView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        mainTabelView?.showsVerticalScrollIndicator = false
        mainTabelView?.showsHorizontalScrollIndicator = false
        mainTabelView?.sectionFooterHeight = 10
        mainTabelView?.separatorStyle = UITableViewCellSeparatorStyle.singleLine //是否显示线条
        
        mainTabelView?.delegate = self
        mainTabelView?.dataSource = self
        
        self.view.addSubview(mainTabelView!)
    }
    
    //section个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData!.count
    }
    
    //每个section的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableData![section] as AnyObject).count
    }
    
    //计算每个cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section: [AnyObject]  =  self.tableData![indexPath.section] as! [AnyObject] //获取section里的对象
        let data = section[indexPath.row]
        let item =  data as! SendFindMyPetInfoModel
        let height  = item.view.frame.height
        
        return height
    }
    
    //每个cell内容
    let myText = UITextView()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "InfoCell"
        let section : NSArray =  self.tableData![indexPath.section] as! NSArray
        let data = section[indexPath.row]
        let cell =  SendFindMyPetsInfoTableViewCell(data:data as! SendFindMyPetInfoModel, reuseIdentifier:cellId)
        cell.delegate = self
        
        if(indexPath.section != 0 || indexPath.row != 0){
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }else{
            cell.selectionStyle = .none  //不可点击
            
            //输入栏text
            myText.frame = CGRect(x: cell.frame.origin.x+20, y: cell.frame.origin.y+5, width: Width-25, height: 90)
            myText.font = sendPageInputTextFont
            myText.delegate = self
            cell.addSubview(myText)
        }
        
        return cell
    }
    
    //输入框改变额值,发送按钮就可点击了
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    //＋点击事件
    func addMorePic() {
        
        //进入选择图片页面
        let imagePickVc = ImageCollectionViewController()
        imagePickVc.photoDelegate = self  //经常忘记这一步
        imagePickVc.pageTitle = "完成"
        imagePickVc.countLimited = 9
        self.navigationController?.pushViewController(imagePickVc, animated: true)
    }
    
    //选择图片界面的代理方法
    func passPhotos(_ selected: [ImageCollectionModel]) {
        images = [] //清空
        imagesHighQData = []
        
        for i in 0 ..< selected.count {
            //在列表页显示缩略图
            if selected.count == 1 {
                let image = selected[i].asset
                images.append(image!)
            }else{
                let image = selected[i].asset
                images.append(image!)
            }
            
            //这里保存的高清图片
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),{
                //这里写需要放到子线程做的耗时的代码
                //如果该图片大于2M，会自动旋转90度；否则不旋转
                
                //let representation = selected[i].asset.defaultRepresentation()
                //let imageBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int((representation?.size())!))
                //let bufferSize = representation?.getBytes(imageBuffer, fromOffset: Int64(0),
                  //  length: Int((representation?.size())!), error: nil)
                //let data = Data(bytesNoCopy: UnsafeMutablePointer<UInt8>(imageBuffer) ,count: bufferSize!, deallocator: .free)
                
//                let imageH = self.fixOrientation(UIImage(data: data)!)
                
//                dispatch_async(dispatch_get_main_queue(), {
                  //  self.imagesHighQData.append(data)
//                })
//            })
            
        }
        setReloadData(images)
    }
    
    //修正旋转
    func fixOrientation(_ aImage: UIImage) -> UIImage {
        
        if (aImage.imageOrientation == .up) {
            
            return aImage
            
        }
        
        var transform = CGAffineTransform.identity
        
        switch (aImage.imageOrientation) {
            
        case .down, .downMirrored:
            
            transform = transform.translatedBy(x: aImage.size.width, y: aImage.size.height)
            
            transform = transform.rotated(by: CGFloat(Double.pi))
            
        case .left, .leftMirrored:
            
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            
            transform = transform.rotated(by: CGFloat(Double.pi/2))
            
        case .right, .rightMirrored:
            
            transform = transform.translatedBy(x: 0, y: aImage.size.height)
            
            transform = transform.rotated(by: CGFloat(-(Double.pi)/2))
            
        default:
            
            break
            
        }
        
        switch (aImage.imageOrientation) {
            
        case .upMirrored, .downMirrored:
            
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            
            transform = transform.translatedBy(x: aImage.size.height, y: 0)
            
            transform = transform.scaledBy(x: -1, y: 1)
            
        default:
            
            break
            
        }
        
        let ctx = CGContext(data: nil, width: Int(aImage.size.width), height: Int(aImage.size.height),
                                        
                                        bitsPerComponent: (aImage.cgImage?.bitsPerComponent)!, bytesPerRow: 0,
                                        
                                        space: (aImage.cgImage?.colorSpace!)!,
                                        
                                        bitmapInfo: (aImage.cgImage?.bitmapInfo.rawValue)!)
        
        ctx?.concatenate(transform)
        
        switch (aImage.imageOrientation) {
            
        case .left, .leftMirrored, .right, .rightMirrored:
            
            ctx?.draw(aImage.cgImage!, in: CGRect(x: 0,y: 0,width: aImage.size.height,height: aImage.size.width))
            
        default:
            
            ctx?.draw(aImage.cgImage!, in: CGRect(x: 0,y: 0,width: aImage.size.width,height: aImage.size.height))
            
        }
        
        // And now we just create a new UIImage from the drawing context
        
        let cgimg = ctx?.makeImage()
        
        return UIImage(cgImage: cgimg!)
        
    }
    
    //设置数据
    func setReloadData(_ pics: [UIImage]){
        tableData = NSMutableArray()
        
        let tableOne = SendFindMyPetInfoModel(pics: pics)
        let tableOneTwo = SendFindMyPetInfoModel(name: "所在位置", lable: "", icon: "Location")
        let tableTwo = SendFindMyPetInfoModel(name: "谁可以看", lable: "公开", icon: "WhoCanSee")
        let tableTwoTwo = SendFindMyPetInfoModel(name: "提醒谁看", lable: "", icon: "MindWhoSee")
        
        tableData?.add([tableOne, tableOneTwo])
        tableData?.add([tableTwo, tableTwoTwo])
        
        mainTabelView?.reloadData()
        
        //有图片时，可点
        if tableOne.pics.count == 0{
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    //选择了row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTabelView!.deselectRow(at: indexPath, animated: true)  //被选择后，会变灰，这么做还原
        
        switch indexPath.section{
        case 0:
            switch indexPath.row {
            //位置
            case 1:
//                let myIconVc = MyIconViewController()
//                myIconVc.image = item.pic
//                self.navigationController?.pushViewController(myIconVc, animated: true)
                break
                
            default:
                break
            }
        case 1:
            switch indexPath.row {
            //谁可以看
            case 0:
//                let myNameVc = PersonInfoChangeNameViewController()
//                myNameVc.name = item.lable
//                self.navigationController?.pushViewController(myNameVc, animated: true)
                break
                
            //提醒谁看
            case 1:
//                let myTDIcon = MyTDCodeImageViewController()
//                self.navigationController?.pushViewController(myTDIcon, animated: true)
                break
            default:
                break
            }
        default:
            break
        }
    }
    
    //第一个section距离navigationbar的距离,第一个和第二个的间距设置，用mainTabelView?.sectionFooterHeight = 10，这个距离的计算是header的高度加上footer的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
