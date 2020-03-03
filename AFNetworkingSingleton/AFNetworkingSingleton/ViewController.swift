//
//  ViewController.swift
//  AFNetworkingSingleton
//
//  Created by 单车 on 2019/7/24.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

//        NetworkTools.shareInstance.request(methodType:.GET, urlString: "http://httpbin.org/get", parameters:  ["name" : "hwhw" ,"age":18 ] as [String : AnyObject])

//        NetworkTools.shareInstance.request(methodType:.POST, urlString: "http://httpbin.org/post", parameters:  ["name" : "hwhw" ,"age":18 ] as [String : AnyObject])
        
        
        NetworkTools.shareInstance.request(method: .GET, urlString: "http://httpbin.org/get", parameters: ["name" : "hwhw" ,"age":18 ] as [String : AnyObject]) { (result, error) in
            if error != nil {
                print(error as Any)
                return
            }
            print(result!)
        }


    }


}

