//
//  ViewController.swift
//  DNPlayAlertSound
//
//  Created by mainone on 16/10/14.
//  Copyright © 2016年 wjn. All rights reserved.
//

import UIKit
import AudioToolbox



class ViewController: UIViewController {
    // 当前是否正在播放
    var isPlaying = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        playAlertSound(sound: "noticeMusic", type: "caf")
//        playSystemAlert(sound: "noticeMusic", type: "caf")
//        playSystemVibration()
        
        
    }
    
    func playAlertSound(sound: String, type: String) {
        if  !isPlaying {
            isPlaying = true

            // 建立sysytemSoundID对象
            var soundID: SystemSoundID = 0
            // 获取声音地址
            guard let soundPath = Bundle.main.path(forResource: sound, ofType: type) else { return }
            guard let soundUrl = NSURL(string: soundPath) else { return }
            // 赋值
            AudioServicesCreateSystemSoundID(soundUrl, &soundID)
            // 播放声音
            AudioServicesPlaySystemSound(soundID)
            
            // 播放完成回调
             let pointer = Unmanaged.passUnretained(self).toOpaque()
            AudioServicesAddSystemSoundCompletion(soundID, nil, nil, { (soundID, pointer) in
                print("播放完成")
                let mySelf = Unmanaged<ViewController>.fromOpaque(pointer!).takeUnretainedValue()
                    mySelf.isPlaying = false
                    AudioServicesRemoveSystemSoundCompletion(soundID)
                    AudioServicesDisposeSystemSoundID(soundID)
                }, pointer)
        }
    }
    
    func playSystemAlert(sound: String, type: String)  {
        // 建立sysytemSoundID对象
        var soundID: SystemSoundID = 0
        // 获取声音地址
        guard let soundPath = Bundle.main.path(forResource: sound, ofType: type) else { return }
        guard let soundUrl = NSURL(string: soundPath) else { return }
        // 赋值
        AudioServicesCreateSystemSoundID(soundUrl, &soundID)
        // 提醒（同播放声音唯一的一个区别）
        AudioServicesPlayAlertSound(soundID)
    }
    
    func playSystemVibration() {
        // 建立的SystemSoundID对象
        let soundID = SystemSoundID(kSystemSoundID_Vibrate)
        // 振动
        AudioServicesPlaySystemSound(soundID)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 
}


