//
//  FYShowSB.swift
//  yunshanghui
//
//  Created by FengYu on 2017/9/26.
//  Copyright © 2017年 FengYu. All rights reserved.
//

import UIKit

// showVC time
let showOKTime = 1.2
let showErrTime = 1.8

extension UIViewController {
    
    func fy_showOK(title: String, completeBlock: @escaping ()->()) {
        let vc = UIViewController.fy_vc(inSB: "FYShowSB", ID: "FYShowOKVC1") as! FYShowOKVC1
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.block = completeBlock
        vc.text = title
        vc.imgName = "showOKImg"
        vc.time = showOKTime
        self.present(vc, animated: true, completion: nil)
    }
    
    func fy_showErr(title: String, completeBlock: @escaping ()->()) {
        let vc = UIViewController.fy_vc(inSB: "FYShowSB", ID: "FYShowOKVC1") as! FYShowOKVC1
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.block = completeBlock
        vc.text = title
        vc.imgName = "showErrImg"
        vc.time = showErrTime
        self.present(vc, animated: true, completion: nil)
    }
    
    func fy_showOK(title: String, desc: String, completeBlock: @escaping ()->()) {
        let vc = UIViewController.fy_vc(inSB: "FYShowSB", ID: "FYShowOKVC2") as! FYShowOKVC2
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.block = completeBlock
        vc.text1 = title
        vc.text2 = desc
        vc.imgName = "showOKImg"
        vc.time = showOKTime
        self.present(vc, animated: true, completion: nil)
    }
    
    func fy_showErr(title: String, desc: String, completeBlock: @escaping ()->()) {
        let vc = UIViewController.fy_vc(inSB: "FYShowSB", ID: "FYShowOKVC2") as! FYShowOKVC2
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.block = completeBlock
        vc.text1 = title
        vc.text2 = desc
        vc.imgName = "showErrImg"
        vc.time = showErrTime
        self.present(vc, animated: true, completion: nil)
    }
    
}
