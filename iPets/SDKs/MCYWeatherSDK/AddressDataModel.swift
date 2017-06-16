//
//  AddressDataModel.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/15.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class AddressDataModel: NSObject {

    var cityCode: String!         //
    var cityID: String!         //
    var parentID: String!      //
    var cityName: String!         //
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.cityCode, forKey: "cityCode")
        aCoder.encode(self.cityID, forKey: "cityID")
        aCoder.encode(self.parentID, forKey: "parentID")
        aCoder.encode(self.cityName, forKey: "cityName")
    }
    
    init(cityCode: String, cityID: String, parentID: String, cityName: String){
        self.cityCode = cityCode
        self.cityID = cityID
        self.parentID = parentID
        self.cityName = cityName
        super.init()
    }
    
    //从nsobject解析回来
    required init(coder aDecoder: NSCoder){
        
        self.cityCode = aDecoder.decodeObject(forKey: "cityCode") as! String
        self.cityID = aDecoder.decodeObject(forKey: "cityID") as! String
        self.parentID = aDecoder.decodeObject(forKey: "parentID") as! String
        self.cityName = aDecoder.decodeObject(forKey: "cityName") as! String
        super.init()
    }

}
