//
//  MainAD.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class MainAD: NSObject, DictModelProtocol {
    var code: Int = -1
    var msg: String?
    var data: AD?
    
    class func loadADData(completion:(_ data: NSDictionary?, _ error: NSError?) -> Void) {
        let path = Bundle.main.path(forResource: "AD", ofType: nil)
        let data = NSData(contentsOfFile: path!)
        if data != nil {
            let dict: NSDictionary = (try! JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments)) as! NSDictionary
//            let modelTool = DictModelManager.sharedManager
//            let data = modelTool.objectWithDictionary(dict: dict, cls: MainAD.self) as? MainAD
            completion(dict, nil)
        }
    }
    
    static func customClassMapping() -> [String : String]? {
        return ["data" : "\(AD.self)"]
    }
}

class AD: NSObject {
    var title: String?
    var img_name: String?
    var starttime: String?
    var endtime: String?
}
