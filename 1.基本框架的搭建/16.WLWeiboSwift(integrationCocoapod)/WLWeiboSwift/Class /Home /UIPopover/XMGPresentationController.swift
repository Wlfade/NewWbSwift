//
//  XMGPresentationController.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/24.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class XMGPresentationController: UIPresentationController {
    //MARK:- 对外提供属性
    var presentedFrame : CGRect = CGRect.zero
    
    
    //MARK:- 懒加载属性
    private lazy var coverView : UIView = UIView()
    
    //MARK:- 系统回调函数
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        //1.设置弹出View的尺寸
        presentedView?.frame = presentedFrame
        
        //2.添加蒙版
        setUpCoverView()
    }
}
//MARK:- 设置UI界面相关
extension XMGPresentationController {
    private func setUpCoverView(){
        //1.添加蒙版
        containerView?.insertSubview(coverView, at: 0)
        
        //2.设置蒙版的属性
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        coverView.frame = containerView!.bounds
        
        //3.添加手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        coverView.addGestureRecognizer(tapGes)
        
    }
}
//MARK:- 点击事件的响应
extension XMGPresentationController {
    @objc private func tapGestureAction(){
        print("coverViewClick")
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
