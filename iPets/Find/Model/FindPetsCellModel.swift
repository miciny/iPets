//
//  CellModel.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/3.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class FindPetsCellModel: NSObject {
    var name: String
    var nickname: String
    var text: String?
    var picture: [String]?
    var date: Date
    
    init(name: String, text: String?, picture: [String]?, date: Date, nickname: String){
        self.text = text
        self.name = name //
        self.date = date //
        self.picture = picture
        self.nickname = nickname
    }
    
    //从nsobject解析回来
    init(coder aDecoder:NSCoder!){
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.text = aDecoder.decodeObject(forKey: "text") as? String
        self.picture = aDecoder.decodeObject(forKey: "picture") as? [String]
        self.date = aDecoder.decodeObject(forKey: "date") as! Date
        self.nickname = aDecoder.decodeObject(forKey: "nickname") as! String
    }
    
    //编码成object
    func encodeWithCoder(_ aCoder:NSCoder!){
        aCoder.encode(name,forKey:"name")
        aCoder.encode(text,forKey:"text")
        aCoder.encode(picture,forKey:"picture")
        aCoder.encode(date,forKey:"date")
        aCoder.encode(nickname,forKey:"nickname")
    }
}
