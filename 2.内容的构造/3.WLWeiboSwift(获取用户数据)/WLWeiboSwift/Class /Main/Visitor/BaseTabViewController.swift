//
//  BaseTabViewController.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/23.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class BaseTabViewController: UITableViewController {

    //MARK:- 懒加载属性
    lazy var visitorView : VisitorView = VisitorView.visitorView()
    
    //MARK:- 定义变量
    var isLogin : Bool = UserAccountViewModel.shareInstance.isLogin
    
    //MARK:- 系统回调函数
    override func loadView() {
        //判断要加载哪一个View
        isLogin ? super.loadView() : setupVisitorView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItemsType1()

    }
}

//MARK:- 设置UI界面
extension BaseTabViewController {
    ///设置访客视图
    private func setupVisitorView(){
        view = visitorView
        
        // 监听访客视图 注册 和 登录 按钮的点击
        visitorView.registerBtn.addTarget(self, action: #selector(registerBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
    }
    ///设置导航栏左右的item类型1
    private func setUpNavigationItemsType1(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registerBtnClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(loginBtnClick))
    }
    ///设置导航栏左右的item类型2
    private func setUpNavigationItemsType2(){
        let registerBtn : UIButton = UIButton(type: .custom)
        registerBtn.titleLabel?.textColor = UIColor.red
        registerBtn.setTitle("注册", for: .normal)
        registerBtn.setTitleColor(.red, for: UIControl.State.normal)
        registerBtn.sizeToFit()
        registerBtn.addTarget(self, action: #selector(registerBtnClick), for: .touchUpInside)
        let registerBarButtonItem = UIBarButtonItem(customView: registerBtn)
        
        let loginBtn : UIButton = UIButton(type: .custom)
        loginBtn.titleLabel?.textColor = UIColor.red
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.setTitleColor(.red, for: UIControl.State.normal)
        loginBtn.sizeToFit()
        loginBtn.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
        let loginBarButtonItem = UIBarButtonItem(customView: loginBtn)
        navigationItem.setLeftBarButtonItems([registerBarButtonItem,loginBarButtonItem], animated: true)
    }
}
//MARK:- 事件监听
extension BaseTabViewController{
    ///注册按钮点击事件
    @objc func registerBtnClick() {
        print("注册按钮点击")
    }
    ///登录按钮点击事件
    @objc func loginBtnClick() {
        print("登录按钮点击")
        //1.创建授权控制器
        let oauthVC = OAuthViewController()
//        let oauthVC = OAuthWKViewController()

        
        //2.包装导航控制器
        let oauthNav = UINavigationController(rootViewController: oauthVC)
        
        //3.弹出控制器
        present(oauthNav, animated: true, completion: nil)
        
        
    }
}
