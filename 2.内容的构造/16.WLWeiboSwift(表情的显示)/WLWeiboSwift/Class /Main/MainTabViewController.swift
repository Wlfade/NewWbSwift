//
//  MainTabViewController.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/19.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    
    //便利构造函数创建
    private lazy var composeBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setComposeBtn()
    }
}
//MARK:- 设置UI界面
extension MainTabViewController{
    /// 设置发布按钮
    private func setComposeBtn(){
        //1.将composeBtn 添加到 tabbar 中
        tabBar.addSubview(composeBtn)
        
        composeBtn.sizeToFit()
        //2.设置位置
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        
        //3.监听按钮的点击事件
        //无传参
        composeBtn.addTarget(self, action: #selector(composeBtnClick), for: .touchUpInside)
        
        //有传参
//        composeBtn.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)

    }
}

//MARK:- 事件的监听
extension MainTabViewController{
    @objc private func composeBtnClick(){
        print("发布按钮点击1")
        let composVC = ComposeViewController()
        
        let composeNav = UINavigationController(rootViewController: composVC)
        composeNav.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        present(composeNav, animated: true, completion: nil)
    }

    @objc func tapped(_ sender:UIButton){
        print("发布按钮点击2")
        sender.isHighlighted = !sender.isHighlighted
    }

}
