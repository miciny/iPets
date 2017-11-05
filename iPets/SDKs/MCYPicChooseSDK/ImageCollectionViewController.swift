//
//  ImageCollectionViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/29.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Photos


//发送图片，选择多张图片的协议
protocol PassPhotosDelegate{
    func passPhotos(_ selected: [ImageCollectionModel])
}


class ImageCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    fileprivate var assetsLibrary: PHPhotoLibrary! //资源库管理类
    fileprivate var assetsImage = [ImageCollectionModel]()//保存照片集合
    fileprivate let imageCellReuseIdentifier = "imageCollectionCell"
    fileprivate var collectionView : UICollectionView?
    fileprivate var count = Int() //选择数量
    fileprivate var selectedImage: [ImageCollectionModel] = []//选择的图片合集
    fileprivate var currentAlbum: PHAssetCollection?
    //  数据源
    fileprivate var photosArray = PHFetchResult<PHAsset>()
    
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
        self.view.backgroundColor = UIColor.white //背景色
        
        //取消按钮
        let leftBarBtn = UIBarButtonItem(title: "取消", style: .plain, target: self,
                                         action: #selector(self.backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        //保存按钮
        let rightBarBtn = UIBarButtonItem(title: pageTitle, style: .plain, target: self,
                                              action: #selector(self.sendPics))
        self.navigationItem.rightBarButtonItem = rightBarBtn
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        //collection
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(x: 5, y: 5, width: Width-10, height: Height-10), collectionViewLayout: layout)
        //注册一个cell
        collectionView!.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier:imageCellReuseIdentifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.clear
        
        //设置每一个cell的宽高
        layout.itemSize = CGSize(width: (Width)/4-6, height: (Width)/4-6)
        layout.minimumLineSpacing = 2 //上下间隔
        layout.minimumInteritemSpacing = 2 //左右间隔
        
        self.view.addSubview(collectionView!)
        
    }
    
    //这个地方有点坑，因为获取图片是异步的，没法儿获取到图片之后刷新页面，只能单列方法
//    推出界面还报错，不知道啥原因
///////////////////////////////////////////////////// 很好的获取图片的方法
    //  MARK:- 获取全部图片
    private func getAllPhotos() {
        
        //则获取所有资源
        let allPhotosOptions = PHFetchOptions()
        //按照创建时间倒序排列
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                             ascending: false)]
        //只获取图片
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                 PHAssetMediaType.image.rawValue)
        let assetsFetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image,
                                                              options: allPhotosOptions)
        photosArray = assetsFetchResults
    }
    
    //  PHPhotoLibraryChangeObserver  第一次获取相册信息，这个方法只会进入一次
    func photoLibraryDidChange(changeInstance: PHChange) {
        getAllPhotos()
    }
    
    //获取所有图片
    func getGroupList(){
        
        self.getAllPhotos()
        
        guard photosArray.count > 0 else {
            return
        }
        
        let myQueue = DispatchQueue(label: "myQueue")  //
        myQueue.async {
            for i in 0 ..< self.photosArray.count {
                
                let imageCollectionModel = ImageCollectionModel()
                imageCollectionModel.asset = self.photosArray[i]
                imageCollectionModel.isSelect = false
                self.assetsImage.append(imageCollectionModel)
            }
            mainQueue.async {
                self.collectionView!.reloadData()
                self.assetsLibrary = nil
                self.currentAlbum = nil
            }
        }
    }

/////////////////////////////////////////////////////
    
    
    //返回
    @objc func backToPrevious() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //发送图片，聊天页
    @objc func sendPics(){
        selectedImage = []
        for item in assetsImage{
            if item.isSelect {
                selectedImage.append(item)
            }
        }
        photoDelegate?.passPhotos(selectedImage)
        backToPrevious()
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return assetsImage.count
    }
    
    //collection的内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellReuseIdentifier, for: indexPath) as! ImageCollectionViewCell
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
                    ToastView().showToast("最多选择\(self.countLimited)张图片")
                    self.assetsImage[indexPath.row].isSelect = false
                    cell.isSelect = !cell.isSelect
                }
            }
            
            if(self.count > 0){
                self.title = "已选择\(self.count)张图片"
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }else{
                self.title = "请选择图片"
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
