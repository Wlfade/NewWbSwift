//
//  HomeViewCell.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/8/22.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit
import SDWebImage

private let edgeMargin : CGFloat = 15

class HomeViewCell: UITableViewCell {

    
    
    
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    
    /// 认证
    @IBOutlet weak var verifiedView: UIImageView!
    
    /// 昵称
    @IBOutlet weak var screenNameLabel: UILabel!
    
    /// vipView
    @IBOutlet weak var vipView: UIImageView!
    
    
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    
    
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    
    
    /// 内容
    @IBOutlet weak var contentLabel: UILabel!
    
    //MARK:- 约束的属性
    
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    
    
    var viewModel : StatusViewModel? {
        didSet{
            //1.nil 值校验
            guard let viewModel = viewModel else {
                return
            }
            //2.设置头像
            iconView.sd_setImage(with: viewModel.profileUrl as URL? , placeholderImage: UIImage(named: "avatar_default_small"), options: [], context: nil)
            
            //3.设置认证的图标
            verifiedView.image = viewModel.verifiedImage
            
            //4.昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            
            //5.会员图标
            vipView.image = viewModel.vipImage
            
            //6.设置时间Label
            timeLabel.text = viewModel.creatAtText
            
            //7.设置来源
            sourceLabel.text = viewModel.sourceText
            
            //8.正文
            contentLabel.text = viewModel.status?.text
            
            //9.设置昵称颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
        }
    }
    
    //MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentLabelWCons.constant = UIScreen.main.bounds.width - 2 * edgeMargin
    }

}
