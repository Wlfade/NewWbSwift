//
//  MainTabViewController.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/19.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //1.首页子控制器
        //2.添加控制器爱vVC
        addChild(addChildVC(childVC: HomeViewController(), title: "首页", imageName: "tabbar_home", selectedImageName: "tabbar_home_highlighted"))
        
        //2.消息子控制器
        addChild(addChildVC(childVC: MessageViewController(), title: "消息", imageName: "tabbar_message_center", selectedImageName: "tabbar_message_center_highlighted"))

        addChild(addChildVC(childVC: DiscoverViewController(), title: "发现", imageName: "tabbar_discover", selectedImageName: "tabbar_discover_highlighted"))

        addChild(addChildVC(childVC: ProfileViewController(), title: "我的", imageName: "tabbar_profile", selectedImageName: "tabbar_profile_highlighted"))
    }
}

extension MainTabViewController{
    ///添加子控制器
    // 方法的重载：方法名不同，但是参数不同， --> 1.参数的类型不同 2.参数的个数不同
    //private 在当前文件中可以访问，但是其他文件不能访问
    private func addChildVC(childVC:UITableViewController,title:String,imageName:String,selectedImageName:String) -> UINavigationController {
         //2.设置子控制器的属性
        childVC.title = title
        childVC.tabBarItem.image = UIImage(named: imageName)
        childVC.tabBarItem.selectedImage = UIImage(named: selectedImageName)
        //3.包装导航栏控制器
        let navVC = UINavigationController(rootViewController: childVC)
        return navVC
        
    }

}
