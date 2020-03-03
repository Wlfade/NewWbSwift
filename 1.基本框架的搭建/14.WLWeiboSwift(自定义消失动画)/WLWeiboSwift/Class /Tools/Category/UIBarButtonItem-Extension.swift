//
//  UIBarButtonItem-Extension.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/23.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    /*
    convenience init(imageName:String) {
        self.init()
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName+"_highlighted"), for: .highlighted)
        btn.sizeToFit()
        
        self.customView = btn
    }
 */
    convenience init(imageName:String) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName+"_highlighted"), for: .highlighted)
        btn.sizeToFit()
        self.init(customView:btn)
    }
}
