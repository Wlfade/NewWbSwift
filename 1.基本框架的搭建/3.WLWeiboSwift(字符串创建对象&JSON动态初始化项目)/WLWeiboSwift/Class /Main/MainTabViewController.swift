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
        
        //1.读取json文件路径
        
        guard let jsonPath = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil) else {
            print("没有获取到对应的文件路径")
            return
        }
        //2.读取json文件中的内容
        guard let jsonData = NSData(contentsOfFile: jsonPath) else{
            print("没有获取到json文件中数据")
            return
        }
        //3.将data 转成数组
        guard let anyObject = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) else {
            return
        }
        
        
        guard let dictArray = anyObject as? [[String : AnyObject]] else{
            return
        }
        //4.遍历字典，获取对应的信息
        for dict in dictArray {
            
            print(dict)

            //4.1 获取控制器的对应的字符串
            guard let vcName = dict["vcName"] as? String else{
                continue
            }
            
            //4.2 获取控制器显示的title
            guard let title = dict["title"] as? String else{
                continue
            }
            //4.3 获取控制器的图片名
            guard let imageName = dict["imageName"] as? String else{
                continue
            }
            
            addChildVC(childVCName: vcName, title: title, imageName: imageName)
        }
        
//        //1.首页子控制器
//        //2.添加控制器爱vVC
//        addChildVC(childVCName: "HomeViewController", title: "首页", imageName: "tabbar_home")
//        
//        //2.消息子控制器
//        addChildVC(childVCName: "MessageViewController", title: "消息", imageName: "tabbar_message_center")
//
//        addChildVC(childVCName: "DiscoverViewController", title: "发现", imageName: "tabbar_discover")
//
//        addChildVC(childVCName: "ProfileViewController", title: "我的", imageName: "tabbar_profile")
    }
}

extension MainTabViewController{
    ///添加子控制器
    // 方法的重载：方法名不同，但是参数不同， --> 1.参数的类型不同 2.参数的个数不同
    //private 在当前文件中可以访问，但是其他文件不能访问
    private func addChildVC(childVCName:String,title:String,imageName:String){

        //0.获取命名空间
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("没有获取命名空间")
            return
        }
        //1.根据字符串获取对应的Class
        guard let ChildVcClass = NSClassFromString(nameSpace + "." + childVCName) else {
            print("没有获取到字符串对应的class")
            return
        }
        //2.将对应的AnyObject转成控制器的类型
        guard let childVCType = ChildVcClass as? UIViewController.Type else {
            print("没有获取对应控制器的类型")
            return
        }
        
        //3.创建对应的控制器对象
        let childVC = childVCType.init()
        
         //2.设置子控制器的属性
        childVC.title = title
        childVC.tabBarItem.image = UIImage(named: imageName)
        childVC.tabBarItem.selectedImage = UIImage(named:imageName+"_highlighted" )
        //3.包装导航栏控制器
        let navVC = UINavigationController(rootViewController: childVC)

        addChild(navVC)
    }

}
