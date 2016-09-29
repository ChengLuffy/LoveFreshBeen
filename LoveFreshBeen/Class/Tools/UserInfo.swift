//
//  UserInfo.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6
//  当前用户信息

import UIKit

class UserInfo: NSObject {
    
    private static let instance = UserInfo()
    
    var allAdress: NSMutableArray?
    
    class var sharedUserInfo: UserInfo {
        return instance
    }
    
    func hasDefaultAdress() -> Bool {
        
        if allAdress != nil {
            return true
        } else {
            return false
        }
    }
    
    func setAllAdress(adresses: NSMutableArray) {
        allAdress = adresses
    }
    
    func cleanAllAdress() {
        allAdress = nil
    }
    
    func defaultAdress() -> NSDictionary? {
        if allAdress == nil {
            weak var tmpSelf = self
            
            AdressData.loadMyAdressData { (data, error) -> Void in
                
                print(data)
                let dict: NSDictionary = data! as NSDictionary
                let tmparr = dict.value(forKey: "data") as? NSArray
                let arr: NSMutableArray = NSMutableArray(array: tmparr!)
                if arr.count > 0 {
                    tmpSelf!.allAdress = arr
                } else {
                    tmpSelf!.allAdress?.removeAllObjects()
                }
                
//                if (data?.data?.count)! > 0 {
//                    tmpSelf!.allAdress = data!.data!
//                } else {
//                    tmpSelf?.allAdress?.removeAll()
//                }
            }
            
            if (allAdress?.count)! > 1 {
                return allAdress![0] as? NSDictionary
            } else {
                return nil
            }
            
//            return (allAdress?.count)! > 1 ? allAdress?[0] : NSDictionary()
        } else {
            return allAdress![0] as? NSDictionary
        }
    }
    
    func setDefaultAdress(adress: Adress) {
        if allAdress != nil {
            allAdress?.insert(adress, at: 0)
        } else {
            allAdress = NSMutableArray()
            allAdress?.add(adress)
        }
    }
}
