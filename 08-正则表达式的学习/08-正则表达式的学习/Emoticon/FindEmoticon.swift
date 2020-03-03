//
//  FindEmoticon.swift
//  08-正则表达式的学习
//
//  Created by 单车 on 2019/10/24.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class FindEmoticon: NSObject {
    
    //MARK:- 设计单例对象
    static let shareInstance : FindEmoticon = FindEmoticon()
    
    
    //MARK:- 表情属性
    private lazy var manager : EmoticonManager = EmoticonManager()

    //查找属性字符串的方法
    func findAttString(statusText:String,font : UIFont) -> NSMutableAttributedString?{
        //1.创建匹配规则
            let pattern = "\\[.*?\\]" //匹配表情
    //        let pattern = "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?"  //URL地址
            //2.创建正则表达式对象
            guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
                return nil
            }
            //3.开始匹配
            let results = regex.matches(in: statusText, options: [], range: NSRange(location: 0, length: statusText.count))
            //4.获取结果
            let attMStr = NSMutableAttributedString(string: statusText)
            //倒序遍历
            for result in results.reversed()
            {
                //4.1获取chs,获取图片路径
                let chs = ((statusText as NSString).substring(with: result.range))
                
                //4.2根据chs,获取图片的路径
                guard let pngPath = findPngPath(chs: chs) else
                {
                   return nil
                }
                //4.3创建属性字符串
                let attachment = NSTextAttachment()
                attachment.image = UIImage(contentsOfFile: pngPath)
                attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
                let attImageStr = NSAttributedString(attachment: attachment)
                
                //4.4将属性字符串q替换到来源的文字位置
                attMStr.replaceCharacters(in: result.range, with: attImageStr)
            }
            return attMStr
        }
    private func findPngPath(chs:String)-> String?{
        for package in manager.packages {
            for emoticon in package.emoticons {
                if emoticon.chs == chs {
                    return emoticon.pngPath
                }
            }
        }
        return nil
    }
}
