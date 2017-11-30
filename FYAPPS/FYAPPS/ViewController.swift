//
//  ViewController.swift
//  FYAPPS
//
//  Created by FengYu on 2017/9/15.
//  Copyright © 2017年 FengYu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var picker: UIImagePickerController?
    
    @IBOutlet weak var img: UIImageView!
    
    @IBAction func xuanqutupian(_ sender: UITapGestureRecognizer) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.fy_showErr(title: "无法访问相册", completeBlock: { 
                return
            })
        }
        let picker = UIImagePickerController()
        picker.view.backgroundColor = UIColor.white
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.picker = picker
        self.present(picker, animated: true, completion: nil)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = self.compressImage(image: info[UIImagePickerControllerEditedImage] as! UIImage)
        self.img.image = image
        
        let data = UIImageJPEGRepresentation(image, 1.0)
        let imgKB = (data?.count)! / 1024
        print("imgKB -> \(imgKB)")
    }
    
}

extension ViewController {
    
    // 压缩图片
    func compressImage(image: UIImage) -> UIImage {
        
        // 设置图片的宽高
        let iconWH: CGFloat = 300
        
        let imgW = image.size.width
        let imgH = image.size.height
        
        if imgW < iconWH && imgH < iconWH {
            return image
        }
        
        let xScale = iconWH / imgW
        let yScale = iconWH / imgH
        
        let scale = min(xScale, yScale)
        let size = CGSize.init(width: imgW * scale, height: imgH * scale)
        
        UIGraphicsBeginImageContext(size)
        
        image.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result!
    }
    
}

