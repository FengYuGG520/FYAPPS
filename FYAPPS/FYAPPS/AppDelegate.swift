//
//  AppDelegate.swift
//  FYAPPS
//
//  Created by FengYu on 2017/9/15.
//  Copyright © 2017年 FengYu. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        FYFPS.sharedFPSIndicator().show()
        
        window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        
        return true
    }
    

    func applicationWillTerminate(_ application: UIApplication) {
        // 当应用程序即将终止时调用。如果适当的保存数据。看到也applicationDidEnterBackground:。
        // 在应用程序终止之前，保存应用程序管理对象上下文中的更改。
        self.saveContext()
    }

    // MARK: - 核心数据堆栈

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         应用程序的持久容器。这个实现
         创建并返回一个容器，为该容器加载了存储
         应用程序。这个属性是可选的，因为它是合法的
         错误条件可能导致商店的创建失败。
        */
        let container = NSPersistentContainer(name: "FYAPPS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // 用代码替换该实现，以适当地处理错误。
                // fatalError()导致应用程序生成崩溃日志并终止。您不应该在一个应用程序中使用这个函数，尽管它在开发过程中可能很有用。
                 
                /*
                 这里出现错误的典型原因包括:
                 * 父目录不存在，不能创建，也不允许写。
                 * 持久存储是不可访问的，因为当设备被锁定时，权限或数据保护是不可访问的。
                 * 这个装置是空的。
                 * 该存储不能迁移到当前的模型版本。
                 检查错误消息以确定实际问题是什么。
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - 核心数据储蓄支持

    func saveContext () {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // 用代码替换该实现，以适当地处理错误。
                    // fatalError()导致应用程序生成崩溃日志并终止。您不应该在一个应用程序中使用这个函数，尽管它在开发过程中可能很有用。
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        } else {
            // 在早期版本回退
        }
        
    }

}

