//
//  PhotoBrowerController.swift
//  WLWeiboSwift
//
//  Created by 单车 on 2019/10/24.
//  Copyright © 2019 单车. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
private let photoBrowerCell = "photoBrowerCell"
class PhotoBrowerController: UIViewController {

    //MARK:- 定义属性
    var indexPath : NSIndexPath
    var picUrls : [NSURL]
    
    //MARK:- 懒加载属性
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: photoBrowserCollectionViewLayout())
    
    //关闭按钮
    private lazy var closeBtn : UIButton = {
        let closetBtn = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "关闭")
        return closetBtn
    }()
    //保存按钮
    private lazy var saveBtn : UIButton = {
        let saveBtn = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "保存")
        return saveBtn
    }()

    //MARK:- 自定义构造函数
    init(indexPath : NSIndexPath, picUrls:[NSURL]) {
        self.picUrls = picUrls
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:)has not been implemented")
    }
    //MARK:- 系统回调函数
    override func loadView() {
        super.loadView()
//        view.bounds.size.width += 20
        view.frame.size.width += 20

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpUI()
        
        //2.滚动到对应的图片
        
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false)
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        dismiss(animated: true, completion: nil)
//    }
}
//MARK:- 设置UI界面内容
extension PhotoBrowerController {
    private func setUpUI(){
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        //2.设置frame
        collectionView.frame = view.bounds
        
        closeBtn.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        
        saveBtn.snp_makeConstraints { (make) in
            make.right.equalTo(-40)
            make.bottom.equalTo(closeBtn.snp_bottom)
            make.size.equalTo(closeBtn.snp_size)
        }
        
        //3.设置collectionView
        collectionView.dataSource = self
        collectionView .register(PhotoBrowerCell.self, forCellWithReuseIdentifier: photoBrowerCell)
        
        //4.监听两个按钮的点击
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        
        saveBtn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)

    }
}
extension PhotoBrowerController :UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //创建cell
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoBrowerCell, for: indexPath) as! PhotoBrowerCell
        Cell.backgroundColor = UIColor.black
        Cell.delegate = self
        Cell.picUrl = picUrls[indexPath.item]
        return Cell
    }
}
//MARK:- PhotoBrowerCellDelegate
extension PhotoBrowerController : PhotoBrowerCellDelegate{
    func imageViewClick() {
        closeAction()
    }
}

//MARK:- 事件的响应
extension PhotoBrowerController{
    @objc private func closeAction(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveAction(){
        //1.获取当前显示的image
        let cell = collectionView.visibleCells.first as! PhotoBrowerCell
        
        guard let image = cell.imageView.image else {
            return
        }
        //2.将image对象保存到相册中
        UIImageWriteToSavedPhotosAlbum(image, self,#selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    @objc private func image(image:UIImage, didFinishSavingWithError error :NSError, contextInfo:AnyObject) {
        print("---")
        var  showInfo = ""
        
        if error != nil {
            showInfo = "保存失败"
        }else{
            showInfo = "保存成功"
        }
        
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
}

//MARK:- 自动布局
class photoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        //1.设置itemSize
        itemSize = collectionView!.frame.size
        minimumInteritemSpacing = 0

        minimumLineSpacing = 0
        
        scrollDirection = .horizontal
        
        //2.设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
