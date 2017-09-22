//
//  ViewController.swift
//  FYAPPS
//
//  Created by FengYu on 2017/9/15.
//  Copyright © 2017年 FengYu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cellHeight: CGFloat = 0.0
    
    
    let fYTableViewCell = "fYTableViewCell"
    
    var colorArr: [String] = ["红色", "微红色", "橘黄色", "谈入谈出", "小鸡米色", "紫色", "天蓝"]
    var colorBool: [Bool] = [false, true, true, false, true, false, true]
    
    var sizeArr: [String] = ["X", "XM", "LLM", "LM", "XXX", "SS", "S"]
    var sizeBool: [Bool] = [false, false, true, false, true, false, false]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red
                
        tableView.fy_target(self)
        tableView.fy_cutSeparator()
        tableView.register(FYTextBtnCell.self, forCellReuseIdentifier: fYTableViewCell)
    }
    
}

extension ViewController: UITableViewDataSource {
    
    // 返回组
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 返回行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // 返回 cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: fYTableViewCell, for: indexPath) as! FYTextBtnCell
        
        cell.btnNoClickBoolArr = colorBool
        cell.textArr = colorArr
        
        cell.backgroundColor = UIColor.red
        cellHeight = cell.cellHeight
        
        cell.clickBlock = { (text, btn, btnTag) in
            print("\(text)\(btnTag)")
        }
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
}
