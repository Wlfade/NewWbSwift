//
//  User.swift
//  WLWeiboSwift
//
//  Created by 王玲峰 on 8/4/19.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class User: NSObject {
    var profile_image_url : String?     //用户的头像
    var screen_name : String?           //用户的昵称
    var verified_type : Int = -1        //用户的认证类型
    var mbrank : Int = 0 //用户的会员等级

    //MARK:- 对用户数量处理
//    var verifiedImage : UIImage?
//    var vipImage : UIImage?
    
    
    init(dict:[String : AnyObject]) {
        super.init()
//        self.profile_image_url = dict["profile_image_url"] as? String
        self.profile_image_url = dict["profile_image_url"] as? String

        self.screen_name = dict["screen_name"] as? String
        
        self.verified_type = dict["verified_type"] as! Int
        
        self.mbrank = dict["mbrank"] as! Int

        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}

extension User{
    
    
    func getVipImage(mbrank : Int) -> UIImage {
        let vipImage =
            UIImage(named: "common_icon_membership_level\(mbrank)")
        guard vipImage != nil else{
            return UIImage(named: "common_icon_membership")!
        }
        return vipImage!
    }
}



