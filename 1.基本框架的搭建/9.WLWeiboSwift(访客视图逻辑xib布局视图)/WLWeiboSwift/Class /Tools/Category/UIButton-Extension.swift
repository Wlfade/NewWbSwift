//
//  UIButton-Extension.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/22.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit
extension UIButton{
    //swift 中类方法是以 class 开头的方法，类似于OC中 + 开头的方法
    class func createButton(imageName:String,bgImageName:String)->UIButton{
        let btn = UIButton()
        
        //设置btn属性
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName+"_highlighted"), for: .highlighted)
        
        btn.setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        btn.setBackgroundImage(UIImage(named: bgImageName+"_highlighted"), for: .highlighted)
        
        return btn
    }
    
    // convenience ： 便利，使用convenience 修饰的构造函数叫做便利的构造函数
    //便利构造函数通常用在对系统的类进行构造函数的扩充时使用
    /*
     便利构造函数的特点
        1.便利构造函数通常都是写在extension里面
        2.便利构造函数init前面需要加载convenience
        3.在便利构造函数中需要明确调用self.init()
     */
    convenience init(imageName : String , bgImageName : String) {
        self.init()
        //设置btn属性
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName+"_highlighted"), for: .highlighted)
        
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName+"_highlighted"), for: .highlighted)
        sizeToFit()
    }
}
