//
//  SendFindMyPetsInfoViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/30.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SendFindMyPetsInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SendFindMyPetsInfoCellViewDelegate, PassPhotosDelegate, UITextViewDelegate{
    private var mainTabelView: UITableView? //整个table
    private var tableData : NSMutableArray? //数据
    var images = [UIImage]() //保存选择的图片的缩略图
    private var imagesHighQData = [NSData]() //高清图的nsdata

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setUpTable()
        setData()
        // Do any additional setup after loading the view.
    }
    
    func setUpEles(){
        UINavigationBar.appearance().barTintColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()  //导航栏左右按钮文字颜色
        self.view.backgroundColor = UIColor.whiteColor()
        
        //取消按钮
        let leftBarBtn = UIBarButtonItem(title: "取消", style: .Plain, target: self,
                                         action: #selector(SendFindMyPetsInfoViewController.backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        //保存按钮
        let rightBarBtn = UIBarButtonItem(title: "发送", style: .Plain, target: self,
                                          action: #selector(SendFindMyPetsInfoViewController.sendFindMyPetsInfo))
        rightBarBtn.tintColor = getMainColor()
        self.navigationItem.rightBarButtonItem = rightBarBtn
        self.navigationItem.rightBarButtonItem?.enabled = false
        
    }
    
    //返回
    func backToPrevious() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //发送
    func sendFindMyPetsInfo(){
        let waitView = WaitView()
        waitView.showWait("发布中")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),{
            let time = NSDate()
            
            //提取原来的寻宠数据
            let findMyPetsData = SaveDataModel()
            var oldData = findMyPetsData.loadFindMyPetsDataFromTempDirectory()
            
            if(self.imagesHighQData.count > 0){
                let timeStr = DateToToString.dateToStringBySelf(time, format: "yyyyMMddHHmmss")
                //保存图片到本地沙盒
                let saveCache = SaveCacheDataModel()
                var nameArray = [String]() //保存名字数组
                
                for j in 0 ..<  self.imagesHighQData.count{
                    saveCache.savaImageToFindPetsCacheDir(self.imagesHighQData[j], imageName: "H\(timeStr)\(j).png")
                    saveCache.savaImageToFindPetsCacheDir(self.images[j], imageName: "\(timeStr)\(j)", imageType: "png")
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
            
            dispatch_async(dispatch_get_main_queue(), {
                
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
        
        tableData?.addObject([tableOne, tableOneTwo])
        tableData?.addObject([tableTwo, tableTwoTwo])
        
        mainTabelView?.reloadData()
        
        //有图片时，可点
        if tableOne.pics.count == 0{
            self.navigationItem.rightBarButtonItem?.enabled = false
        }else{
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    
//设置tableView
    func setUpTable(){
        mainTabelView = UITableView(frame: self.view.frame, style: .Grouped)  //为group模式
        mainTabelView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        mainTabelView?.showsVerticalScrollIndicator = false
        mainTabelView?.showsHorizontalScrollIndicator = false
        mainTabelView?.sectionFooterHeight = 10
        mainTabelView?.separatorStyle = UITableViewCellSeparatorStyle.SingleLine //是否显示线条
        
        mainTabelView?.delegate = self
        mainTabelView?.dataSource = self
        
        self.view.addSubview(mainTabelView!)
    }
    
    //section个数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableData!.count
    }
    
    //每个section的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData![section].count
    }
    
    //计算每个cell高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section: [AnyObject]  =  self.tableData![indexPath.section] as! [AnyObject] //获取section里的对象
        let data = section[indexPath.row]
        let item =  data as! SendFindMyPetInfoModel
        let height  = item.view.frame.height
        
        return height
    }
    
    //每个cell内容
    let myText = UITextView()
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "InfoCell"
        let section : NSArray =  self.tableData![indexPath.section] as! NSArray
        let data = section[indexPath.row]
        let cell =  SendFindMyPetsInfoTableViewCell(data:data as! SendFindMyPetInfoModel, reuseIdentifier:cellId)
        cell.delegate = self
        
        if(indexPath.section != 0 || indexPath.row != 0){
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }else{
            cell.selectionStyle = .None  //不可点击
            
            //输入栏text
            myText.frame = CGRect(x: cell.frame.origin.x+20, y: cell.frame.origin.y+5, width: Width-25, height: 90)
            myText.font = sendPageInputTextFont
            myText.delegate = self
            cell.addSubview(myText)
        }
        
        return cell
    }
    
    //输入框改变额值,发送按钮就可点击了
    func textViewDidChange(textView: UITextView) {
        if textView.text == "" {
            self.navigationItem.rightBarButtonItem?.enabled = false
        }else{
            self.navigationItem.rightBarButtonItem?.enabled = true
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
    func passPhotos(selected: [ImageCollectionModel]) {
        images = [] //清空
        imagesHighQData = []
        for i in 0 ..< selected.count {
            
            //在列表页显示缩略图
            if selected.count == 1 {
                let image = UIImage(CGImage: selected[i].asset.aspectRatioThumbnail().takeRetainedValue())
                images.append(image)
            }else{
                let image = UIImage(CGImage: selected[i].asset.thumbnail().takeUnretainedValue())
                images.append(image)
            }
            
            //这里保存的高清图片
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),{
                //这里写需要放到子线程做的耗时的代码
                //如果该图片大于2M，会自动旋转90度；否则不旋转
                
                let representation =  selected[i].asset.defaultRepresentation()
                let imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
                let bufferSize = representation.getBytes(imageBuffer, fromOffset: Int64(0),
                    length: Int(representation.size()), error: nil)
                let data = NSData(bytesNoCopy: imageBuffer ,length: bufferSize, freeWhenDone: true)
                
//                let imageH = self.fixOrientation(UIImage(data: data)!)
                
//                dispatch_async(dispatch_get_main_queue(), {
                    self.imagesHighQData.append(data)
//                })
//            })
            
        }
        setReloadData(images)
    }
    
    //修正旋转
    func fixOrientation(aImage: UIImage) -> UIImage {
        
        if (aImage.imageOrientation == .Up) {
            
            return aImage
            
        }
        
        var transform = CGAffineTransformIdentity
        
        switch (aImage.imageOrientation) {
            
        case .Down, .DownMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height)
            
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
            
        case .Left, .LeftMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0)
            
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
            
        case .Right, .RightMirrored:
            
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height)
            
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
            
        default:
            
            break
            
        }
        
        switch (aImage.imageOrientation) {
            
        case .UpMirrored, .DownMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0)
            
            transform = CGAffineTransformScale(transform, -1, 1)
            
        case .LeftMirrored, .RightMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0)
            
            transform = CGAffineTransformScale(transform, -1, 1)
            
        default:
            
            break
            
        }
        
        let ctx = CGBitmapContextCreate(nil, Int(aImage.size.width), Int(aImage.size.height),
                                        
                                        CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                        
                                        CGImageGetColorSpace(aImage.CGImage),
                                        
                                        CGImageGetBitmapInfo(aImage.CGImage).rawValue)
        
        CGContextConcatCTM(ctx, transform)
        
        switch (aImage.imageOrientation) {
            
        case .Left, .LeftMirrored, .Right, .RightMirrored:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage)
            
        default:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage)
            
        }
        
        // And now we just create a new UIImage from the drawing context
        
        let cgimg = CGBitmapContextCreateImage(ctx)
        
        return UIImage(CGImage: cgimg!)
        
    }
    
    //设置数据
    func setReloadData(pics: [UIImage]){
        tableData = NSMutableArray()
        
        let tableOne = SendFindMyPetInfoModel(pics: pics)
        let tableOneTwo = SendFindMyPetInfoModel(name: "所在位置", lable: "", icon: "Location")
        let tableTwo = SendFindMyPetInfoModel(name: "谁可以看", lable: "公开", icon: "WhoCanSee")
        let tableTwoTwo = SendFindMyPetInfoModel(name: "提醒谁看", lable: "", icon: "MindWhoSee")
        
        tableData?.addObject([tableOne, tableOneTwo])
        tableData?.addObject([tableTwo, tableTwoTwo])
        
        mainTabelView?.reloadData()
        
        //有图片时，可点
        if tableOne.pics.count == 0{
            self.navigationItem.rightBarButtonItem?.enabled = false
        }else{
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    
    //选择了row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mainTabelView!.deselectRowAtIndexPath(indexPath, animated: true)  //被选择后，会变灰，这么做还原
        
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
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
