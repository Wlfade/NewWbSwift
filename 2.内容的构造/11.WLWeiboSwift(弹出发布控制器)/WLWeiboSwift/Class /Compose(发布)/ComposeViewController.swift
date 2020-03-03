//
//  ComposeViewController.swift
//  WLWeiboSwift
//
//  Created by 王玲峰 on 9/28/19.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    //MARK:- 控件属性
    
    //MARK:- 懒加载
    private lazy var titleView : ComponseTitleView = ComponseTitleView()
    
    @IBOutlet weak var textview: ComposeTextView!
    
    //MARK:- 约束的属性
    
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var picPickerHeightCons: NSLayoutConstraint!
    //MARK:- 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置导航栏
        setUpNavigationBar()
        
        //监听键盘的通知
        registerKeyBoardNotification()
        
        //监听照片的添加和删除的通知
        registerPhotoNotification()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textview.alwaysBounceVertical = true

        textview.becomeFirstResponder()
    }
    deinit {
        releaseNotification()
    }
    
    

}
//MARK:- 设置UI界面
extension ComposeViewController{
    private func setUpNavigationBar(){
        //1.设置左右的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeItemClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(sendItemClick))
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        //2.设置标题
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
}
extension ComposeViewController{
    private func registerPhotoNotification(){
        //监听照片添加的按钮点击
        NotificationCenter.default.addObserver(self, selector: #selector(PicPickerAddPhoto), name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)

    }
    
    @objc func PicPickerAddPhoto(){
        print("添加照片")
        
        //1.判断照片源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            return
        }
        //2.创建照片选择控制器
        let ipc = UIImagePickerController()
        //3.设置照片源
        ipc.sourceType = UIImagePickerController.SourceType.photoLibrary
        //4.设置代理
        ipc.delegate = self
        
        //弹出选择照片的控制器
        present(ipc, animated: true, completion: nil)


    }
}
//MARK:- UIImagePickerController的代理方法
extension ComposeViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        //1.获取选中的照片
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        //2.展示照片
        
    }
}
extension ComposeViewController{
    private func registerKeyBoardNotification(){
        //监听键盘的弹出
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillShow(_ :)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        //监听键盘的回收
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillChangeFrame(_ :)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillHide(_ :)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
    }
    
    //MARK:键盘通知相关操作
    @objc func keyBoardWillShow(_ notification:Notification){
        DispatchQueue.main.async {
            print(notification);
            //1.获取动画执行的时间
            let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
            
            //2.获取键盘最终Y值
            let endFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            let y = endFrame.origin.y
            
            //3.计算工具栏距离
            let margin =   y - UIScreen.main.bounds.height

            self.toolBarBottomCons.constant = margin

            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyBoardWillHide(_ notification:Notification){
        print(notification);
        DispatchQueue.main.async {
            //1.获取动画执行的时间
            let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
            
            self.toolBarBottomCons.constant = 0

            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyBoardWillChangeFrame(_ notification:Notification){
        print(notification);
        print("键盘改变frame")
    }
    //MARK:释放键盘监听通知
    func releaseNotification(){
        NotificationCenter.default.removeObserver(self)
    }
}
//MARK:- 事件监听函数
extension ComposeViewController{
    @objc private func closeItemClick(){
        dismiss(animated: true, completion: nil)
    }
    @objc private func sendItemClick(){
        print("sendItemClick")
    }
    @IBAction func picPickAction(_ sender: Any) {
        print("选择图片")
        textview.resignFirstResponder()
        
        picPickerHeightCons.constant = UIScreen.main.bounds.height * 0.5

        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

//MARK:- UITextViewDelegate
extension ComposeViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        //是否有内容
        self.textview.placeHolderLabel.isHidden = textview.hasText
        
        
        navigationItem.rightBarButtonItem?.isEnabled = textview.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textview.resignFirstResponder()
    }
}
