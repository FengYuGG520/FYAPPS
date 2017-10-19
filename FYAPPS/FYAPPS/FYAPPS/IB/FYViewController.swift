//
//  CutNavViewController.swift
//  FYAPPS
//
//  Created by FengYu on 2017/9/28.
//  Copyright © 2017年 FengYu. All rights reserved.
//

import UIKit

class CutNavViewController: UIViewController {
    
    // 自定义导航条两条代码
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.fy_navCut()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
}
