//
//  UserShopCarTool.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class UserShopCarTool: NSObject {

    private static let instance = UserShopCarTool()
    
    private var supermarketProducts = [NSDictionary]()
    
    class var sharedUserShopCar: UserShopCarTool {
        return instance
    }
    
    func userShopCarProductsNumber() -> Int {
        return ShopCarRedDotView.sharedRedDotView.buyNumber
    }
    
    func isEmpty() -> Bool {
        return supermarketProducts.count == 0
    }
    
    func addSupermarkProductToShopCar(goods: NSDictionary) {
        for everyGoods in supermarketProducts {
            if (everyGoods )["id"] as? String == goods.value(forKey: "id") as? String {
                return
            }
        }
        
        supermarketProducts.append(goods)
    }
    
    func getShopCarProducts() -> [NSMutableDictionary] {
        return supermarketProducts as! [NSMutableDictionary]
    }
    
    func getShopCarProductsClassifNumber() -> Int {
        return supermarketProducts.count
    }
    
    func removeSupermarketProduct(goods: NSMutableDictionary) {
        for i in 0..<supermarketProducts.count {
            let everyGoods = supermarketProducts[i] 
            if everyGoods["id"] as! String == goods["id"] as! String{
                supermarketProducts.remove(at: i)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LFBShopCarDidRemoveProductNSNotification), object: nil)
                return
            }
        }
    }
    
    func getAllProductsPrice() -> String {
        var allPrice: Double = 0
        for goods in supermarketProducts {
            allPrice = allPrice + Double(goods["partner_price"] as! String)! * Double(goods["userBuyNumber"] as! String)!
        }
        
        return "\(allPrice)".cleanDecimalPointZear()
    }
}
