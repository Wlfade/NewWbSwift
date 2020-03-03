//
//  HomeViewController.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/19.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class HomeViewController: BaseTabViewController {
    //MARK:- 属性

    
    //MARK:- 单元格注册标识
    static let cellId = "HomeCell"

    //MARK:- 懒加载属性
    private lazy var titleButton : TitleButton = {
        let  titleBtn = TitleButton()
        titleBtn.setTitle("coderWhy", for: .normal)
        titleBtn.addTarget(self, action: #selector(titleBtnAction(_:)), for: .touchUpInside)
        return titleBtn
    }()

    //注意：在闭包中如果使用当前对象的属性或调用方法，也需要加self
    //两个地方需要使用self: 1> 如果在一个函数中出现歧义 2> 在闭包中使用当前对象的属性和方法也需要加self
    private lazy var popoverAnimator : PopoverAnimator = PopoverAnimator {[weak self] (presnted) in
        self?.titleButton.isSelected = presnted
    }
    
    private lazy var statusesArr : [Status] = [Status]()

    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.没有登录时设置的内容
        visitorView.addRotationAnim()
        if !isLogin {
            return
        }
        //1.1 注册单元格
        registercell()
        
        //2.设置导航栏的内容
        setupNavigationBar()
        
        //3.请求数据
        loadStatus()
    }
}
extension HomeViewController{
    func registercell(){
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier:HomeViewController.cellId)
    }
}

//MARK:- 设置UI界面
extension HomeViewController {
    private func setupNavigationBar(){
        //1.设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        //2.设置右侧的Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        //3.设置titleView
        
        navigationItem.titleView = titleButton

    }
}

//MARK:- 事件监听函数
extension HomeViewController{
    ///标题按钮点击事件
    @objc private func titleBtnAction(_ sender:UIButton){
        //1.改变按钮的状态
        sender.isSelected = !sender.isSelected
        
        //2.创建弹出的控制器
        //1.查看storyboard是否有对应的控制器管理
        //2.查看是否有相同名字的xib 文件(加载xib中的View)
        let popoverVc = PopoverViewController()
        
        //3.设置控制器modal样式
        popoverVc.modalPresentationStyle = .custom
        
        //4.设置转场的代理
        popoverAnimator.presentedFrame = CGRect(x: 100, y: 85, width: 180, height: 250)
        popoverVc.transitioningDelegate = popoverAnimator
        
        //3.弹出控制器
        present(popoverVc, animated: true, completion: nil)
    }
}

//MARK:- 请求数据
extension HomeViewController{
    private func loadStatus(){
        NetworkTools.shareInstance.loadStatus { (result, error) in
            //1.错误校验
            if error != nil{
                print(error!)
                return
            }
            //2.获取可选类型中的数据
            guard let resultArray = result else{
                return
            }
            //3.遍历微博数组 对应的字典
            for statusDict in resultArray{
                print(statusDict)
                
                let statues = Status(dict: statusDict)
                self.statusesArr.append(statues)
            }
            
            //4.刷新表格
            self.tableView.reloadData()
        }
    }
}

//MARK:- tableView的数据方法
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusesArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1.创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewController.cellId, for: indexPath) as UITableViewCell
        //2.给cell设置数据
        let status = statusesArr[indexPath.row]
        
//        cell.textLabel?.text = status.text
//        cell.textLabel?.text = "\(status.text ?? "")+\(status.sourceText ?? "")+\(status.createAtText ?? "")"
        cell.textLabel?.text = status.createAtText


        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
