//
//  Status.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/8/3.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class Status: NSObject {
    //MARK:- 属性
    var created_at : String?   //微博创建时间
    var source : String?       //微博来源
    var text : String?          //微博的正文
    var mid : NSNumber?         //微博的ID
    var user : User?
    
    var pic_urls : [[String : String]]? //微博的配图
    var retweeted_status : Status? //微博对应的转发的微博
    
    
    //MARK:- 自定义构造函数
    init(dict:[String : AnyObject]){
        super.init()
    
        self.created_at = dict["created_at"] as? String
        
        self.source = dict["source"] as? String
        
        self.text = dict["text"] as? String
        
        self.mid = dict["mid"] as? NSNumber

        self.pic_urls = dict["pic_urls"] as? [[String : String]] 
        
        if let userDict = dict["user"] as? [String : AnyObject] {
            self.user = User(dict: userDict)
        }
        if let retweetedStatusDict = dict["retweeted_status"] as? [String : AnyObject] {
            self.retweeted_status = Status(dict: retweetedStatusDict)
        }
    }
}
//extension Status{
//    func getSourceText(source:String) -> String {
//        //1.nil 值校验
//        //    guard let tempsource = source, source != "" else{
//        //        return ""
//        //    }
//        guard source != "" else{
//            return ""
//        }
//
//        //2.对来源的字符串进行处理
//        //2.1 获取起始位置和截取的长度
//        let startIndex =  (source as NSString).range(of: ">").location + 1
//        let length = (source as NSString).range(of: "</").location - startIndex
//
//        //2.2 截取字符串
//        return (source as NSString).substring(with: NSRange(location: startIndex, length: length))
//    }
//
//
//    func getCreateAtText(created_at : String) -> String {
//        //1.nil 值校验
//        //    guard let created_at = created_at else{
//        //        return ""
//        //    }
//
//        guard created_at != "" else{
//            return ""
//        }
//
//        //2.对时间处理
//        return NSDate.creatDateStr(createAtStr: created_at)
//    }
//}


