//
//  PhotoBrowerAnimator.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/10/28.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

//面向协议开发
protocol AnimatorPresentedDelegate : NSObjectProtocol {
    func startRect(indexPath : NSIndexPath) -> CGRect
    func endRect(indexPath : NSIndexPath) -> CGRect
    func imageView(indexPath : NSIndexPath) -> UIImageView
}

protocol AnimatorDismissDelegate : NSObjectProtocol {
    func indexPathForDismissView() -> NSIndexPath
    func imageViewForDismissView() -> UIImageView
}

class PhotoBrowerAnimator: NSObject {
    var isPreseted : Bool = false
    
    var presentedDelegate : AnimatorPresentedDelegate?
    
    var dismissDelegate : AnimatorDismissDelegate?

    var indexPath : NSIndexPath?
    
}

extension PhotoBrowerAnimator : UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPreseted = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPreseted = false
        return self
    }
}

extension PhotoBrowerAnimator : UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPreseted ? animationForPresentedView(using: transitionContext) : animationForDismissView(using: transitionContext)
    }
    
    func animationForPresentedView(using transitionContext: UIViewControllerContextTransitioning){
        
        //nil值校验
        guard let presentedDelegate = presentedDelegate, let indexPath = indexPath else {
            return
        }
        
        //1.取出弹出的View
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        //2.将presentedView 添加到ContainerView中
        transitionContext.containerView.addSubview(presentedView)
        
        //3.获取执行动画的imageView
        let startRect = presentedDelegate.startRect(indexPath: indexPath)
        
        let imageView = presentedDelegate.imageView(indexPath: indexPath)
        
        
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startRect
        //3.执行动画
        presentedView.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            let endRect = presentedDelegate.endRect(indexPath: indexPath)
            imageView.frame = endRect
        }) { (_) in
            /// 必须告诉转场上下文你已经完成动画
            imageView.removeFromSuperview()
            
            presentedView.alpha = 1.0
            transitionContext.containerView.backgroundColor = UIColor.clear

            transitionContext.completeTransition(true)
        }
    }
    func animationForDismissView(using transitionContext: UIViewControllerContextTransitioning){
        //nil值校验
        guard let dismissDelegate = dismissDelegate, let presentedDelegate = presentedDelegate else {
            return
        }
        
        //1.取出弹出的View
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        dismissView?.removeFromSuperview()
        
        let imageView = dismissDelegate.imageViewForDismissView()
        transitionContext.containerView.addSubview(imageView)
        
        let indexPath = dismissDelegate.indexPathForDismissView()
        
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            imageView.frame = presentedDelegate.startRect(indexPath: indexPath)
        }) { (_) in
            /// 必须告诉转场上下文你已经完成动画
            transitionContext.completeTransition(true)
        }
    }
}
