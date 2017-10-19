//
//  FYShowOKVC2.swift
//  yunshanghui
//
//  Created by FengYu on 2017/9/26.
//  Copyright © 2017年 Gavin. All rights reserved.
//

import UIKit

class FYShowOKVC2: UIViewController {
    
    var timer: Timer?
    var time: Double = 1.0
    
    var text1: String?
    var text2: String?
    
    var block: (()->())?
    
    var imgName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view2.fy_radius(10)
        if text1 != nil {
            self.title1.text = text1
        }
        if text2 != nil {
            self.title2.text = text2
        }
        if imgName != nil {
            self.img1.image = UIImage.init(named: imgName!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if (UIApplication.shared.keyWindow?.rootViewController?.isKind(of: UITabBarController.self))! {
            (UIApplication.shared.keyWindow?.rootViewController as! UITabBarController).tabBar.isUserInteractionEnabled = false
        }
        timer = Timer.fy_time(time: time, target: self, action: #selector(disVC), info: [:], repe: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
        if (UIApplication.shared.keyWindow?.rootViewController?.isKind(of: UITabBarController.self))! {
            (UIApplication.shared.keyWindow?.rootViewController as! UITabBarController).tabBar.isUserInteractionEnabled = true
        }
        timer = nil
        if block != nil {
            block!()
        }
    }
    
    func disVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
}
