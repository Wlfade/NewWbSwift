//
//  ComposeViewController.swift
//  WLWeiboSwift
//
//  Created by 王玲峰 on 9/28/19.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit
import SVProgressHUD
class ComposeViewController: UIViewController {

    //MARK:- 控件属性
    @IBOutlet weak var textview: ComposeTextView!

    @IBOutlet weak var picCollectionView: PicPickerCollectionView!
    //MARK:- 懒加载
    private lazy var titleView : ComponseTitleView = ComponseTitleView()
    private var images : [UIImage] = [UIImage]()
    private lazy var emoticonVC : EmoticaonController = EmoticaonController { [weak self](emoticon) in
        self?.textview.insertEmoticon(emoticon: emoticon)
        self?.textViewDidChange(self!.textview)
    }
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
//MARK:- 照片的监听
extension ComposeViewController{
    private func registerPhotoNotification(){
        //监听照片添加的按钮点击
        NotificationCenter.default.addObserver(self, selector: #selector(PicPickerAddPhoto), name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
        
        //监听照片删除的按钮点击
        NotificationCenter.default.addObserver(self, selector: #selector(PicPickerDeletePhoto(_ :)), name: NSNotification.Name(rawValue: PicPickerDeletePhotoNote), object: nil)

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
    
    @objc func PicPickerDeletePhoto(_ notification:Notification){
        //1.获取image对象
        guard let image = notification.object as? UIImage else {
            return
        }
        
        //2.获取image的下标
        guard let index = images.firstIndex(of: image) else{
            return
        }
        //3.将图片从数组中删除
        images.remove(at: index)
        
        //4.重新赋值collectionView新的数组
        picCollectionView.images = images
    }
}
//MARK:- UIImagePickerController的代理方法
extension ComposeViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        //1.获取选中的照片
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        //2.将选中的照片添加到数组中
        images.append(image)
        //3.将数组赋值给collectionView，让collectionView自己去展示数据
        picCollectionView.images = images
        
        //4.退出选中照片控制器
        picker.dismiss(animated: true, completion: nil)
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
        textview.resignFirstResponder()
        
        //1.获取发送微博的微博正文
        let statusText = textview.getEmoticonString()
        
        let finishedCallBack = { (isSuccess:Bool) in
                    if isSuccess == true{
                        print("发送成功")
                        SVProgressHUD.showSuccess(withStatus: "发送微博成功")
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        print("发送失败")
                        SVProgressHUD.showError(withStatus: "发送微博失败")
        //                self.dismiss(animated: true, completion: nil)
                    }
                }
        
        
        //获取用户选中的图片
        if let image = images.first
        {
            //2.调用接口发送微博
            NetworkTools.shareInstance.sendStatus(statusText: statusText, image: image, finished: finishedCallBack)
        }else{
            //2.调用接口发送微博
            NetworkTools.shareInstance.sendStatus(statusText: statusText, finished: finishedCallBack)
        }
        
    }
    @IBAction func picPickAction() {
        print("选择图片")
        textview.resignFirstResponder()
        
        picPickerHeightCons.constant = UIScreen.main.bounds.height * 0.65

        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func emoticonBtnClick() {
        print("切换键盘")
        //1.退出键盘
        textview.resignFirstResponder()
        
        //2.切换键盘
        textview.inputView = textview.inputView != nil ? nil : emoticonVC.view
        
        //3.弹出键盘
        textview.becomeFirstResponder()
        
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
