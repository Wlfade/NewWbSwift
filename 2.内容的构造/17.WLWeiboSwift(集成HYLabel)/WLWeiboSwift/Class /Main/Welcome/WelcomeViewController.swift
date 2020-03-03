//
//  WelcomeViewController.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/26.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit
import SDWebImage
class WelcomeViewController: UIViewController {

    //MARK:- 拖线的属性
    @IBOutlet weak var iconViewBottomConstraint: NSLayoutConstraint!
    ///头像视图
    @IBOutlet weak var iconView: UIImageView!
    //MARK:- 系统回调行数
    override func viewDidLoad() {
        super.viewDidLoad()
        let profileUrl = UserAccountViewModel.shareInstance.account?.avatar_large
        //?? : 如果？？ 前面的可选类型有值，那么将前面的可选类型进行解包并且赋值
        //如果？？ 前面的可选类型为nil 那么直接使用？？ 后面的值
        let url = NSURL(string: profileUrl ?? "")
        
        iconView.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "avatar_default_big"), options: [], context: nil)
        //1.改变约束的值
        iconViewBottomConstraint.constant = UIScreen.main.bounds.height - 200
        
        //2.执行动画
        //Damping:阻力系数，阻力系数越大，弹动的效果越不明显 0~1
        //SpringVelocity:初始化速度
//        let snap = UISnapBehavior()
//        snap.damping
        
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
