import Foundation
import UIKit

/*
 用户信息类
*/
class UserInfo: NSObject{
    
    var username: String?
    var icon: UIImage?
    var nickname: String?
    
    init(name: String?, icon: UIImage?, nickname: String?){
        self.username = name
        self.icon = icon
        self.nickname = nickname
    }
}
