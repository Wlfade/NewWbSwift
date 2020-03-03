//
//  ViewController.swift
//  02-图文混排
//
//  Created by 单车 on 2019/10/23.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var demoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let attrStr = NSAttributedString(string: "小码哥", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
        
        let attrStr1 = NSAttributedString(string: "IT教育", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue])
        
        //图文混排
        let attacment = NSTextAttachment()
        attacment.image = UIImage(named: "kk_game_pay_kkpay_selected")
        let font = demoLabel.font
        
        attacment.bounds = CGRect(x: 0, y: -4, width: font!.lineHeight, height: font!.lineHeight)
        let attImageStr = NSAttributedString(attachment: attacment)

        
        let attMStr = NSMutableAttributedString()
        attMStr.append(attrStr)
        attMStr.append(attImageStr)

        attMStr.append(attrStr1)
        
        demoLabel.attributedText = attMStr
    }
}

