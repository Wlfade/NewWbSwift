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
    var isLogin : Bool = false
    //MARK:- 系统回调函数
    
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension BaseTabViewController {
    private func setupVisitorView(){
        view = visitorView
    }
}
