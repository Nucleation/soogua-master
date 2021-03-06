//
//  SearchHistoryViewController.swift
//  sg_5
//
//  Created by zhishen－mac on 2018/6/9.
//  Copyright © 2018年 zhishen－mac. All rights reserved.
//

import UIKit

class SearchHistoryViewController: UIViewController {
    var navView: UIView?
    var searchTF: UITextField?
    var searchBtn: UIButton?
    var historyArr:NSMutableArray = []
    var tableView :UITableView?
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        let path: String = Bundle.main.path(forResource: "history", ofType:"plist")!
        let array = NSArray(contentsOfFile: path)! as! NSMutableArray
        if array.count != 0 {
            self.historyArr = NSArray(contentsOfFile: path)! as! NSMutableArray
        }  
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let navView = UIView()
        navView.backgroundColor = .white
        self.view.addSubview(navView)
        self.navView = navView
        let searchTF = UITextField()
        searchTF.layer.borderWidth = 1
        searchTF.layer.cornerRadius = 3
        searchTF.layer.borderColor = UIColor.colorWithHexColorString("dddddd").cgColor
        searchTF.placeholder = "请输入搜索内容"
        searchTF.font = UIFont.systemFont(ofSize: 15)
        searchTF.leftViewMode = UITextFieldViewMode.always
        self.navView?.addSubview(searchTF)
        let imageView = UIImageView(frame: CGRect(x: 18, y: 0, width: 30, height: 30))
        imageView.image = UIImage(named: "souzuo")
        searchTF.leftView = imageView
        self.searchTF = searchTF
        let searchBtn = UIButton(type: .custom)
        searchBtn.layer.borderWidth = 1
        searchBtn.layer.borderColor = UIColor.colorWithHexColorString("dddddd").cgColor
        searchBtn.setTitleColor(.colorAccent, for: .normal)
        searchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        searchBtn.setTitle("搜瓜一下", for: .normal)
        searchBtn.addTarget(self, action: #selector(searchClick), for: .touchUpInside)
        self.navView?.addSubview(searchBtn)
        self.searchBtn = searchBtn
        self.navView?.snp.makeConstraints({ (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(64)
        })
        self.searchTF?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.navView!).offset(15)
            make.height.equalTo(38)
            make.bottom.equalTo(self.navView!).offset(-5)
            make.right.equalTo(self.searchBtn!.snp.left).offset(1)
        })
        self.searchBtn?.snp.makeConstraints({ (make) in
            make.height.bottom.equalTo(self.searchTF!)
            make.right.equalTo(self.navView!).offset(-15)
            make.width.equalTo(90)
        })
        let tableView = UITableView()
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        self.tableView = tableView
        self.tableView?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.navView!.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-44)
        })
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
        let lab = UILabel()
        lab.text = "历史记录"
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = UIColor.colortext1
        headView.addSubview(lab)
        let button = UIButton(type: .custom)
        button.setTitle("清除历史记录", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(clearData), for: .touchUpInside)
        button.setTitleColor(UIColor.colorAccent, for: .normal)
        headView.addSubview(button)
        lab.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(100)
        }
        button.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(100)
        }
        self.tableView?.tableHeaderView = headView
        
        // Do any additional setup after loading the view.
    }
    @objc func clearData(){
        self.historyArr = []
        let path = Bundle.main.path(forResource: "history", ofType:"plist")
        self.historyArr.write(toFile: path ?? "", atomically: true)
        self.tableView?.reloadData()
    }
    @objc func searchClick(){
        if self.searchTF?.text != nil{
            let path = Bundle.main.path(forResource: "history", ofType:"plist")
            //self.historyArr = NSArray(contentsOfFile: path!) as! NSMutableArray
            let array: NSMutableArray = NSMutableArray(contentsOfFile: path!)!
            array.insert(self.searchTF?.text ?? "", at: 0)
            array.write(toFile: path ?? "", atomically: true)
            self.historyArr = array
            self.tableView?.reloadData()
            let vc = SearchViewController()
            vc.keyWord = self.searchTF?.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        self.dataArr = SOsearch().getData(keyWord: self.searchTF?.text ?? "")
//        self.dataArr += SougouSearch().getData(keyWord: self.searchTF?.text ?? "")
//
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension SearchHistoryViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style:.default, reuseIdentifier: "cell")
        cell.textLabel?.text = self.historyArr[indexPath.row] as? String
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let vc = SearchViewController()
        vc.keyWord = cell?.textLabel?.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
