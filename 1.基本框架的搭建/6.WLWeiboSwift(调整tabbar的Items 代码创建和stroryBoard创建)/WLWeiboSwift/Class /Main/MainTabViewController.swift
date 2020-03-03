//
//  MainTabViewController.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/19.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    //MARK:- 懒加载属性
    private lazy var imageNames = ["tabbar_home","tabbar_message_center","","tabbar_discover","tabbar_profile"]
    
    private lazy var composeBtn : UIButton = UIButton()

    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setComposeBtn()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setupTabbarItems()
    }
}
//MARK:- 设置UI界面
extension MainTabViewController{
    /// 设置发布按钮
    private func setComposeBtn(){
        //1.将composeBtn 添加到 tabbar 中
        tabBar.addSubview(composeBtn)
        //2.设置属性
        composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: .normal)
        composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: .highlighted)
        composeBtn.setImage(UIImage(named: "tabbar_compose_icon_add"), for: .normal)
        composeBtn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
        
        composeBtn.sizeToFit()
        //3.设置位置
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
    }
    ///调整tabbar的items
    private func setupTabbarItems(){
        //1. 遍历所有的item
        for i in 0..<tabBar.items!.count {
            //2.获取item
            let item = tabBar.items![i]
            
            //3.如果下标值为2，则该item不可以和用户交互
            if i == 2{
                item.isEnabled = false
            }
            
            //4.设置其他item的选中时候的图片
            item.selectedImage = UIImage(named: imageNames[i]+"_highlighted")
        }
    }
}
