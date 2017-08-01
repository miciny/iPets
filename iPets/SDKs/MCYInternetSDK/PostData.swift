//
//  PostData.swift
//  iPets
//
//  Created by maocaiyuan on 2017/7/4.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import Foundation

import UIKit
import Alamofire

class PostData: NSObject {
    //post用户信息数据到db
//    class func postUserInfoToDB(_ str: String, url: URL){
//        
//        let paras = [
//            "data": strToJson(str)
//        ]
//        
//        let manager = NetFuncs.getDefaultAlamofireManager()
//        
//        manager.request(.POST, url, parameters: paras, encoding: .JSON)
//            .responseJSON { response in
//                
//                switch response.result{
//                case .Success:
//                    let code = String((response.response?.statusCode)!)
//                    
//                    if code == "200"{
//                        User.updateuserData(0, changeValue: false, changeFieldName: userNameOfChanged)
//                        logger.info("上传用户信息成功！")
//                    }else{
//                        let str = getErrorCodeToString(code)
//                        MyToastView().showToast("\(str)")
//                    }
//                    
//                case .Failure:
//                    NetWork.networkFailed(response.response)
//                }
//        }
//    }
    
    //post user icon
    //
//    class func postUserIconToDB(_ imagePath: String){
//        let data = ""
//        let iconURL = URL(fileURLWithPath: imagePath)
//        let url = ""
//        
//        //上传图片
//        let manager = NetFuncs.getDefaultAlamofireManager()
//        
//        manager.upload(.POST, url, multipartFormData: { (multipartFormData) in
//            multipartFormData.appendBodyPart(fileURL: iconURL, name: "ss")
//        }) { encodingResult in
//            switch encodingResult {
//            case .Success(let upload, _, _ ):
//                upload.responseJSON {
//                    response in
//                    //成功
//                    switch response.result{
//                    case .Success:
//                        let code = String((response.response?.statusCode)!)
//                        
//                        if code == "200"{
//                            logger.info("上传用户头像成功！")
//                        }else{
//                            let str = getErrorCodeToString(code)
//                            MyToastView().showToast("\(str)")
//                        }
//                        
//                    case .Failure:
//                        NetWork.networkFailed(response.response)
//                    }
//                }
//                
//            case .Failure(let encodingError):
//                logger.info("Failure")
//                logger.info(encodingError)
//            }
//        }
//    }
}
