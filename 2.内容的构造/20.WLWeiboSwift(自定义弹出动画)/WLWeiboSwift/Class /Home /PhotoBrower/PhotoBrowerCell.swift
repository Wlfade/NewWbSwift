//
//  PhotoBrowerCell.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/10/25.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowerCellDelegate : NSObjectProtocol {
    func imageViewClick()
}

class PhotoBrowerCell: UICollectionViewCell {
    //MARK:- 定义属性
    var picUrl : NSURL?{
        didSet{
            setUpContent(picURL:picUrl)
        }
    }
    
    //MARK:- 代理属性
    var delegate : PhotoBrowerCellDelegate?
    
    
    //MARK:- 懒加载属性
    private lazy var scrollView : UIScrollView = UIScrollView()
    
    lazy var imageView : UIImageView = UIImageView()
    
    private lazy var progressView : ProgressView = ProgressView()

    override init(frame:CGRect){
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK:- 设置UI界面内容
extension PhotoBrowerCell{
    private func setupUI(){
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)

        contentView.addSubview(progressView)
        
        //2.设置控件frame
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
        
        //3.设置控件的属性
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        
        imageView.isUserInteractionEnabled = true
        //4.监听imageView的点击
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTap(_:))))
    }

}
//MARK:- 事件监听
extension PhotoBrowerCell{
    @objc func imageTap(_ tap : UITapGestureRecognizer){        
        delegate?.imageViewClick()
    }
}
extension PhotoBrowerCell{
    private func setUpContent(picURL:NSURL?){
        guard  let picUrl = picURL else {
            return
        }
        //2.取出image对象
        let image = SDImageCache.shared.imageFromDiskCache(forKey: picUrl.absoluteString)
        //2.取出image对象
        let x : CGFloat = 0
        let width = UIScreen.main.bounds.width
        let height = width / image!.size.width * image!.size.height
        var y : CGFloat = 0
        if height>UIScreen.main.bounds.height {
            y = 0
        }else{
            y = (UIScreen.main.bounds.height - height)/2
        }
        imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        //4.设置imageView的图片
//        imageView.image = image
        
        progressView.isHidden = false
        imageView.sd_setImage(with: getBigUrl(smallURL: picUrl) as URL, placeholderImage: image, options: [], progress: { (current, total, _) in
            self.progressView.progress = CGFloat(current) / CGFloat(total)
        }) { (_, _, _, _) in
            self.progressView.isHidden = true
        }
        
        //5.设置scrollView的contentSize
        scrollView.contentSize = CGSize(width: 0, height: height)
    }
    private func getBigUrl(smallURL : NSURL)-> NSURL{
        let smallURLSting = smallURL.absoluteString!
        let bigURLSting = smallURLSting.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        
        return NSURL(string: bigURLSting)!
    }
}
