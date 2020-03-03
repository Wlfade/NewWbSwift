//
//  UserAccount.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/25.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class UserAccount: NSObject,NSCoding{

    
    //MARK:- 属性
    /// 授权AccessToken
    var access_token : String?
    ///过期时间
    var expires_in : TimeInterval = 0.0{
        didSet{
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    ///用户ID
    var uid : String?
    
    /// 过期日期
    var expires_date : NSDate?
    
    /// 昵称
    var screen_name : String?
    
    /// 用户的头像地址
    var avatar_large : String?
    
    //MARK:- 自定义构造函数
    init(dict:[String : AnyObject]) {
        super.init()
        self.setValuesForKeys(dict)
        self.access_token = dict["access_token"] as? String

        self.expires_in = dict["expires_in"] as! TimeInterval
        
        self.uid = dict["uid"] as? String
        
        self.expires_date = NSDate(timeIntervalSinceNow: expires_in)
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(key)
    }
    //MARK:- c重写descrption属性
//    override var description: String{
//        return dictionaryWithValues(forKeys: ["access_token","uid"])
//    }
    
    //MARK:- 归档&解档
    /// 解档的方法
    required init?(coder aDecode:NSCoder){
        access_token = aDecode.decodeObject(forKey: "access_token") as? String
        uid = aDecode.decodeObject(forKey: "uid") as? String
        expires_date = aDecode.decodeObject(forKey: "expires_date") as? NSDate
        avatar_large = aDecode.decodeObject(forKey: "avatar_large") as? String
        screen_name = aDecode.decodeObject(forKey: "screen_name") as? String
    }
    /// 归档的方法
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token,forKey:"access_token")
        aCoder.encode(uid,forKey:"uid")
        aCoder.encode(expires_date,forKey:"expires_date")
        aCoder.encode(avatar_large,forKey:"avatar_large")
        aCoder.encode(screen_name,forKey:"screen_name")
    }
    
    
}
