//
//  UIViewController+FYPickerVC.swift
//  yunshanghui
//
//  Created by FengYu on 2017/10/27.
//  Copyright © 2017年 FengYu. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func fy_pushPickerVC(_ completeBlock: ((String, String, String, Int, Int, Int)->())?) {
        let vc = UIViewController.fy_vc(inSB: "FYPickerVC", ID: "FYPickerVC") as! FYPickerVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        vc.completeBlock = completeBlock
        self.present(vc, animated: true, completion: nil)
    }
    
    func fy_pushPickerVC1(_ completeBlock: ((String)->())?) {
        let vc = UIViewController.fy_vc(inSB: "FYPickerVC", ID: "FYPickerVC1") as! FYPickerVC1
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        vc.completeBlock = completeBlock
        self.present(vc, animated: true, completion: nil)
    }
    
}
