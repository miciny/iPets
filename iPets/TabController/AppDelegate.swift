//
//  AppDelegate.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import CoreData
import XCGLogger

let logger = XCGLogger.default

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        //Override point for customization after application launch.
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()
        let vc = TabbarViewController()
        self.window!.rootViewController = vc
        
        //创建默认头像
        setDefaultData()
        
        //3d touch
        configShortCutItems()
        
        //开启通知
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        
        //日志
        logger.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: "path/to/file", fileLevel: .debug)

        return true
    }
    
    
    // 创建默认头像
    func setDefaultData() {
        
        //从CoreData里读取数据
        let dataArray = SQLLine.SelectAllData(entityNameOfContectors)
        
        if(dataArray.count == 0){
            //存储到CoreData里
            
            let defaultIcon = UIImage(named: "defaultIcon")
            let defaultIconData = UIImagePNGRepresentation(defaultIcon!)
            
            if SQLLine.InsertContectorsData("毛彩元", icon: defaultIconData!, nickname: myNikename, sex: "男", remark: "my heart is yours", address: "北京", http: "www.baidu.com"){
                logger.info("创建默认用户成功！")
            }else{
                logger.info("创建默认头像失败！")
            }
        }
        
        //一开始就获取，不然真是坑，没取一次icon，内存就会增加一点，也没有释放掉
        myInfo = GetInfo.getMyInfo()
    }
    
//=====================================3d touch======================================
    func configShortCutItems(){
        //动态添加方式
        
        var icon1 = UIApplicationShortcutIcon(type: .add)
        if #available(iOS 9.1, *) {
            icon1 = UIApplicationShortcutIcon(type: .cloud)
        }
        let item1 = UIMutableApplicationShortcutItem(type: "weather", localizedTitle: "天气", localizedSubtitle: "查看本地天气", icon: icon1, userInfo: nil)
        
        
        let icon2 = UIApplicationShortcutIcon(type: .share)
        let item2 = UIMutableApplicationShortcutItem(type: "share", localizedTitle: "分享", localizedSubtitle: "分享我的爱宠", icon: icon2, userInfo: nil)
        
        
        let icon3 = UIApplicationShortcutIcon(templateImageName: "shareIcon")
        let item3 = UIMutableApplicationShortcutItem(type: "999", localizedTitle: "自定义", localizedSubtitle: nil, icon: icon3, userInfo: nil)
        UIApplication.shared.shortcutItems = [item1,item2,item3]
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        switch shortcutItem.type {
        case "share":
            let items = ["hello 3D Touch"]
            let activityVC = UIActivityViewController(
                activityItems: items,
                applicationActivities: nil)
            self.window?.rootViewController?.present(activityVC, animated: true, completion: nil)
            
        case "weather":
            let vc = WeatherViewController()
            self.window?.rootViewController?.present(vc, animated: true, completion: nil)
            
        default:
            break
        }
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //进入后台，暂停播放
        if videoPlayer.isPlayed == true && videoPlayer.isPlaying == true{
            videoPlayer.pause()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.maocaiyuan.ControlYourMoney" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "iPets", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }



}

