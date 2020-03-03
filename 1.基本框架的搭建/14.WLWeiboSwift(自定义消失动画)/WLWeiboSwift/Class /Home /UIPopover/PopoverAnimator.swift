//
//  PopoverAnimator.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/24.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {
    //MARK:- 属性
    var isPresented : Bool = false
    
    var presentedFrame : CGRect = CGRect.zero
    
}

//MARK:- 自定义转场代理的方法
extension PopoverAnimator : UIViewControllerTransitioningDelegate{
    // 目的：改变弹出View的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentation = XMGPresentationController(presentedViewController: presented, presenting: presenting)
        
//        presentation.presentedFrame = CGRect(x: 100, y: 55, width: 180, height: 250)
        presentation.presentedFrame = presentedFrame

        
        return presentation
    }
    // 目的：自定义弹出的动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    // 目的：自定义消失的动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
}
extension PopoverAnimator : UIViewControllerAnimatedTransitioning{
    ///动画执行的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    ///获取'转场的上下文' : 可以通过转场上下文获取弹出的View 和 消失的View
    // UITransitionContextFromViewKey : 获取消失的View
    // UITransitionContextToViewKey : 获取弹出的View
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(using: transitionContext):animationForDismissedView(using: transitionContext)
    }
    
    ///自定义弹出动画
    private func animationForPresentedView(using transitionContext: UIViewControllerContextTransitioning){
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
    
    ///自定义消失动画
    private func animationForDismissedView(using transitionContext: UIViewControllerContextTransitioning){
        //1.获取消失的View
        let dismissedView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            dismissedView.transform = CGAffineTransform(scaleX: 1.0,y: 0.001)
        }) { (_) in
            dismissedView.removeFromSuperview()
            /// 必须告诉转场上下文你已经完成动画
            transitionContext.completeTransition(true)
        }
    }
    
}
