//
//  ComposeTextView.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/10/18.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {
    //MARK:- 懒加载属性
    lazy var placeHolderLabel : UILabel = UILabel()
    //xib创建使用 先 初始化控件使用
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    //xib创建使用 后 对控件进行约束
    override func awakeFromNib() {
        
    }
}

extension ComposeTextView{
    private func setupUI(){
        //1.添加子控件
        addSubview(placeHolderLabel)
        
        //2.设置frame
        placeHolderLabel.snp_makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        //3.设置placeHolderLabel属性
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.font = font;
        
        //4.设置placeHolderLabel文字
        placeHolderLabel.text = "分享新鲜事。。。"
        
        //5.设置内容的内边距
        textContainerInset = UIEdgeInsets(top: 6, left: 7, bottom: 0, right: 7)
    }
}
