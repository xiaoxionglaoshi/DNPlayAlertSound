# DNPlayAlertSound
应用中提示音播放
么声音都没有
> 
> 2.提醒: 播放一个声音文件如果手机设为静音或震动，则通过震动提醒用户
> 
> 3.震动: 震动手机，而不考虑其他设置

#### 3.使用方法 需导入头文件
```
import AudioToolbox
```
##### (1)声音播放
```
func playAlertSound(sound: String, type: String) {
        // 建立sysytemSoundID对象
        var soundID: SystemSoundID = 0
        // 获取声音地址
        guard let soundPath = Bundle.main.path(forResource: sound, ofType: type) else { return }
        guard let soundUrl = NSURL(string: soundPath) else { return }
        // 赋值
        AudioServicesCreateSystemSoundID(soundUrl, &soundID)
        // 播放声音
        AudioServicesPlaySystemSound(soundID)
    }
```
注意事项:
```
导入音频文件之后,有时候会出现Bundle.main.path(forResource: sound, ofType: type) 这个方法获取不到资源的问题

原因: xcode没有自动将文件添加到你的资源文件中

解决: build Phases中的 copy Bundle Resources中点击"+"手动添加资源文件
```
##### (2)提醒
```
func playSystemAlert(sound: String, type: String) {
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
```
##### (3)震动
```
// 建立的SystemSoundID对象
let soundID = SystemSoundID(kSystemSoundID_Vibrate)
// 振动
AudioServicesPlaySystemSound(soundID)
```

##### (4)防止出现重复点击声音覆盖
> 通常我们会在上一个声音播放完成之后才会调用下一次播放这里就会用到完成的回调方法 AudioServicesAddSystemSoundCompletion
例:
```
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
```


