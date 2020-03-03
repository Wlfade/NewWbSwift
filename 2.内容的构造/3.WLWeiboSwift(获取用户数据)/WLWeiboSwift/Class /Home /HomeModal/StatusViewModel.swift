//
//  StatusViewModel.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/8/17.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {
    var status : Status?
    
    var sourceText : String?
    var creatAtText : String?
    
    
    var verifiedImage : UIImage?
    var vipImage : UIImage?
    
    //MARK:- 自定义构造函数
    init(status : Status) {
        self.status = status;
        //1 对来源处理
        if let source = status.source , source != "" {
            //1.1获取起始位置和截取的长度
            let startIndex =  (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            
            //1.2 截取字符串
            sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
        
        //2 对时间的处理
        if let creatAt = status.created_at {
            creatAtText = NSDate.creatDateStr(createAtStr: creatAt)
        }
        
        //3.处理认证
        let verified_type = status.user?.verified_type ?? -1
        switch verified_type {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = UIImage(named: "")
        }
        
        //4.处理会员图标
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }else{
            vipImage = UIImage(named: "common_icon_membership")!
        }
    }
}

extension StatusViewModel{
    func getVerifiedImage(verified_type : Int) -> UIImage {
        let verifiedImage : UIImage?
        
        switch verified_type {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = UIImage(named: "")
        }
        return (verifiedImage)!
    }
    
    func getVipImage(mbrank : Int) -> UIImage {
        let vipImage =
            UIImage(named: "common_icon_membership_level\(mbrank)")
        guard vipImage != nil else{
            return UIImage(named: "common_icon_membership")!
        }
        return vipImage!
    }
}
