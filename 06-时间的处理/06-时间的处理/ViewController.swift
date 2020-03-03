//
//  ViewController.swift
//  06-时间的处理
//
//  Created by 王玲峰 on 8/4/19.
//  Copyright © 2019 王玲峰. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let creatAtStr = "Fri Apr 08 11:16:29 +0800 2016"
        
        //1.创建时间格式化处理
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH"
        
        
    }


}

