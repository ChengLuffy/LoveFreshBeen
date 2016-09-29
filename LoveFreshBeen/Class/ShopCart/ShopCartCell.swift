//
//  ShopCartCell.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class ShopCartCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let buyView    = BuyView()
    
    var goods: NSDictionary? {
        didSet {
            if goods?["is_xf"] as! Int == 1 {
                titleLabel.text = "[精选]" + (goods?["name"] as! String)
            } else {
                titleLabel.text = goods?["name"] as? String
            }
            
            priceLabel.text = "$" + (goods?["price"] as! String).cleanDecimalPointZear()
            
            buyView.goods = goods as! NSMutableDictionary?
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.none
        
        titleLabel.frame = CGRect(x:15, y:0, width:ScreenWidth * 0.5, height:ShopCartRowHeight)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.black
        contentView.addSubview(titleLabel)
        
        buyView.frame = CGRect(x:ScreenWidth - 85, y:(ShopCartRowHeight - 25) * 0.55, width:80, height:25)
        contentView.addSubview(buyView)
        
        priceLabel.frame = CGRect(x:buyView.frame.minX - 100 - 5, y:0, width:100, height:ShopCartRowHeight)
        priceLabel.textAlignment = NSTextAlignment.right
        contentView.addSubview(priceLabel)
        
        let lineView = UIView(frame: CGRect(x:10, y:ShopCartRowHeight - 0.5, width:ScreenWidth - 10, height:0.5))
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        contentView.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static private let identifier = "ShopCarCell"
    
    class func shopCarCell(tableView: UITableView) -> ShopCartCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ShopCartCell
        
        if cell == nil {
            cell = ShopCartCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        
        return cell!
    }
    
}
