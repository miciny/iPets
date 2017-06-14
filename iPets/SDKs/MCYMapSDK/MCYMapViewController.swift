//
//  MCYMapViewController.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/14.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MCYMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var mainMapView: MKMapView!
    let locationManager: CLLocationManager = CLLocationManager() //定位管理器
    
    var longitude: Double?
    var latitude: Double?
    var altitude: Double?
    
    var getLocationAlready = false
    
    var currentLocationSpan: MKCoordinateSpan?  //地图的范围
    var objectAnnotation: MKPointAnnotation? //大头针
    
    var city: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpEle()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        realCity = self.city!
    }
    
    func setUpEle(){
        self.title = "地图"
        self.view.backgroundColor = UIColor.white
        
        
        //左上角联系人按钮按钮，一下方法添加图片，需要对图片进行遮罩处理，否则不会出现图片
        // 我们会发现出来的是一个纯色的图片，是因为iOS扁平化设计风格应用之后做成这样的，如果需要现实图片，我们可以设置一项
        var image = UIImage(named:"navigation_more")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let contectItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(setLocation))
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)  //用于消除左边空隙，要不然按钮顶不到最前面
        spacer.width = -5
        self.navigationItem.rightBarButtonItems = [spacer, contectItem]
        
        ////发送授权申请
        locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled()){
            //允许使用定位服务的话，开启定位服务更新
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            print("定位开始")
        }else{
            ToastView().showToast("请打开定位权限！")
        }
    }
    
    func setMap(){
        
        guard !self.getLocationAlready else {
            return
        }
        
        self.getLocationAlready = true
        
        var center = CLLocation()
        if latitude != nil {
            center = CLLocation(latitude: latitude!, longitude: longitude!)
        }else{
            center = CLLocation(latitude: 41.2233, longitude: 131.233)
        }
        
        self.mainMapView = MKMapView(frame: self.view.frame)
        self.mainMapView.delegate = self
        self.view.addSubview(self.mainMapView)
        
        //地图类型设置 - 标准地图
        self.mainMapView.mapType = MKMapType.standard
        
        //创建一个MKCoordinateSpan对象，设置地图的范围（越小越精确）
        let latDelta = 0.05
        let longDelta = 0.05
        currentLocationSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        //使用自定义位置
        let currentRegion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan!)
        
        //设置显示区域
        self.mainMapView.setRegion(currentRegion, animated: true)
        
        //创建一个大头针对象
        objectAnnotation = MKPointAnnotation()
        //设置大头针的显示位置
        objectAnnotation!.coordinate = center.coordinate
        
        self.setAnnotationTitle(center)
        //添加大头针
        self.mainMapView.addAnnotation(objectAnnotation!)
    }
    
    func setAnnotationTitle(_ coordinate: CLLocation){
        
        let mapData = MapFuncs()
        mapData.LonLatToCity(currLocation: coordinate) { 
            
            self.objectAnnotation!.title = mapData.Name
            //设置点击大头针之后显示的描述
            self.objectAnnotation!.subtitle = mapData.FormattedAddressLines
            
            self.city = mapData.city
        }
    }
    
    func setLocation(){
        guard latitude != nil else {
            ToastView().showToast("定位失败！")
            return
        }
        
        let center = CLLocation(latitude: latitude!, longitude: longitude!)
        let currentRegion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan!)
        
        //设置显示区域
        self.mainMapView.setRegion(currentRegion, animated: true)
        
        objectAnnotation?.coordinate = center.coordinate
    }
    
    //更新用户的位置
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    
    //地图缩放级别发送改变时
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
    }
    
    
    //自定义大头针样式
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)
        -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let reuserId = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuserId)
                as? MKPinAnnotationView
            if pinView == nil {
                //创建一个大头针视图
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuserId)
                pinView?.canShowCallout = true
                pinView?.animatesDrop = true
                //设置大头针颜色
                pinView?.pinTintColor = UIColor.green
                //设置大头针点击注释视图的右侧按钮样式
                pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }else{
                pinView?.annotation = annotation
            }
            
            return pinView
    }
    
    
    //定位改变执行，可以得到新位置、旧位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        let currLocation: CLLocation = locations.last!
        
        longitude = currLocation.coordinate.longitude
        //获取纬度
        latitude = currLocation.coordinate.latitude
        //获取海拔
        altitude = currLocation.altitude
        
        self.setMap()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
