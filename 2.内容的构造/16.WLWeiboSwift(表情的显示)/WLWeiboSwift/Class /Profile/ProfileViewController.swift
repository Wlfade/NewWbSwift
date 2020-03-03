//
//  ProfileViewController.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/19.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class ProfileViewController: BaseTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.setupVisitorViewInfo(iconName: "visitordiscover_image_profile", title: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
    }
}
