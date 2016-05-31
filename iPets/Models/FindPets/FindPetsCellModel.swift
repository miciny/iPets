//
//  CellModel.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/3.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class FindPetsCellModel: NSObject {
    var name : String
    var nickname : String
    var text : String
    var picture : [String]?
    var date : NSDate
    
    init(name: String, text: String, picture: [String]?, date: NSDate, nickname: String){
        self.text = text
        self.name = name //
        self.date = date //
        self.picture = picture
        self.nickname = nickname
    }
    
    //从nsobject解析回来
    init(coder aDecoder:NSCoder!){
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.text = aDecoder.decodeObjectForKey("text") as! String
        self.picture = aDecoder.decodeObjectForKey("picture") as? [String]
        self.date = aDecoder.decodeObjectForKey("date") as! NSDate
        self.nickname = aDecoder.decodeObjectForKey("nickname") as! String
    }
    
    //编码成object
    func encodeWithCoder(aCoder:NSCoder!){
        aCoder.encodeObject(name,forKey:"name")
        aCoder.encodeObject(text,forKey:"text")
        aCoder.encodeObject(picture,forKey:"picture")
        aCoder.encodeObject(date,forKey:"date")
        aCoder.encodeObject(nickname,forKey:"nickname")
    }
}
