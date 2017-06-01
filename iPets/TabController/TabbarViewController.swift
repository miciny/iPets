//
//  tabbarViewController.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/3.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

//系统自带的tabbar
import UIKit

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        initTabbarItem()
        // Do any additional setup after loading the view.
    }
    
   func initTabbarItem(){
    
    //添加第一个试图，主页，主要展示卖宠物的和宠物周边商品
    let firstVC = SellBuyViewController()
    let firstNav = UINavigationController(rootViewController: firstVC)
    firstNav.tabBarItem.title = "首页"
    firstNav.tabBarItem.image=UIImage(named: "SellBuy")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)         //设置工具栏选中前的图片
    firstNav.tabBarItem.selectedImage=UIImage(named: "SellBuy_Selected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal) //设置工具栏选中后的图片
    
    //添加第二个试图，联系人，主要好友联系人
    let secVC = MainChatListViewController()
    let secNav = UINavigationController(rootViewController: secVC)
    secNav.tabBarItem.title = "聊天"
    secNav.tabBarItem.image=UIImage(named: "Chat")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    secNav.tabBarItem.selectedImage=UIImage(named: "Chat_Selected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    
    //添加第三个试图，寻宠页，发布或者收看所有当地的寻宠消息
    let thirdVC = FindPetsViewController()
    let thirdNav = UINavigationController(rootViewController: thirdVC)
    thirdNav.tabBarItem.title = "寻宠"
    thirdNav.tabBarItem.image=UIImage(named: "Find")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    thirdNav.tabBarItem.selectedImage=UIImage(named: "Find_Selected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    
    //添加第四个试图，一些个人设置
    let fourthVC = MeViewController()
    let fouthNav = UINavigationController(rootViewController: fourthVC)
    fouthNav.tabBarItem.title = "我"
    fouthNav.tabBarItem.image=UIImage(named: "Me")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    fouthNav.tabBarItem.selectedImage=UIImage(named: "Me_Selected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    
    self.viewControllers = [firstNav,secNav,thirdNav,fouthNav]            //添加至tab
    
    //底部工具栏背景颜色，
    self.tabBar.barTintColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 0.5)
    
    //设置底部工具栏文字颜色（默认状态和选中状态）
    UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(object:UIColor.black, forKey:NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for:UIControlState());
    UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(object: getMainColor(), forKey:NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for:UIControlState.selected)
    
    //导航栏颜色
    UINavigationBar.appearance().barTintColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1.0)
    UINavigationBar.appearance().tintColor = UIColor.white  //导航栏左右按钮文字颜色
    UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: pageTitleFont, NSForegroundColorAttributeName: UIColor.white] //导航栏title文字颜色
    
    self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    /**
     设置状态栏风格,系统栏白色文字 info中 View controller-based status bar appearance设置为no才能用
     */
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func setNeedsStatusBarAppearanceUpdate() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
