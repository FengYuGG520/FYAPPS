//
//  FYPickerVC.swift
//  yunshanghui
//
//  Created by FengYu on 2017/10/27.
//  Copyright © 2017年 FengYu. All rights reserved.
//

import UIKit

class FYPickerVC: UIViewController {
    
    var item: Item?
    
    var provinceRow: Int = 0// 省
    var cityRow: Int = 0// 市
    var districtRow: Int = 0// 区
    
    var provinceId: Int = 0// 省
    var cityId: Int = 0// 市
    var districtId: Int = 0// 区
    
    var completeBlock: ((String, String, String, Int, Int, Int)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBAction func quxiaoClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func quedingClick(_ sender: UIButton) {
        if completeBlock != nil {
            if provinceId == 0 {
                provinceId = (item?.items[provinceRow].regionId)!
            }
            if cityId == 0 {
                cityId = (item?.items[provinceRow].items[cityRow].regionId)!
            }
            if districtId == 0 {
                districtId = (item?.items[provinceRow].items[cityRow].items[districtRow].regionId)!
            }
            completeBlock!((item?.items[provinceRow].regionName)!, (item?.items[provinceRow].items?[cityRow].regionName)!, (item?.items[provinceRow].items?[cityRow].items[districtRow].regionName)!, provinceId, cityId, districtId)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension FYPickerVC {
    
    func setupUI() {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
}

extension FYPickerVC {
    
    func loadData() {
        // 获取省市县的名称  赋值给数组
        let path = Bundle.main.path(forResource: "region", ofType: "json")
        let jsonData = NSData(contentsOfFile: path!)
        let json = try! JSONSerialization.jsonObject(with: jsonData! as Data, options:[]) as! [String:AnyObject]
        do {
            let model = Item(fromDictionary: json)
            item = model
        }
    }
    
}

extension FYPickerVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return (item?.items.count)!
        }
        else if component == 1 {
            return (item?.items[provinceRow].items.count)!
        }
        else {
            return (item?.items[provinceRow].items[cityRow].items.count)!
        }
    }
    
}

extension FYPickerVC: UIPickerViewDelegate {
    
    // 设置选择框各选项的内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return item?.items[row].regionName// 省
        }
        else if component == 1 {
            return item?.items[provinceRow].items?[row].regionName// 市
        }
        else {
            return item?.items[provinceRow].items?[cityRow].items[row].regionName// 区
        }
    }
    
    // 某行滑动停止触发
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            provinceRow = row
            cityRow = 0
            districtRow = 0
            provinceId = (item?.items[provinceRow].regionId)!
        }
        else if component == 1 {
            cityRow = row
            districtRow = 0
            cityId = (item?.items[provinceRow].items[cityRow].regionId)!
        }
        else {
            districtRow = row
            districtId = (item?.items[provinceRow].items[cityRow].items[districtRow].regionId)!
        }
        pickerView.reloadAllComponents()
    }
    
}
