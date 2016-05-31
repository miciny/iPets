//
//  ImageCollectionViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/29.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import AssetsLibrary

class ImageCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    private var assetsLibrary: ALAssetsLibrary! //资源库管理类
    private var assetsImage = [ImageCollectionModel]()//保存照片集合
    private let imageCellReuseIdentifier = "imageCollectionCell"
    private var collectionView : UICollectionView?
    private var imageCollectionModel: ImageCollectionModel!
    private var count = Int() //选择数量
    private var selectedImage: [ImageCollectionModel] = []//选择的图片合集
    private var currentAlbum:ALAssetsGroup?
    
    var pageTitle: String? //右上角的按钮文案，完成或者发送
    var photoDelegate: PassPhotosDelegate! //返回时的代理
    var countLimited = 9 //照片限制，可是设置，默认为9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        getGroupList()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpEles(){
        self.title = "请选择图片"                           //页面title和底部title
        self.view.backgroundColor = UIColor.whiteColor() //背景色
        
        //取消按钮
        let leftBarBtn = UIBarButtonItem(title: "取消", style: .Plain, target: self,
                                         action: #selector(ImageCollectionViewController.backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        //保存按钮
        let rightBarBtn = UIBarButtonItem(title: pageTitle, style: .Plain, target: self,
                                              action: #selector(ImageCollectionViewController.sendPics))
        self.navigationItem.rightBarButtonItem = rightBarBtn
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        //collection
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRectMake(5, 5, Width-10, Height-10), collectionViewLayout: layout)
        
        //注册一个cell
        collectionView!.registerClass(ImageCollectionViewCell.self, forCellWithReuseIdentifier:imageCellReuseIdentifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.clearColor()
        
        //设置每一个cell的宽高
        layout.itemSize = CGSizeMake((Width)/4-6, (Width)/4-6)
        layout.minimumLineSpacing = 2 //上下间隔
        layout.minimumInteritemSpacing = 2 //左右间隔
        
        self.view.addSubview(collectionView!)
        
    }
    
    //这个地方有点坑，因为获取图片是异步的，没法儿获取到图片之后刷新页面，只能单列方法
//    推出界面还报错，不知道啥原因
///////////////////////////////////////////////////// 很好的获取图片的方法
    func getGroupList(){
        let listGroupBlock:ALAssetsLibraryGroupsEnumerationResultsBlock = {(group,stop)->Void in
            let  onlyPhotosFilter = ALAssetsFilter.allPhotos()  //获取所有图
            if let group=group{
                group.setAssetsFilter(onlyPhotosFilter)
                if group.numberOfAssets() > 0{
                    self.showPhoto(group)
                }else{
                    
                }
            }
        }
        getAssetsLibrary().enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: listGroupBlock, failureBlock: nil)
    }
    
    
    func getAssetsLibrary()->ALAssetsLibrary{
        struct Singleton{
            static var onceToken : dispatch_once_t = 0
            static var single:ALAssetsLibrary?
        }
        dispatch_once(&Singleton.onceToken,{
            Singleton.single=ALAssetsLibrary()
        })
        return Singleton.single!
        
    }
    
    func showPhoto(photos:ALAssetsGroup){
        
        if (currentAlbum == nil || currentAlbum?.valueForProperty(ALAssetsGroupPropertyName).isEqualToString(photos.valueForProperty(ALAssetsGroupPropertyName) as! String) != nil){
            
            self.currentAlbum = photos
            let assetsEnumerationBlock:ALAssetsGroupEnumerationResultsBlock = { (result,index,stop) in
                
                if (result != nil) {
                    self.imageCollectionModel = ImageCollectionModel()
                    self.imageCollectionModel.asset = result
                    self.imageCollectionModel.isSelect = false
                    self.assetsImage.append(self.imageCollectionModel)
                    self.collectionView!.reloadData()
                    self.assetsLibrary = nil
                    self.currentAlbum = nil
                }else{
                    
                }
            }
            let  onlyPhotosFilter = ALAssetsFilter.allPhotos()
            self.currentAlbum?.setAssetsFilter(onlyPhotosFilter)
            self.currentAlbum?.enumerateAssetsUsingBlock(assetsEnumerationBlock)
        }
        
    }

/////////////////////////////////////////////////////
    
    
    //返回
    func backToPrevious() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //发送图片，聊天页
    func sendPics(){
        selectedImage = []
        for  item in assetsImage{
            if item.isSelect {
                selectedImage.append(item)
            }
        }
        photoDelegate?.passPhotos(selectedImage)
        backToPrevious()
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return assetsImage.count
    }
    
    //collection的内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCellWithReuseIdentifier(imageCellReuseIdentifier, forIndexPath: indexPath) as! ImageCollectionViewCell
        cell.update(assetsImage[indexPath.row])
        
        //这种方法？？？
        cell.handleSelect={
            cell.isSelect = !cell.isSelect
            
            if !cell.isSelect{
                //显示已选择的标志
                cell.isCheck(cell.isSelect)
                
                if(self.count > 0){
                    self.count -= 1
                }
                self.assetsImage[indexPath.row].isSelect = false
                
            }else{
                //小于控制的数量
                if(self.count < self.countLimited){
                    //显示已选择的标志
                    cell.isCheck(cell.isSelect)
                    
                    self.count += 1
                    self.assetsImage[indexPath.row].isSelect = true
                }else{
                    let toast = ToastView()
                    toast.showToast("最多选择\(self.countLimited)张图片")
                    self.assetsImage[indexPath.row].isSelect = false
                    cell.isSelect = !cell.isSelect
                }
            }
            
            if(self.count > 0){
                self.title = "已选择\(self.count)张图片"
                self.navigationItem.rightBarButtonItem?.enabled = true
            }else{
                self.title = "请选择图片"
                self.navigationItem.rightBarButtonItem?.enabled = false
            }
        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
