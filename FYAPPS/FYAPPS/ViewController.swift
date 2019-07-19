//
//  ViewController.swift
//  FYAPPS
//
//  Created by FengYu on 2017/9/15.
//  Copyright © 2017年 FengYu. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var baseView: UIView!
    
    // 时间过的真快2018.06.21
    // 第二次来记录2019.05.07
    // 来写Demo 2019.07.16
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        
        let pie_Pic = UIImageView.init(frame: CGRect(x: 0, y: -(self.baseView.bounds.height / 2), width: self.baseView.bounds.width, height: self.baseView.bounds.width))
        pie_Pic.layer.anchorPoint = CGPoint.init(x: 0, y: 0)
        pie_Pic.image = UIImage.init(named: "radar_6")
        self.baseView.addSubview(pie_Pic)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = HUGE
        pie_Pic.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
        // 有空了再写框架
//        getVideoPreViewImage()
    }
    
    /*
     赛场报名 团队作战 注册登录 发布作品 推荐视频
     视频
     http://video.hskyl.cn/fy_xinshouyingdaoship19053101.mp4
     占位图
     http://image.hskyl.cn/fy_xinshouyingdaotup19053101.png
     */
    
    func getVideoPreViewImage() {
        let mp4Url: URL = URL.init(fileURLWithPath: "/Users/mac/Desktop/赛场视频/注册登录.mp4")
        let toUrlStr: String = "/Users/mac/Desktop/注册登录.png"
        
        FYOCTool.fy_saveImg(toUrlStr: toUrlStr, withVideo: mp4Url, atTime: 1)
    }
    
    // 合成音频
    func hechengyinping() {
        let m4aUrlStr: String = "/Users/mac/Desktop/赛场视频/推荐视频/圣淘沙酒店西餐自助餐厅(翡翠店) 5.m4a"
        let mp4UrlStr: String = "/Users/mac/Desktop/赛场视频/推荐视频/手机QQ视频_20190530145409.mp4"
        let toUrlStr: String = "/Users/mac/Desktop/fyshiping.mp4"
        
        let outputURL: URL = URL.init(fileURLWithPath: toUrlStr)
        let comosition: AVMutableComposition = AVMutableComposition.init()
        let inputputURL: URL = URL.init(fileURLWithPath: mp4UrlStr)
        let asset: AVURLAsset = AVURLAsset.init(url: inputputURL, options: nil)
        let videoTrack = comosition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let videoAssetTrack: AVAssetTrack = (asset.tracks(withMediaType: .video).first)! as AVAssetTrack
        do {
            try videoTrack?.insertTimeRange(CMTimeRange.init(start: CMTime.zero, end: asset.duration), of: videoAssetTrack, at: CMTime.zero)
        } catch {}
        let inputputURL2: URL = URL.init(fileURLWithPath: m4aUrlStr)
        let asset2: AVURLAsset = AVURLAsset.init(url: inputputURL2, options: nil)
        let audioTrack = comosition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        let audioAssetTrack = (asset2.tracks(withMediaType: .audio).first)! as AVAssetTrack
        do {
            try audioTrack?.insertTimeRange(CMTimeRange.init(start: CMTime.zero, end: asset2.duration), of: audioAssetTrack, at: CMTime.zero)
        } catch {}
        
        let assetExport = AVAssetExportSession.init(asset: comosition, presetName: AVAssetExportPresetHighestQuality)! as AVAssetExportSession
        assetExport.outputFileType = AVFileType.mp4
        unlink(outputURL.path)
        assetExport.outputURL = outputURL
        assetExport.exportAsynchronously {
            if (assetExport.error != nil) {
                print("j剪切保存出错 \(String(describing: assetExport.error?.localizedDescription))")
            }
            FYGCD.fy_gcdMainAsync({
                print("剪辑成功")
            })
        }
    }
    
}
