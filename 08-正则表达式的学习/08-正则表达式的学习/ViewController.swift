//
//  ViewController.swift
//  08-正则表达式的学习
//
//  Created by 单车 on 2019/10/24.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

/**
 练习1：匹配abc
 练习2：包含一个a~z,后面必须是0~9 --> [a-z][0-9]或者[a-z]\d
        * [a-z] : a~z
        * [0-9]/ \d : 0~9
 练习3：必须第一个是字母，第二个是数字-->^[a-z][0-9]$
        * ^[a-z] : 表示首字母必须是a~z
        * \d{2,10} : 数字有2~10 个
        * [a-z]$ : 表示必须以a-z的字母结尾
 练习4：必须第一个是字母，字母后面跟上4~9个数字
 练习5：不能是数字0-9
        * [^0-9]
 练习6：QQ匹配：^[1-9]\d{4,11}$
 都是数字
 5~12位
 并且第一位不能是0
 练习7：手机号匹配^1[3578]\d{9}$
 1.以13/15/17/18
 2.长度11
 */
class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    
    private lazy var manager : EmoticonManager = EmoticonManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        practiceOne()
//        practiceTwo()
        weiboRegular()
        
    }
    //练习一
    func practiceOne() {
        let str = "fdakdjfabckeiglseigabcnl"
        
        //1.创建正则表达式规则
        let pattern = "abc"
        
        //2.创建正则表达式对象(try try? try!)
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return
        }
        //3.匹配字符串中的内容
        let results = regex.matches(in: str, options: [], range: NSRange(location: 0, length: str.count))
        
        //4.遍历数组，获取结果
        for result in results {
            print((str as NSString).substring(with: result.range))
            print(result.range)
        }
    }
    //练习二
    func practiceTwo() {
        let str = "a1395dd7465f3856g545z"
        
        //1.创建正则表达式规则
//        let pattern = "[a-z]" //匹配字符串中的所有的字母
//        let pattern = "[a-z][0-9]" //匹配字符串中第一个是字母 第二个是数字
//        let pattern = "[a-z]\\d" //同上 \d 也是可以表示为数字

//        let pattern = "^[a-z]" //首字母a~z
//        let pattern = "^[a-z]\\d\\d" //首字母a~z 后面跟上两个数字
//        let pattern = "^[a-z]\\d{2,10}" //首字母a~z 后面跟上两个数字

//        let pattern = "[a-z]$" //尾字母a~z
//        let pattern = "^[^0-9]" //尾字母a~z

        let pattern = "^[1-9]\\d{4,11}$" //匹配QQ

        //2.创建正则表达式对象(try try? try!)
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return
        }
        //3.匹配字符串中的内容
        let results = regex.matches(in: str, options: [], range: NSRange(location: 0, length: str.count))
        
        //4.遍历数组，获取结果
        for result in results {
            print((str as NSString).substring(with: result.range))
            print(result.range)
        }
    }

    //微博数据的匹配
    func weiboRegular()  {
        let statusText = "@coderWhy:【动物尖叫合集】#肥猪流#猫头鹰这么尖叫[偷笑]、@M了个J:老鼠这么尖叫、兔子这么尖叫[吃惊]、@花满楼:莫名奇#小笼包#妙到笑到最后[好爱哦]！~ http://t.cn/zYBuKZB/"
        
        statusLabel.attributedText = FindEmoticon.shareInstance.findAttString(statusText: statusText, font: statusLabel.font)
        
    }
}


