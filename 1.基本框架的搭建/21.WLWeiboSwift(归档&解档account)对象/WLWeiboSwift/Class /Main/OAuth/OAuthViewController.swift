//
//  OAuthViewController.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/25.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    //MARK:- 控件的属性
    @IBOutlet weak var webView: UIWebView!
    
    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.设置导航栏的内容
        setUpNavigationBar()
        
        //2.加载网页
        loadPage()
    }
}
//MARK:- 设置UI界面相关
extension OAuthViewController{
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
        webView.loadRequest(request)
    }
}
//MARK:- 事件监听函数
extension OAuthViewController{
    @objc private func closeItemAction(){
        print("关闭")
        dismiss(animated: true, completion: nil)
    }
    @objc private func fillItemAction(){
        print("填充")
        //1. 书写js代码
        let jsCode = "document.getElementById('userId').value=18957146775;document.getElementById('passwd').value=774666077"
        
        //2.执行js代码
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
}


//MARK:- webView的delegate
extension OAuthViewController:UIWebViewDelegate{
    // webView开始加载网页
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    // webView网页加载完成
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    // webView网页加载失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    // 当准备加载某一个页面时，会执行该方法
    // 返回值: true -> 继续加载该网页 false -> 不会加载该网页
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        print(request.url?.absoluteString)
        
        guard let url = request.url else{
            return true
        }
        //2.获取url 中的字符串
        let urlString = url.absoluteString
        
        //3.判断该字符串中是否包含code
        guard urlString.contains("code=") else {
            return true
        }
        
        //4.将code 截取出来
        let code = urlString.components(separatedBy: "code=").last!
        
        print(code)
        
        //5.请求

        loadAccessToke(code: code)
        return false
    }
}

//MARK:- 请求数据
extension OAuthViewController{
    /// 请求AccessToken
    private func loadAccessToke(code:String){
        NetworkTools.shareInstance.loadAccessToken(code: code) { (result, error) in
            //1.错误校验
            if error != nil{
                print(error as AnyObject)
                return
            }
            //2.拿到结果
            print(result as Any)
            
            guard let accountDict = result else{
                print("没有获取授权后的数据")
                return
            }
            
            // 3.字典转模型对象
            let account = UserAccount(dict: accountDict)
            
            // 4.请求用户信息 闭包中调用方法 需要加 self
            self.loadUserInfo(account: account)
            
        }
    }
    
    //请求用户信息
    private func loadUserInfo(account : UserAccount){
        //1.获取access_token
        guard let access_token = account.access_token else {
            return
        }
        
        //2.获取uid
        guard let uid = account.uid else{
            return
        }
        
        
        //3.发送网络请求
        NetworkTools.shareInstance.loadUserInfo(access_token: access_token, uid: uid) { (result, error) in
            if error != nil{
                print(error!)
                return
            }
            //2.拿到用户信息的结果
            print(result as Any)
            guard let userInfoDict = result else{
                return
            }
            
            //3.从字典中取出昵称和用户头像地址
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            
            // 4.将account对象保存
            
            //4.1 获取沙盒路径
            var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            accountPath = (accountPath as NSString).appendingPathComponent("accout.plist")
            
            print(accountPath)
            //4.2 保存对象
            NSKeyedArchiver.archiveRootObject(account, toFile: accountPath)
           
            
        }
    }
}

