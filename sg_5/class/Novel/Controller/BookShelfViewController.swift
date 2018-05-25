//
//  BookShelfViewController.swift
//  sg_5
//
//  Created by zhishen－mac on 2018/5/24.
//  Copyright © 2018年 zhishen－mac. All rights reserved.
//

import UIKit
import SVProgressHUD
protocol BookShelfViewDelegate {
    func BSPushViewController(viewController: UIViewController)
}

class BookShelfViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource{
    var delegate: BookShelfViewDelegate?
    var bookArray:Array<NovelBookshelfModel> = [NovelBookshelfModel]()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth/3 - 100, height: ((screenWidth/3 - 100) * 175/235))
        layout.scrollDirection = UICollectionViewScrollDirection.vertical;
        layout.minimumLineSpacing = 20;
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-90), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(NovelCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(collectionView)
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        //判断用户登录
        if KeyChain().getKeyChain()["isLogin"] != "1" {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (time) in
                SVProgressHUD.show(withStatus: "未登录")
            }
            return
        }else{
           getDataArr()
        }
        
//        if (self.delegate != nil) {
//            self.delegate?.BSPushViewController(viewController: self)
//        }
        // Do any additional setup after loading the view.
    }
    func getDataArr() {
        let timeInterval: Int = Int(Date().timeIntervalSince1970 * 1000)
        let dic: Dictionary<String, String> = ["timestamp":String(timeInterval),"userId":KeyChain().getKeyChain()["id"]!,"token":KeyChain().getKeyChain()["token"]!,"mobile":KeyChain().getKeyChain()["mobile"]!]
        let parData = dic.toParameterDic()
        NetworkTool.requestData(.post, URLString: getNovelShelfListUrl, parameters: parData) { (json) in
            var array: Array = [NovelBookshelfModel]()
            let modelf = NovelBookshelfModel()
            print(json)
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension BookShelfViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bookArray.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BookShelfItem
        //cell.setLabColor(model: self.bookArray[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
    }
}
class BookShelfItem: UICollectionViewCell {
    var itemLab: UILabel?
    var model: NovelTitleModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        //self.setColor()
        //self.backgroundColor = UIColor.randomColor
    }
    func setLabColor(model: NovelTitleModel){
        self.itemLab?.text = model.title
        self.itemLab?.textColor = model.itemIsSelected! ? .blue : .black
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        //self.itemLab?.textColor = self.isSelecte! ? .red : .black
    }
    func setUI(){
        self.backgroundColor = .white
        let itemLab = UILabel()
        itemLab.backgroundColor = .white
        itemLab.font = UIFont.systemFont(ofSize: 14)
        itemLab.textAlignment = NSTextAlignment.center
        self.addSubview(itemLab)
        self.itemLab = itemLab
        self.itemLab?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        
    }
}