//
//  UserAccountViewModel.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/26.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit
class UserAccountViewModel{
    
    //MARK:- 将类设计为单例
    static let shareInstance : UserAccountViewModel = UserAccountViewModel()
    
    //MARK:- 定义属性
    var account : UserAccount?
    
    //MARK:- 计算属性
    var accountPath : String{
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
         return (accountPath as NSString).appendingPathComponent("accout.plist")
        
    }
    
    var isLogin : Bool{
        if account == nil{
            return false
        }
        guard let expiresDate = account?.expires_date else{
            return false
        }
        return expiresDate.compare(NSDate() as Date) == ComparisonResult.orderedDescending
    }
    init() {
        //1.1 读取信息
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
        
        print("--\(String(describing: account))")
    }

}
