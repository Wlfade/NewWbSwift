//
//  NetworkTools.swift
//  AFNetworkingSingleton
//
//  Created by 单车 on 2019/7/24.
//  Copyright © 2019 单车. All rights reserved.
//

import AFNetworking

enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
}

class NetworkTools: AFHTTPSessionManager {
    // let 是线程安全的
    static let shareInstance : NetworkTools = {
        let tools = NetworkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")

        return tools
    }()
}

//MARK:- 封装请求方法
extension NetworkTools {
    
    func request(method: HttpMethod, urlString: String, parameters: [String : AnyObject], completion : @escaping (_ response : Any? ,_ error : Error?)->()){
        
        if method == .GET {
            get(urlString, parameters: parameters, progress: nil, success: { (task, response) in
                completion(response,nil)
            }) { (task,error) in
                completion(nil,error)
            }
        } else {
            post(urlString, parameters: parameters, progress: nil, success: { (task, response) in
                completion(response,nil)
            }) { (task, error) in
                completion(nil,error)
            }
        }
    }
}

//MARK:- 请求AccessToken
extension NetworkTools{
    func loadAccessToken(code : String, finished:@escaping (_ result:[String : AnyObject]?,_ error:Error?)->()) {
        //1.获取请求的urlString
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        //2.获取请求的参数
        let parameters = ["client_id" : app_key,"client_secret":app_secret,"grant_type":"authorization_code","code":code,"redirect_uri":redirect_url]
        
        request(method: .POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
            finished(result as? [String : AnyObject],error)
        }
        
    }
}

//MARK:- 请求用户的信息
extension NetworkTools{
    func loadUserInfo(access_token : String, uid : String, finished : @escaping (_ result:[String : AnyObject]?,_ error:Error?)->()){
        //1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        //2.获取请求的参数
        let parameter = ["access_token":access_token,"uid":uid]
        
        //3.发送网络请求
        request(method: .GET, urlString: urlString, parameters: parameter as [String : AnyObject]) { (result, error) in
            finished((result as? [String : AnyObject]),error)
        }
    }
}

//MARK:- 请求首页数据
extension NetworkTools{
    func loadStatus(since_id: String,max_id:String, finished:@escaping (_ result:[[String:AnyObject]]?,_ since_id_str: String?,_ max_id_str: String?,_ error:NSError?)->()){
        //1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let access_token = (UserAccountViewModel.shareInstance.account?.access_token)!
        
        //2.获取请求的参数
        let parameters = ["access_token":access_token,"since_id":since_id,"max_id":max_id]
        
        //3.发送网络请求
        request(method: .GET, urlString: urlString, parameters: parameters  as [String : AnyObject]) { (result, error) in
            guard let resultDict = result as?[NSString : AnyObject] else{
                finished(nil,nil,nil,error as NSError?)
                return
            }
            //2.将数组数据回调给外界控制器
            finished(resultDict["statuses"] as? [[String : AnyObject]],resultDict["since_id_str"] as? String,resultDict["max_id_str"] as? String,error as NSError?)
        }
        
    }
}

//MARK:- 发送微博
extension NetworkTools{
    func sendStatus(statusText : String,finished : @escaping (_ isSuccess:Bool)->()){
        //1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        
        //2.获取请求的参数
        let parameter = ["access_token":(UserAccountViewModel.shareInstance.account?.access_token)!,"status":statusText]
        
        //3.发送网络请求
        //3.发送网络请求
        request(method: .POST, urlString: urlString, parameters: parameter as [String : AnyObject]) { (result, error) in
//            finished((result as?[String:AnyObject]),error)
            if error == nil{
                finished(true)
            }else{
                finished(false)
            }
        }
        
    }
}

//MARK:- 发送微博并且携带照片
extension NetworkTools{
    func sendStatus(statusText : String, image:UIImage ,finished : @escaping (_ isSuccess:Bool)->()){
        //1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/upload.json"
        
        //2.获取请求的参数
        let parameter = ["access_token":(UserAccountViewModel.shareInstance.account?.access_token)!,"status":statusText]
        //3.发送网络请求
        post(urlString, parameters: parameter, constructingBodyWith: { (formData) in
            if let imageData = image.jpegData(compressionQuality: 0.5){
                formData.appendPart(withFileData: imageData, name: "pic", fileName: "123.png", mimeType: "image/png")
            }
        }, progress: nil, success: { (_, _) in
            finished(true)
        }) { (_, error) in
            print(error)
        }
    }
}
