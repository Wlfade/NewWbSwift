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
    @IBOutlet weak var contentLabel: UILabel!
    ///转发背景View
    @IBOutlet weak var reweetedBgView: UIView!
    /// 转发label
    @IBOutlet weak var reweetedContentLabel: UILabel!
    /// 图片视图
    @IBOutlet weak var picView: PicCollectionView!
    
    
    
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
            sourceLabel.text = viewModel.sourceText
            
            //8.正文
            contentLabel.text = viewModel.status?.text
            
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
                    reweetedContentLabel.text = "@" + "\(screenName) :" + retweetedText
                }
                //设置转发背景显示
                reweetedBgView.isHidden = false
                //转发label的顶部约束为15
                reweetedLabelTopCons.constant = 15
            }else{
                reweetedContentLabel.text = nil
                //转发背景隐藏
                reweetedBgView.isHidden = true
                //没有转发转发label的顶部约束为0
                reweetedLabelTopCons.constant = 0
                
            }
        }
    }
    
    //MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code 设置微博正文的宽度约束
        contentLabelWCons.constant = UIScreen.main.bounds.width - 2 * edgeMargin
        
        //取出picview的layout
//        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
//        let imageViewWH = (UIScreen.main.bounds.width - 2 *  edgeMargin - 2 * itemMargin)/3
//        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        
        
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
            let picVItemWH = imageViewWH * 2 + itemMargin*2
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
