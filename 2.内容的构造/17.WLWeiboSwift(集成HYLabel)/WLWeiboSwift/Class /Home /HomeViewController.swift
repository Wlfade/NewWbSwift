//
//  HomeViewController.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/7/19.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeViewController: BaseTabViewController {
    //MARK:- 属性
    var since_id_str = "0"
    var max_id_str = "0"
    
    //MARK:- 懒加载属性
    private lazy var titleButton : TitleButton = {
        let  titleBtn = TitleButton()
        titleBtn.setTitle("coderWhy", for: .normal)
        titleBtn.addTarget(self, action: #selector(titleBtnAction(_:)), for: .touchUpInside)
        return titleBtn
    }()
    
    private lazy var tipLabel : UILabel = UILabel()
    
    private lazy var popoverAnimator : PopoverAnimator = PopoverAnimator {[weak self] (presnted) in
        self?.titleButton.isSelected = presnted
    }
    
    private lazy var viewModelsArr : [StatusViewModel] = [StatusViewModel]()

    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.没有登录时设置的内容
        visitorView.addRotationAnim()
        if !isLogin {
            return
        }
        //2.设置导航栏的内容
        setupNavigationBar()
        //3.设置估算高度
        tableView.estimatedRowHeight = 200
        //4.布局header
        setupHeadView()
        
        //5.布局footer
        setupFootView()
        
        //6.设置提示的Label
        setupTipLabel()
    }
}


//MARK:- 设置UI界面
extension HomeViewController {
    
    /// 设置导航栏
    private func setupNavigationBar(){
        //1.设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        //2.设置右侧的Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        //3.设置titleView
        navigationItem.titleView = titleButton
    }
    /// 设置下拉刷新
    private func setupHeadView(){
        //1.创建headerView
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector(("loadNewStatus")))
        //2.设置header的属性 普通闲置状态
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)

        //设置tableView的header
        tableView.mj_header = header
        
        //4.进入刷新状态
        tableView.mj_header.beginRefreshing()
    }
    /// 设置上拉加载
    private func setupFootView(){
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: Selector(("loadMoreStatus")))
    }
    
    private func setupTipLabel(){
        //1.将tipLabel添加到父控件中
//        view.addSubview(tipLabel)
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        //2.设置tipLabel的frame
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 32)
        //3.设置tipLabel的属性
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
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
    
    @objc private func loadNewStatus(){
        print("loadNewStatuses")
        loadStatus(isNewData: true)
    }
    
    
    @objc private func loadMoreStatus(){
        loadStatus(isNewData:false)
    }
    ///加载微博数据
    private func loadStatus(isNewData:Bool){
        //1.获取since_id
        var since_id = "0"
        var max_id = "0"
        if isNewData {
            since_id = self.since_id_str 
        }else{
            max_id = self.max_id_str
        }
        
        NetworkTools.shareInstance.loadStatus(since_id: since_id,max_id: max_id) { (result,since_id_str,max_id_str, error) in
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
            var tempViewModel = [StatusViewModel]()
            
            for statusDict in resultArray{
                print(statusDict)

                let statues = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: statues)
                
                tempViewModel.append(viewModel)

            }

            //4.将数据加入到成员变量的数组中

            if isNewData{
                self.viewModelsArr = tempViewModel + self.viewModelsArr
            }else{
                self.viewModelsArr += tempViewModel
            }
            
            if since_id_str != nil{
                self.since_id_str = since_id_str!
            }
            
            if max_id_str != nil{
                self.max_id_str = max_id_str!
            }
            //5.缓存图片
            self.cacheImages(viewModels: tempViewModel)
        }
    }
    
    private func cacheImages(viewModels : [StatusViewModel]){
        
        //创建调度组
        let workingGroup = DispatchGroup()
        //创建多列
        let workingQueue = DispatchQueue(label: "request_queue")
        //1.缓存图片
            for viewModel in viewModels {
                for picUrl in viewModel.picUrls{
                    workingGroup.enter()
                    workingQueue.async {
                        SDWebImageManager.shared.loadImage(with: picUrl as URL, options: [], progress: nil) { (_, _, _, _, _, _) in
                            print("下载了一张图片")
                            //出组
                            workingGroup.leave()
                        }
                    }
                }
            }
        
        //调度组里的任务都执行完毕
        workingGroup.notify(queue: workingQueue) {
            DispatchQueue.main.async {
                //刷新表格
                self.tableView.reloadData()
                print("刷新数据")
                
                //停止刷新
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                
                //
//                self.tipLabel.isHidden = false
                self.showTipLabel(count: viewModels.count)
            }
        }
    }
    
    ///显示提示的label
    private func showTipLabel(count:Int){
        //1.属性
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新数据" : "\(count)条微博"
        
        //2.动画
        UIView.animate(withDuration: 1.0, animations: {
            self.tipLabel.frame.origin.y = 44;
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: {
                self.tipLabel.frame.origin.y = 10
            }, completion: { (_) in
                self.tipLabel.isHidden = true;
            })
        }
    }

}

//MARK:- tableView的数据方法
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelsArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1.创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeViewCell
        //2.给cell设置数据
        let viewModel = viewModelsArr[indexPath.row]

        cell.viewModel = viewModel
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //1.获取模型
        let viewModel = viewModelsArr[indexPath.row]

        return viewModel.cellHeight
    }
}
