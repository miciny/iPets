//
//  Protocol.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/25.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

//Protocol单独用一个文件来创建，尽量不要与相关类混在一个文件中。
import Foundation
import UIKit

//底部菜单的代理
protocol bottomMenuViewDelegate{
    func buttonClicked(_ tag: Int, eventFlag: Int)
}

//自动滑动图的代理
@objc protocol MCYAutoScrollViewDelegate: NSObjectProtocol{
    func numbersOfPages()->Int
    func imageNameOfIndex(_ index: Int) -> String!
    @objc optional func didSelectedIndex(_ index: Int)
    @objc optional func currentIndexDidChange(_ index: Int)
}

//发送图片，选择多张图片的协议
protocol PassPhotosDelegate{
    func passPhotos(_ selected: [ImageCollectionModel])
}

//点击头图的协议
protocol SellBuyHeaderDelegate {
    func selectedPic(_ str: String)
}

/*
 数据提供协议
 */
protocol ChatDataSource{
    func rowsForChatTable( _ tableView: ChatTableView) -> Int
    func chatTableView(_ tableView: ChatTableView, dataForRow:Int)-> MessageItem
}
