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
    
    var cellHeight : CGFloat = 0        //单元格高度
    
    
    var sourceText : String?            //处理来源
    var creatAtText : String?           //处理创建时间
    var verifiedImage : UIImage?        //处理永不认证图标
    var vipImage : UIImage?             //处理用户会员等级
    var profileUrl : NSURL?
    var picUrls : [NSURL] = [NSURL]()
    
    
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
        
        //5.用户地址
        let profileUrlStr = status.user?.profile_image_url ?? ""
        profileUrl = NSURL(string: profileUrlStr)
        
        //6.处理配图数据
        let picUrlDicts = status.pic_urls!.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        if let picUrlDicts = picUrlDicts {
            for picUrlDict in picUrlDicts{
                guard let picUrlString = picUrlDict["thumbnail_pic"] else{
                    continue
                }
                picUrls.append(NSURL(string: picUrlString)!)
                
            }
            
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
