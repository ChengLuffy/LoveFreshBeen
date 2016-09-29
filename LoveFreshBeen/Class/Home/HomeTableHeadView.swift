//
//  HomeTableHeadView.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class HomeTableHeadView: UIView {
    
    var pageScrollView: PageScrollView?
    var hotView: HotView?
    weak var delegate: HomeTableHeadViewDelegate?
    var tableHeadViewHeight: CGFloat = 0 {
        willSet {
//            NotificationCenter.default.postNotificationName(HomeTableHeadViewHeightDidChange, object: newValue)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:HomeTableHeadViewHeightDidChange), object: newValue)
            frame = CGRect(x:0, y:-newValue, width:ScreenWidth, height:newValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildPageScrollView()
        
        buildHotView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 模型的set方法
    var headData: NSDictionary? {
        didSet {
            pageScrollView?.headData = headData
            hotView!.headData = headData?.value(forKey: "data") as! NSDictionary?
        }
    }
    // MARK: 初始化子控件
    func buildPageScrollView() {
        weak var tmpSelf = self
        pageScrollView = PageScrollView(frame: CGRect.zero, placeholder: UIImage(named: "v2_placeholder_full_size")!, focusImageViewClick: { (index) -> Void in
            if tmpSelf!.delegate != nil && ((tmpSelf!.delegate?.responds(to: Selector(("tableHeadView:focusImageViewClick:")))) != nil) {
                //tableHeadView!(tmpSelf!, focusImageViewClick: index)
                tmpSelf!.delegate!.tableHeadView(headView: tmpSelf!, iconClick: index)
            }
        })

        addSubview(pageScrollView!)
    }
    
    func buildHotView() {
        weak var tmpSelf = self
        hotView = HotView(frame: CGRect.zero, iconClick: { (index) -> Void in
            if tmpSelf!.delegate != nil && ((tmpSelf!.delegate?.responds(to: Selector(("tableHeadView:iconClick:")))) != nil) {
                tmpSelf!.delegate!.tableHeadView(headView: tmpSelf!, iconClick: index)
            }
        })
        hotView?.backgroundColor = UIColor.white
        addSubview(hotView!)
    }
    
    //MARK: 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pageScrollView?.frame = CGRect(x:0, y:0, width:ScreenWidth, height:ScreenWidth * 0.31)
        
        hotView?.frame.origin = CGPoint(x:0, y:(pageScrollView?.frame)!.maxY)
        
        tableHeadViewHeight = hotView!.frame.maxY
    }
}

// - MARK: Delegate
@objc protocol HomeTableHeadViewDelegate: NSObjectProtocol {
    @objc func tableHeadView(headView: HomeTableHeadView, focusImageViewClick index: Int)
    @objc func tableHeadView(headView: HomeTableHeadView, iconClick index: Int)
}
