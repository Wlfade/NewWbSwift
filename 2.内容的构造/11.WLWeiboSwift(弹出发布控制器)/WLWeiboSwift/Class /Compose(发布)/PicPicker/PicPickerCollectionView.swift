//
//  PicPickerCollectionView.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/10/21.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

private let PicPickerCell = "picPickerCell"
private let edgeMargin : CGFloat = 15
class PicPickerCollectionView: UICollectionView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWh = (UIScreen.main.bounds.width - 4*edgeMargin)/3
        layout.itemSize = CGSize(width: itemWh, height: itemWh)
        layout.minimumInteritemSpacing = edgeMargin
        layout.minimumLineSpacing = edgeMargin
        
        register(UINib(nibName: "PicPickerViewCell", bundle: nil), forCellWithReuseIdentifier: PicPickerCell)
        
        dataSource = self
        
        //设置内边距
        contentInset = UIEdgeInsets(top: edgeMargin, left: edgeMargin, bottom: 0, right: edgeMargin)
    }
    
}
extension PicPickerCollectionView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicPickerCell, for: indexPath)
        
        //2.给cell 设置数据
//        cell.backgroundColor = UIColor.red
        
        return cell
    }
}
