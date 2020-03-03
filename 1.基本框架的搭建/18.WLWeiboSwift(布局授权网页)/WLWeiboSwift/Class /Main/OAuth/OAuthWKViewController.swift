//
//  OAuthWKViewController.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/25.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class OAuthWKViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //1.设置导航栏的内容
        setUpNavigationBar()
        
        //2.加载网页
//        loadPage()
    }


}

//MARK:- 设置UI界面相关
extension OAuthWKViewController{
    private func setUpNavigationBar(){
        //1.设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeItemAction))
        //2.设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(fillItemAction))
        
        //3.设置标题
        title = "登录页面"
    }
    private func loadPage(){
        //1.获取登录页面的URLString
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_url)"
        
        //2.创建对应的URL
        guard let url = NSURL(string: urlString) else{
            return
        }
        
        //3.创建NSURLRequest
        let request = URLRequest(url: url as URL)
        
        //加载request
        webView.load(request)
    }
}
//MARK:- 事件监听函数
extension OAuthWKViewController{
    @objc private func closeItemAction(){
        print("关闭")
        dismiss(animated: true, completion: nil)
    }
    @objc private func fillItemAction(){
        print("填充")
        dismiss(animated: true, completion: nil)
    }
}
//MARK:- webView的delegate
extension OAuthWKViewController:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
}
