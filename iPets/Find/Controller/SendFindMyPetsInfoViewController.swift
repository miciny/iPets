//
//  SendFindMyPetsInfoViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/30.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Photos

class SendFindMyPetsInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SendFindMyPetsInfoCellViewDelegate, PassPhotosDelegate, UITextViewDelegate{
    
    var images = [UIImage]() //保存选择的图片的缩略图
    
    fileprivate var mainTabelView: UITableView? //整个table
    fileprivate var tableData : NSMutableArray? //数据
    
    fileprivate let timer = MyTimer()
    fileprivate var picIndex = 0
    fileprivate var selectedModel = [ImageCollectionModel]()

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
                                         action: #selector(self.backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        //发送按钮
        let rightBarBtn = UIBarButtonItem(title: "发送", style: .plain, target: self,
                                          action: #selector(self.sendFindMyPetsInfo))
        rightBarBtn.tintColor = getMainColor()
        self.navigationItem.rightBarButtonItem = rightBarBtn
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    
    //返回
    func backToPrevious() {
        if let vc = findPetsViewController{
            vc.refresh = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func savePic(){
        timer.pauseTimer()
        //在列表页显示缩略图
        let asset = selectedModel[picIndex].asset!
        getThumbnailImage(asset: asset, imageResult: { (image) in
            self.images.append(image)
            
            self.picIndex += 1
            if self.picIndex >= self.selectedModel.count{
                self.setReloadData(self.images)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.timer.stopTimer()
            }else{
                self.timer.startTimer(interval: 0)
            }
        })
    }

    //发送
    func sendFindMyPetsInfo(){
        let waitView = WaitView()
        waitView.showWait("发布中")
        
        let textStr = (self.myText.text != "") ? self.myText.text : nil
        
        globalQueue.async(execute: {
            let time = Date()
            //提取原来的寻宠数据
            let findMyPetsData = SaveDataModel()
            var oldData = findMyPetsData.loadFindMyPetsDataFromTempDirectory()
            
            if self.selectedModel.count > 0{
                
                let timeStr = DateToToString.dateToStringBySelf(time, format: "yyyyMMddHHmmss")
                //保存图片到本地沙盒
                let saveCache = SaveCacheDataModel()
                var nameArray = [String]() //保存名字数组
                
                for j in 0 ..<  self.selectedModel.count{
                    
                    //保存高清图
                    let asset = self.selectedModel[j].asset!
                    getRetainImage(asset: asset, imageResult: { (image) in
                        if saveCache.savaImageToFindPetsCacheDir(image, imageName: "H\(timeStr)\(j).png"){
                            log.info("保存高清图缓存成功！")
                        }else{
                            log.info("保存高清图缓存失败！")
                        }
                    })
                    
                    //保存普清图
                    if saveCache.savaImageToFindPetsCacheDir(self.images[j], imageName: "\(timeStr)\(j).png"){
                       log.info("保存普通图缓存成功！")
                    }else{
                        log.info("保存普通图缓存失败！")
                    }
                    
                    nameArray.append("\(timeStr)\(j).png")
                }
                
                let myFindPetsInfo = FindPetsCellModel(name: myInfo.username!, text: textStr, picture: nameArray, date: time, nickname: myInfo.nickname!, video: nil, from: .me)
                oldData.append(myFindPetsInfo)
            }else{
                let myFindPetsInfo = FindPetsCellModel(name: myInfo.username!, text: textStr, picture: nil, date: time, nickname: myInfo.nickname!, video: nil, from: .me)
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
        
        let tableOne = SendFindMyPetsInfoModel(pics: [])
        let tableOneTwo = SendFindMyPetsInfoModel(name: "所在位置", lable: "", icon: "Location")
        let tableTwo = SendFindMyPetsInfoModel(name: "谁可以看", lable: "公开", icon: "WhoCanSee")
        let tableTwoTwo = SendFindMyPetsInfoModel(name: "提醒谁看", lable: "", icon: "MindWhoSee")
        
        tableData?.add([tableOne, tableOneTwo])
        tableData?.add([tableTwo, tableTwoTwo])
        
        mainTabelView?.reloadData()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
//================================设置tableView
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
        let section: [AnyObject] = self.tableData![indexPath.section] as! [AnyObject] //获取section里的对象
        let data = section[indexPath.row]
        let item =  data as! SendFindMyPetsInfoModel
        let height  = item.height
        
        return height
    }
    
    //每个cell内容
    let myText = UITextView()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "InfoCell"
        let section : NSArray =  self.tableData![indexPath.section] as! NSArray
        let data = section[indexPath.row]
        let cell =  SendFindMyPetsInfoTableViewCell(data:data as! SendFindMyPetsInfoModel, reuseIdentifier:cellId)
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
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        images = [] //清空
        picIndex = 0
        selectedModel = selected
        timer.setTimer(interval: 0, target: self, selector: #selector(self.savePic), repeats: true)
    }
    
    //设置数据
    func setReloadData(_ pics: [UIImage]){
        let origin = (tableData!.firstObject as! [SendFindMyPetsInfoModel])[0]
        let data = SendFindMyPetsInfoModel(pics: pics)
        origin.pics = pics
        origin.height = data.height
        
        mainTabelView?.reloadData()
        
        //有图片时，可点
        if pics.count == 0{
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
