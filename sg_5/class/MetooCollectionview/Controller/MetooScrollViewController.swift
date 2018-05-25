//
//  MetooScrollViewController.swift
//  sg_5
//
//  Created by zhishen－mac on 2018/5/19.
//  Copyright © 2018年 zhishen－mac. All rights reserved.
//

import UIKit
import SVProgressHUD
class MetooScrollViewController: UIViewController ,MetooFootDelegate{
    var index: Int = 0
    var headView: MetooScrollHeadView?
    var footView: MetooScrollerFootView?
    var scrollerView: UIScrollView?
    var contentView: UIView?
    var pictureModelArr: Array<PictureClassifyModel> = []
    var lastImageView: UIImageView?
    var imageViewArr: Array = [UIImageView]()
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.scrollerView?.scrollRectToVisible(CGRect(x: CGFloat(self.index) * screenWidth, y: 0, width: screenWidth, height: screenHeight), animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         //[self setAutomaticallyAdjustsScrollViewInsets:NO];
        let scrollerView = UIScrollView()
        scrollerView.contentInsetAdjustmentBehavior = .never
        scrollerView.isPagingEnabled = true
        scrollerView.bounces = false
        scrollerView.showsHorizontalScrollIndicator = false
        scrollerView.alwaysBounceVertical = false
        scrollerView.delegate = self
        self.view.addSubview(scrollerView)
        self.scrollerView = scrollerView
        let contentView = UIView()
        scrollerView.addSubview(contentView)
        self.contentView = contentView
        self.scrollerView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        })   
        for i in 0 ..< pictureModelArr.count {
            let imageView: UIImageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.kf.setImage(with: URL(string:"\(pictureModelArr[i].downloadUrl)"))
            imageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTaped(sender:)))
            imageView.addGestureRecognizer(tap)
            self.contentView?.addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(self.contentView!)
                make.width.equalTo(self.view)
                if lastImageView != nil {
                    make.left.equalTo(self.lastImageView!.snp.right)
                    
                }else{
                    make.left.equalTo(self.contentView!)
                }
            }
            self.lastImageView = imageView
            self.imageViewArr.append(imageView)
        }
        self.contentView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.scrollerView!).inset(UIEdgeInsets.zero)
            make.height.equalTo(self.scrollerView!)
            make.right.equalTo(self.lastImageView!.snp.right)
        })
        self.view.layoutIfNeeded()
        let headView = MetooScrollHeadView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 60))
        headView.backBlock {
            self.navigationController?.popViewController(animated: false)
        }
        self.view.addSubview(headView)
        self.headView = headView
        let footView = MetooScrollerFootView(frame: CGRect(x: 0, y: screenHeight - 60, width: screenWidth, height: 60))
        footView.delegate = self
        self.view.addSubview(footView)
        self.footView = footView
    }
    @objc func imageViewTaped(sender: UIImageView){
        if self.headView?.isShow ?? true {
            self.headView?.hideHeadView()
        }else{
            self.headView?.showHeadView()
        }
        if self.footView?.isShow ?? true {
            self.footView?.hideFootView()
        }else{
            self.footView?.showFootView()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func downLoadImage() {
        UIImageWriteToSavedPhotosAlbum(self.imageViewArr[self.index].image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        
        if didFinishSavingWithError != nil {
            SVProgressHUD.show(withStatus: "保存失败,请稍后再试!")
            return
        }
        SVProgressHUD.show(withStatus: "已保存在相册")
    }
}
extension MetooScrollViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.index =  Int (scrollView.contentOffset.x / screenWidth)
    }
}
