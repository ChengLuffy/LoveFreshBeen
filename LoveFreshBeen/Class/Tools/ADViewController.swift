//
//  ADViewController.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class ADViewController: UIViewController {
    
    lazy var backImageView: UIImageView = {
        let backImageView = UIImageView()
        backImageView.frame = ScreenBounds
        return backImageView
        }()
    
    var imageName: String? {
        didSet {
            var placeholderImageName: String?
            switch UIDevice.currentDeviceScreenMeasurement() {
            case 3.5:
                placeholderImageName = "iphone4"
            case 4.0:
                placeholderImageName = "iphone5"
            case 4.7:
                placeholderImageName = "iphone6"
            default:
                placeholderImageName = "iphone6s"
            }
            // MARK: SDWebImage的方法翻译成swift3语言时出现错误，先用这个
            backImageView.sd_setImage(with: URL.init(string: imageName!)) { (image, error, _, _) in
                if error != nil {
                    //加载广告失败
                    print("加载广告失败")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: ADImageLoadFail), object: nil)
                }
                
                if image != nil {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.fade)
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ADImageLoadSecussed), object: image)
                        })
//                        let time1 = dispatch_time(DISPATCH_TIME_NOW,Int64(0.5 * Double(NSEC_PER_SEC)))
//                        dispatch_after(time1, dispatch_get_main_queue(), { () -> Void in
//                            NSNotificationCenter.defaultCenter().postNotificationName(ADImageLoadSecussed, object: image)
//                        })
                    })
//                    let time = dispatch_time(DISPATCH_TIME_NOW,Int64(1.0 * Double(NSEC_PER_SEC)))
//                    dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
//                        
//                        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
//                        
//                        let time1 = dispatch_time(DISPATCH_TIME_NOW,Int64(0.5 * Double(NSEC_PER_SEC)))
//                        dispatch_after(time1, dispatch_get_main_queue(), { () -> Void in
//                            NSNotificationCenter.defaultCenter().postNotificationName(ADImageLoadSecussed, object: image)
//                        })
//                        
//                    })
                } else {
                    //加载广告失败
                    print("加载广告失败")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: ADImageLoadFail), object: nil)
                }

            }
            
            
//            backImageView.sd_setImage(with: URL.init(string: imageName!), placeholderImage: UIImage.init(named: placeholderImageName!)) { (image, error, _, _) in
//                if error != nil {
//                    //加载广告失败
//                    print("加载广告失败")
//                    NSNotificationCenter.defaultCenter().postNotificationName(ADImageLoadFail, object: nil)
//                }
//                
//                if image != nil {
//                    let time = dispatch_time(DISPATCH_TIME_NOW,Int64(1.0 * Double(NSEC_PER_SEC)))
//                    dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
//                        
//                        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
//                        
//                        let time1 = dispatch_time(DISPATCH_TIME_NOW,Int64(0.5 * Double(NSEC_PER_SEC)))
//                        dispatch_after(time1, dispatch_get_main_queue(), { () -> Void in
//                            NSNotificationCenter.defaultCenter().postNotificationName(ADImageLoadSecussed, object: image)
//                        })
//                        
//                    })
//                } else {
//                    //加载广告失败
//                    print("加载广告失败")
//                    NSNotificationCenter.defaultCenter().postNotificationName(ADImageLoadFail, object: nil)
//                }
//            }
            
//            backImageView.sd_setImageWithURL(NSURL(string: imageName!), placeholderImage: UIImage(named: placeholderImageName!)) { (image, error, _, _) -> Void in
//                if error != nil {
//                    //加载广告失败
//                    print("加载广告失败")
//                    NSNotificationCenter.defaultCenter().postNotificationName(ADImageLoadFail, object: nil)
//                }
//                
//                if image != nil {
//                    let time = dispatch_time(DISPATCH_TIME_NOW,Int64(1.0 * Double(NSEC_PER_SEC)))
//                    dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
//                        
//                        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
//                        
//                        let time1 = dispatch_time(DISPATCH_TIME_NOW,Int64(0.5 * Double(NSEC_PER_SEC)))
//                        dispatch_after(time1, dispatch_get_main_queue(), { () -> Void in
//                            NSNotificationCenter.defaultCenter().postNotificationName(ADImageLoadSecussed, object: image)
//                        })
//                        
//                    })
//                } else {
//                    //加载广告失败
//                    print("加载广告失败")
//                    NSNotificationCenter.defaultCenter().postNotificationName(ADImageLoadFail, object: nil)
//                }
//            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backImageView)
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.none)
    }
}
