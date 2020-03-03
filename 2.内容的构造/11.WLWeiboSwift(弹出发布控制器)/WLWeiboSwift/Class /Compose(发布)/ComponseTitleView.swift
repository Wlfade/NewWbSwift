//
//  ComponseTitleView.swift
//  WLWeiboSwift
//
//  Created by 王玲峰 on 9/28/19.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit
import SnapKit
class ComponseTitleView: UIView {

    //MARK:- 懒加载属性
    private lazy var titleLabel : UILabel = UILabel()
    private lazy var screenNameLabel : UILabel = UILabel()
    
    
    //MARK:- 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ComponseTitleView
{
    private func setupUI(){
        //1.将子控件添加到View中
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        
        //2.设置frame
        titleLabel.snp_makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(self)
            ConstraintMaker.top.equalTo(self)
        }
        
        screenNameLabel.snp_makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(titleLabel.snp_centerX)
            ConstraintMaker.top.equalTo(titleLabel.snp_bottom).offset(3)
        }
        //3.设置控件的属性
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenNameLabel.font = UIFont.systemFont(ofSize: 14)
        screenNameLabel.textColor = UIColor.lightGray
        
        //4.设置文字内容
        titleLabel.text = "发微博"
        screenNameLabel.text = UserAccountViewModel.shareInstance.account?.screen_name
    }
}
