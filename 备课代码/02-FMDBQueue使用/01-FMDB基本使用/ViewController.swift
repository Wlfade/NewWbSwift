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
        let p = Person(dict: ["name": "ls", "age": 55])
        print(p.insertPerson())
        Person.loadPersons { (models) -> () in
            print(models)
        }
    }
}

