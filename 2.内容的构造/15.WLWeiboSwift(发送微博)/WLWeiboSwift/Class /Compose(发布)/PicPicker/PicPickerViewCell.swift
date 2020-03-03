//
//  PicPickerViewCell.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/10/21.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class PicPickerViewCell: UICollectionViewCell {
    //MARK:- 控件属性
    
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var deletePhotoBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    //MARK:- 定义属性
    var image : UIImage?{
        didSet{
            if image != nil {
                deletePhotoBtn.isHidden = false
                addPhotoBtn.isUserInteractionEnabled = false
                imageView.image = image
            }else{
                addPhotoBtn.isUserInteractionEnabled = true
                deletePhotoBtn.isHidden = true
                imageView.image = nil
            }
        }
    }
    
    
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
    @IBAction func deletePhotoClick() {
        NotificationCenter.default.post(name: NSNotification.Name(PicPickerDeletePhotoNote), object:imageView.image)
    }
}
