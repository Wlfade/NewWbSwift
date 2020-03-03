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
