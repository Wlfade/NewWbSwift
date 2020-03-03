//
//  PicCollectionView.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/8/23.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

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
    }
}

extension PicCollectionView:UICollectionViewDataSource{
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
