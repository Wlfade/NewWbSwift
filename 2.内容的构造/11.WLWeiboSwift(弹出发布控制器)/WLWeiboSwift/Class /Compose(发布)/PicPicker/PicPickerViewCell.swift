//
//  PicPickerViewCell.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/10/21.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class PicPickerViewCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension PicPickerViewCell{
    @IBAction func addPhotoClick() {
        print("----")
//          NotificationCenter.default.post(name: NSNotification.Name("isTest"), object: self, userInfo: ["post":"NewTest"])

        
         NotificationCenter.default.post(name: NSNotification.Name(PicPickerAddPhotoNote), object:nil)
    }
}
