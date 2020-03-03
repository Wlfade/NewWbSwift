//
//  PicCollectionView.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/8/23.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit
import SDWebImage
class PicCollectionView: UICollectionView {
    
    //MARK:- 定义属性
    var picUrls : [NSURL] = [NSURL](){
        didSet {
            self.reloadData()
        }
    }
    
    
    //MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate = self
    }
}



extension PicCollectionView:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCollectionViewCell
//        cell.backgroundColor = UIColor.red
        cell.picUrl = picUrls[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        
        //1.获取通知需要传递的参数
        let userInfo = [showPhotoBrowserIndexKey:indexPath,showPhotoBrowserUrlsKey:picUrls] as [String : Any]
        
        //2.发出通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: showPhotoBrowserNote), object: self,userInfo: userInfo)
        
    }
}

extension PicCollectionView : AnimatorPresentedDelegate{
    func startRect(indexPath: NSIndexPath) -> CGRect {
        
        //1.获取cell
        let cell = self.cellForItem(at: indexPath as IndexPath)
        
        //2.获取cell的frame
        let startFrame = self.convert(cell?.frame ?? CGRect.zero, to: UIApplication.shared.keyWindow)
        
        return startFrame
        
    }
    
    func endRect(indexPath: NSIndexPath) -> CGRect {
        //1.获取该位置的image对象
        let picUrl = picUrls[indexPath.item]
        let image = SDImageCache.shared.imageFromDiskCache(forKey: picUrl.absoluteString)
        
        //2.计算结束后的frame
        let w = UIScreen.main.bounds.width
        
        let h = w / image!.size.width * image!.size.height
        
        var y : CGFloat = 0
        
        if h > UIScreen.main.bounds.height{
            y = 0
        }else{
            y = (UIScreen.main.bounds.height - h) / 2
        }
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    
    func imageView(indexPath: NSIndexPath) -> UIImageView {
        //1. 创建UIimageView对象
        let imageView = UIImageView()
        
        //2.获取该位置的image对象
        let picUrl = picUrls[indexPath.item]

        let image = SDImageCache.shared.imageFromDiskCache(forKey: picUrl.absoluteString)

        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}

class PicCollectionViewCell: UICollectionViewCell {
    
    //MARK:- 定义属性
    var picUrl : NSURL? {
        didSet{
            guard picUrl != nil else {
                return
            }
            iconView.sd_setImage(with: picUrl as URL?, placeholderImage: UIImage(named: "empty_picture"), options: [], context: nil)

        }
    }
    
    //MARK:- 控件属性
    
    @IBOutlet weak var iconView: UIImageView!
}
