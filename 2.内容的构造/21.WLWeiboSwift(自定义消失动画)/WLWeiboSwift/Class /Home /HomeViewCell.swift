//
//  HomeViewCell.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/8/22.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit
import SDWebImage
import HYLabel

private let edgeMargin : CGFloat = 15
private let itemMargin : CGFloat = 10

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
    @IBOutlet weak var contentLabel: HYLabel!
    ///转发背景View
    @IBOutlet weak var reweetedBgView: UIView!
    /// 转发label
    @IBOutlet weak var reweetedContentLabel: HYLabel!
    /// 图片视图
    @IBOutlet weak var picView: PicCollectionView!
    
    @IBOutlet weak var bottomToolView: UIView!
    
    //MARK:- 约束的属性
    //正文内容宽度约束
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    
    @IBOutlet weak var reweetedLabelTopCons: NSLayoutConstraint!

    //图片内容宽度约束
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    //图片内容高度约束
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    //图片距离底部约束
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    
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
            if let sourceText = viewModel.sourceText {
                sourceLabel.text = "来自" + sourceText
            }else{
                sourceLabel.text = nil
            }
            
            
            //8.正文
//            contentLabel.text = viewModel.status?.text
            contentLabel.attributedText = FindEmoticon.shareInstance.findAttString(statusText: viewModel.status?.text, font: contentLabel.font)
            
            //9.设置昵称颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            
            //10.计算picView的宽度和高度的约束
            let picViewSize = calculatePicViewSize(count: viewModel.picUrls.count)
            picViewWCons.constant = picViewSize.width
            picViewHCons.constant = picViewSize.height
            
            //11.将picUrl数据传递给picView
            picView.picUrls = viewModel.picUrls
            
            //12.设置转发微博的正文
            if viewModel.status?.retweeted_status != nil {
                
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name,
                    let retweetedText = viewModel.status?.retweeted_status?.text{
                    let reweetedText = "@" + "\(screenName) :" + retweetedText
                    
                    reweetedContentLabel.attributedText = FindEmoticon.shareInstance.findAttString(statusText: reweetedText, font: reweetedContentLabel.font)
                }
                //设置转发背景显示
                reweetedBgView.isHidden = false
                //转发label的顶部约束为15
                reweetedLabelTopCons.constant = 15
            }else{
                //1.设置转发微博的正文
                reweetedContentLabel.text = nil
                //2.转发背景隐藏
                reweetedBgView.isHidden = true
                //3.没有转发转发label的顶部约束为0
                reweetedLabelTopCons.constant = 0
                
            }
            //13.计算cell的高度
            if viewModel.cellHeight == 0 {
                //13.1 强制布局
                layoutIfNeeded()
                
                //13.2获取底部工具栏的最大Y值
                viewModel.cellHeight = (bottomToolView?.frame)!.maxY
            }
        }
    }
    
    //MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code 设置微博正文的宽度约束
        contentLabelWCons.constant = UIScreen.main.bounds.width - 2 * edgeMargin
        //设置HYlabel 的属性
//        contentLabel.matchTextColor = UIColor.purple
        
        //监听label的点击
  
        // 监听@谁谁谁的点击
        contentLabel.userTapHandler = { (label, user, range) in
            print(label)
            print(user)
            print(range)
        }
        // 监听链接的点击
        contentLabel.linkTapHandler = { (label, link, range) in
            print(label)
            print(link)
            print(range)
        }
      // 监听话题的点击
        contentLabel.topicTapHandler = { (label, topic, range) in
            print(label)
            print(topic)
            print(range)
        }
    }
}
//MARK:- 计算方法
extension HomeViewCell{
    private func calculatePicViewSize(count : Int)->CGSize
    {
        //1.没有配图
        if count == 0{
            picViewBottomCons.constant = 0
            return CGSize.zero
        }
        //有配图该约束有值
        picViewBottomCons.constant = 10

        
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout

        if count == 1 {
            // 1.取出图片
            let urlString = viewModel?.picUrls.last?.absoluteString
            
            let image = SDImageCache.shared.imageFromDiskCache(forKey: urlString)
            
            //        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
            //        let imageViewWH = (UIScreen.main.bounds.width - 2 *  edgeMargin - 2 * itemMargin)/3
            //        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)

            //2.
            layout.itemSize = CGSize(width: image!.size.width * 2, height: image!.size.height * 2)

//            return image!.size
            return CGSize(width: image!.size.width * 2, height: image!.size.height * 2)
            
        }
        
        
        //2.计算出来ImageViewWH
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin)/3
        
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)

        //3.四张配图
        if count == 4 {
            let picVItemWH = imageViewWH * 2 + itemMargin + 1
            return CGSize(width: picVItemWH, height: picVItemWH)
        }
        //4.其他张配图
        //4.1 计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        //4.2 计算picView的高度
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        
        //4.3 计算picView的宽度
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        
        return CGSize(width: picViewW, height: picViewH)
    }
}
