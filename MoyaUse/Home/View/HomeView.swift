//
//  HotrecommendView.swift
//  test
//
//  Created by 张海峰 on 2018/12/5.
//  Copyright © 2018年 张海峰. All rights reserved.
//

import UIKit

class HomeView: UIView {
    var tableView: UITableView = UITableView()
    var arr: NSArray = NSArray(){
        didSet{
            self.tableView.reloadData()
        }
    }
    
    func initView() -> UIView {
      self.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        self.backgroundColor = UIColor.red
        tableView = UITableView.init(frame: self.frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
      return self
    }
}
extension HomeView: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alertCellIdentifier  = "alertCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: alertCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style:.default, reuseIdentifier: alertCellIdentifier)
        }
           let homeModel:HomeModel = self.arr[indexPath.row] as! HomeModel
        cell?.textLabel?.text = homeModel.name!
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
        return cell!
    }
    
    
}
