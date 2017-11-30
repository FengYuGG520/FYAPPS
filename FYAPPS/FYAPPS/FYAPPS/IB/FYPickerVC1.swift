//
//  FYPickerVC1.swift
//  yunshanghui
//
//  Created by FengYu on 2017/11/6.
//  Copyright © 2017年 Gavin. All rights reserved.
//

import UIKit

class FYPickerVC1: UIViewController {
    
    var str: String = ""
    
    let arr = ["我不想买了", "信息填写错误，重新拍", "卖家缺货", "同城见面交易", "其他原因"]
    
    var completeBlock: ((String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBAction func quxiaoClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func quedingClick(_ sender: UIButton) {
        if completeBlock != nil {
            if str == "" {
                str = arr[0]
            }
            completeBlock!(str)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension FYPickerVC1 {
    
    func setupUI() {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
}

extension FYPickerVC1: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr.count
    }
    
}

extension FYPickerVC1: UIPickerViewDelegate {
    
    // 设置选择框各选项的内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arr[row]
    }
    
    // 某行滑动停止触发
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        str = arr[row]
    }
    
}
