//
//  AppDelegate.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/19.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //设置全局颜色
        UITabBar.appearance().tintColor = UIColor.orange
        
        // 创建Window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabViewController();
        window?.makeKeyAndVisible()
        return true
    }

}

