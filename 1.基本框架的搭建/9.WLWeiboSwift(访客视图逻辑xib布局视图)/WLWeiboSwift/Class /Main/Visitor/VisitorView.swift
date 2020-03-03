//
//  VisitorView.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/23.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    //MARK:- 提供快速通过xib创建的类方法
    class func visitorView() -> VisitorView {
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.first as! VisitorView
        
    }

}
