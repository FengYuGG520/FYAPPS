//
//  FYMusicTools.swift
//  Kmusic
//
//  Created by Flynt on 2019/3/22.
//  Copyright © 2019 Flynt. All rights reserved.
//

import UIKit
import AVFoundation

class FYMusicTools: NSObject {
    
    fileprivate static var player: AVAudioPlayer?
    
    class func fy_play(_ url: URL) {
        // 暂停/停止的对象是否是同一首歌（继续播放的时候不会切歌）
        if player?.url == url {
            player?.play()
            return
        }
        // 创建 AVAudioPlayer 对象
        player = try? AVAudioPlayer(contentsOf: url)
        player?.play()
    }
    
    class func fy_pause() {
        player?.pause()
    }
    
    class func fy_stop() {
        player?.stop()
        player?.currentTime = 0
    }
    
    class func fy_remove() {
        player = nil
    }
    
}

// 对其他的控制（音量/时间/代理设置）
extension FYMusicTools {
    
    // 音量 0.0~1.0
    class func fy_volume(_ volume : Float){
        player?.volume = volume
    }
    
    // 当前播放的时间
    class func fy_currentTime(_ currentTime : TimeInterval) {
        player?.currentTime = currentTime
    }
    
    // 得到当前播放的时间
    class func fy_currentTime() -> TimeInterval{
        return player?.currentTime ?? 0
    }
    
    // 播放时间的长短
    class func fy_duration() -> TimeInterval{
        return player?.duration ?? 0
    }
    
    // 设置播放器的代理
    class func fy_playerDelegate(_ delegate : AVAudioPlayerDelegate){
        player?.delegate = delegate
    }
    
}
