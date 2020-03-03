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
        
        //4.设置转场的代理
        vc.transitioningDelegate = self
        
        //3.弹出控制器
        present(vc, animated: true, completion: nil)
    }
}

//MARK:- 自定义转场代理的方法
extension HomeViewController : UIViewControllerTransitioningDelegate{
    // 目的：改变弹出View的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return XMGPresentationController(presentedViewController: presented, presenting: presenting)
    }
    // 目的：自定义弹出的动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

}
extension HomeViewController : UIViewControllerAnimatedTransitioning{
    ///动画执行的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    ///获取'转场的上下文' : 可以通过转场上下文获取弹出的View 和 消失的View
    // UITransitionContextFromViewKey : 获取消失的View
    // UITransitionContextToViewKey : 获取弹出的View

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //1.获取弹出的View
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        //2.将弹出的View 添加到 containerView
        transitionContext.containerView.addSubview(presentedView)
        
        //3.执行动画
        presentedView.transform = CGAffineTransform(scaleX: 1.0,y: 0.0)
        presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            presentedView.transform = CGAffineTransform.identity
        }) { (_) in
            /// 必须告诉转场上下文你已经完成动画
            transitionContext.completeTransition(true)
        }
        
    }
    

}
