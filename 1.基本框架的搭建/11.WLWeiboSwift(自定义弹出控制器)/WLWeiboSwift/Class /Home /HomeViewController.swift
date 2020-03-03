//
//  HomeViewController.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/19.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class HomeViewController: BaseTabViewController {
    //MARK:- 懒加载属性
    private lazy var titleButton : TitleButton = {
        let  titleBtn = TitleButton()
        titleBtn.setTitle("coderWhy", for: .normal)
        titleBtn.addTarget(self, action: #selector(titleBtnAction(_:)), for: .touchUpInside)
        return titleBtn
    }()


    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.没有登录时设置的内容
        visitorView.addRotationAnim()
        if !isLogin {
            return
        }
        
        //2.设置导航栏的内容
        setupNavigationBar()
    }
}
//MARK:- 设置UI界面
extension HomeViewController {
    private func setupNavigationBar(){
        //1.设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        //2.设置右侧的Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        //3.设置titleView
        
        navigationItem.titleView = titleButton

    }
}

//MARK:- 事件监听函数
extension HomeViewController{
    ///标题按钮点击事件
    @objc private func titleBtnAction(_ sender:UIButton){
        //1.改变按钮的状态
        sender.isSelected = !sender.isSelected
        
        //2.创建弹出的控制器
        //1.查看storyboard是否有对应的控制器管理
        //2.查看是否有相同名字的xib 文件(加载xib中的View)
        let vc = PopoverViewController()
        
    
        //3.设置控制器modal样式
        vc.modalPresentationStyle = .custom
        
        //3.弹出控制器
        present(vc, animated: true, completion: nil)
    }
}
