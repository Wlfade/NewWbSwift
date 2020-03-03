//
//  ViewController.swift
//  01-FMDB基本使用
//
//  Created by xiaomage on 15/9/21.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let p = Person(dict: ["name": "zs", "age": 38])
//        print(p.insertPerson())
        print(Person.loadPersons())
    }
}

