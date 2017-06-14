//
//  MapFuncs.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/14.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import Foundation
import MapKit

class MapFuncs: NSObject {
    
    var city: String?
    var country: String?
    var CountryCode: String?
    var FormattedAddressLines: String?
    var Name: String?
    var State: String?
    var SubLocality: String?
    
    func LonLatToCity(currLocation: CLLocation, complete: @escaping ()->()) {
        
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currLocation) { (placemark, error) -> Void in
            
            if error == nil {
                
                let array = placemark! as NSArray
                let mark = array.firstObject as! CLPlacemark
                
                //这个是城市
                self.city = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as? String
                
                //这个是国家
                self.country = (mark.addressDictionary! as NSDictionary).value(forKey: "Country") as? String
                
                //这个是国家的编码
                self.CountryCode = (mark.addressDictionary! as NSDictionary).value(forKey: "CountryCode") as? String
                
                //这是 具体位置
                self.FormattedAddressLines = ((mark.addressDictionary! as NSDictionary).value(forKey: "FormattedAddressLines") as AnyObject).firstObject as? String
                
                //这是 街道位置
                self.Name = (mark.addressDictionary! as NSDictionary).value(forKey: "Name") as? String
                
                //这是省
                self.State = (mark.addressDictionary! as NSDictionary).value(forKey: "State") as? String
                
                //这是区
                self.SubLocality = (mark.addressDictionary! as NSDictionary).value(forKey: "SubLocality") as? String
                
                //去掉省 市
                self.State = self.State!.replacingOccurrences(of: "省", with: "")
                self.city = self.city!.replacingOccurrences(of: "市", with: "")
                
                complete()
                
            }else{
                print(error ?? "Error Nothing")
            }
        }
    }
}
