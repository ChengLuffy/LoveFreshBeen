//
//  HomeViewController.swift
//  LoveFreshBee
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class HomeViewController: SelectedAdressViewController {
    var flag: Int = -1
    var headView: HomeTableHeadView?
    var collectionView: LFBCollectionView!
    var lastContentOffsetY: CGFloat = 0
    var isAnimation: Bool = false
    var headData: NSDictionary?
    var freshHot: NSDictionary?
    
    // MARK: - Life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHomeNotification()
        
        buildCollectionView()
        
        buildTableHeadView()
        
        buildProessHud()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = LFBNavigationYellowColor
        
        if collectionView != nil {
            collectionView.reloadData()
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LFBSearchViewControllerDeinit"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK:- addNotifiation
    func addHomeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.homeTableHeadViewHeightDidChange(noti:)), name: NSNotification.Name(rawValue: HomeTableHeadViewHeightDidChange), object: nil)
        NotificationCenter.default.addObserver(self, selector: Selector(("goodsInventoryProblem:")), name: NSNotification.Name(rawValue: HomeGoodsInventoryProblem), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.shopCarBuyProductNumberDidChange), name: NSNotification.Name(rawValue: LFBShopCarBuyProductNumberDidChangeNotification), object: nil)
    }
    
    // MARK:- Creat UI
    private func buildTableHeadView() {
        headView = HomeTableHeadView()
        
        headView?.delegate = self
        weak var tmpSelf = self
        
        HeadResources.loadHomeHeadData { (data, error) -> Void in
            if error == nil {
                tmpSelf?.headView?.headData = data
                tmpSelf?.headData = data
                tmpSelf?.collectionView.reloadData()
            }
        }
        
        collectionView.addSubview(headView!)
        FreshHot.loadFreshHotData { (data, error) -> Void in
            tmpSelf?.freshHot = data
            tmpSelf?.collectionView.reloadData()
            tmpSelf?.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        }
    }
    
    private func buildCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: HomeCollectionViewCellMargin, bottom: 0, right: HomeCollectionViewCellMargin)
        layout.headerReferenceSize = CGSize(width:0, height:HomeCollectionViewCellMargin)
        
        collectionView = LFBCollectionView(frame: CGRect(x:0, y:0, width:ScreenWidth, height:ScreenHeight - 64), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = LFBGlobalBackgroundColor
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(HomeCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView")
        collectionView.register(HomeCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView")
        view.addSubview(collectionView)
        
        let refreshHeadView = LFBRefreshHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.headRefresh))
        refreshHeadView?.gifView?.frame = CGRect(x:0, y:30, width:100, height:100)
        collectionView.mj_header = refreshHeadView
    }
    
    // MARK: 刷新
    func headRefresh() {
        headView?.headData = nil
        headData = nil
        freshHot = nil
        var headDataLoadFinish = false
        var freshHotLoadFinish = false
        
        weak var tmpSelf = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            HeadResources.loadHomeHeadData { (data, error) -> Void in
                if error == nil {
                    headDataLoadFinish = true
                    tmpSelf?.headView?.headData = data
                    tmpSelf?.headData = data
                    if headDataLoadFinish && freshHotLoadFinish {
                        tmpSelf?.collectionView.reloadData()
                        tmpSelf?.collectionView.mj_header.endRefreshing()
                    }
                }
            }
            
            FreshHot.loadFreshHotData { (data, error) -> Void in
                freshHotLoadFinish = true
                tmpSelf?.freshHot = data
                if headDataLoadFinish && freshHotLoadFinish {
                    tmpSelf?.collectionView.reloadData()
                    tmpSelf?.collectionView.mj_header.endRefreshing()
                }
            }
        }
//        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.8 * Double(NSEC_PER_SEC)))
//        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
//            HeadResources.loadHomeHeadData { (data, error) -> Void in
//                if error == nil {
//                    headDataLoadFinish = true
//                    tmpSelf?.headView?.headData = data
//                    tmpSelf?.headData = data
//                    if headDataLoadFinish && freshHotLoadFinish {
//                        tmpSelf?.collectionView.reloadData()
//                        tmpSelf?.collectionView.mj_header.endRefreshing()
//                    }
//                }
//            }
//            
//            FreshHot.loadFreshHotData { (data, error) -> Void in
//                freshHotLoadFinish = true
//                tmpSelf?.freshHot = data
//                if headDataLoadFinish && freshHotLoadFinish {
//                    tmpSelf?.collectionView.reloadData()
//                    tmpSelf?.collectionView.mj_header.endRefreshing()
//                }
//            }
//        }
    }
    
    private func buildProessHud() {
        ProgressHUDManager.setBackgroundColor(color: UIColor.colorWithCustom(r: 240, g: 240, b: 240))
        ProgressHUDManager.setFont(font: UIFont.systemFont(ofSize: 16))
    }
    
    // MARK: Notifiation Action
    func homeTableHeadViewHeightDidChange(noti: NSNotification) {
        collectionView!.contentInset = UIEdgeInsetsMake(noti.object as! CGFloat, 0, NavigationH, 0)
        collectionView!.setContentOffset(CGPoint(x: 0, y: -(collectionView!.contentInset.top)), animated: false)
        lastContentOffsetY = collectionView.contentOffset.y
    }
    
    func goodsInventoryProblem(noti: NSNotification) {
        if let goodsName = noti.object as? String {
            ProgressHUDManager.showImage(image: UIImage(named: "v2_orderSuccess")!, status: goodsName + "  库存不足了\n先买这么多, 过段时间再来看看吧~")
        }
    }
    
    func shopCarBuyProductNumberDidChange() {
        collectionView.reloadData()
    }
}

// MARK:- HomeHeadViewDelegate TableHeadViewAction
extension HomeViewController: HomeTableHeadViewDelegate {
    func tableHeadView(headView: HomeTableHeadView, focusImageViewClick index: Int) {
        if (((headData?["data"] as! NSDictionary)["focus"] as! NSArray).count) > 0 {
            let path = Bundle.main.path(forResource: "FocusURL", ofType: "plist")
            let array = NSArray(contentsOfFile: path!)
            let webVC = WebViewController(navigationTitle: (((headData?["data"] as! NSDictionary)["focus"] as! NSArray)[index] as! NSDictionary).value(forKey: "name") as! String, urlStr: array![index] as! String)
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    func tableHeadView(headView: HomeTableHeadView, iconClick index: Int) {
        if (((headData?["data"] as! NSDictionary)["icons"] as! NSArray).count) > 0 {
            let webVC = WebViewController(navigationTitle: (((headData?["data"] as! NSDictionary)["icons"] as! NSArray)[index] as! NSDictionary).value(forKey: "name") as! String, urlStr: (((headData?["data"] as! NSDictionary)["icons"] as! NSArray)[index] as! NSDictionary).value(forKey: "customURL") as! String)
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
}

// MARK:- UICollectionViewDelegate UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (((headData?["data"] as! NSDictionary)["icons"] as! NSArray).count) <= 0 || ((freshHot?["data"] as! NSArray).count) <= 0 {
            return 0
        }
        
        if section == 0 {
            return ((headData?["data"] as! NSDictionary)["activities"] as! NSArray).count 
        } else if section == 1 {
            return (freshHot?["data"] as! NSArray).count
        }
        
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! HomeCell
        if ((headData?["data"] as! NSDictionary)["activities"] as! NSArray).count <= 0 {
            return cell
        }
        
        if indexPath.section == 0 {
            cell.activities = ((headData?["data"] as! NSDictionary)["activities"] as! NSArray)[indexPath.row] as? NSDictionary
        } else if indexPath.section == 1 {
            cell.goods = (freshHot?["data"] as! NSArray)[indexPath.row] as? NSDictionary
            weak var tmpSelf = self
            cell.addButtonClick = ({ (imageView) -> () in
                tmpSelf?.addProductsAnimation(imageView: imageView)
            })
        }
        
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (((headData?["data"] as! NSDictionary) ["activities"] as! NSArray).count) <= 0 || ((freshHot?["data"] as! NSArray).count) <= 0 {
            return 0
        }
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemSize = CGSize.zero
        if indexPath.section == 0 {
            itemSize = CGSize(width:ScreenWidth - HomeCollectionViewCellMargin * 2, height:140)
        } else if indexPath.section == 1 {
            itemSize = CGSize(width:(ScreenWidth - HomeCollectionViewCellMargin * 2) * 0.5 - 4, height:260)
        }
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width:ScreenWidth, height:HomeCollectionViewCellMargin)
        } else if section == 1 {
            return CGSize(width:ScreenWidth, height:HomeCollectionViewCellMargin * 2)
        }
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width:ScreenWidth, height:HomeCollectionViewCellMargin)
        } else if section == 1 {
            return CGSize(width:ScreenWidth, height:HomeCollectionViewCellMargin * 5)
        }
        
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 1) {
            return
        }
        
        if isAnimation {
            startAnimation(view: cell, offsetY: 80, duration: 1.0)
        }
    }
    
    private func startAnimation(view: UIView, offsetY: CGFloat, duration: TimeInterval) {
        
        view.transform = CGAffineTransform(translationX: 0, y: offsetY)
        print(view)
        UIView.animate(withDuration: duration, animations: { () -> Void in
            view.transform = CGAffineTransform.identity
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if indexPath.section == 1 && headData != nil && freshHot != nil && isAnimation {
            startAnimation(view: view, offsetY: 60, duration: 0.8)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 1 && kind == UICollectionElementKindSectionHeader {
            let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath as IndexPath) as! HomeCollectionHeaderView
            
            return headView
        }
        
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView", for: indexPath as IndexPath) as! HomeCollectionFooterView
        
        if indexPath.section == 1 && kind == UICollectionElementKindSectionFooter {
            footerView.showLabel()
            footerView.tag = 100
        } else {
            footerView.hideLabel()
            footerView.tag = 1
        }
        let tap = UITapGestureRecognizer(target: self, action: Selector(("moreGoodsClick:")))
        footerView.addGestureRecognizer(tap)
        
        return footerView
    }
    
    // MARK: 查看更多商品被点击
    func moreGoodsClick(tap: UITapGestureRecognizer) {
        if tap.view?.tag == 100 {
            let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
            tabBarController.setSelectIndex(from: 0, to: 1)
        }

    }
    
    // MARK: - ScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (animationLayers.count) > 0 {
            let transitionLayer = animationLayers[0]
            transitionLayer.isHidden = true
        }
        
        if scrollView.contentOffset.y <= scrollView.contentSize.height {
            isAnimation = lastContentOffsetY < scrollView.contentOffset.y
            lastContentOffsetY = scrollView.contentOffset.y
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let webVC = WebViewController(navigationTitle: (((headData?["data"] as! NSDictionary)["activities"] as! NSArray)[indexPath.row] as! NSDictionary).value(forKey: "name") as! String, urlStr: (((headData?["data"] as! NSDictionary)["activities"] as! NSArray)[indexPath.row] as! NSDictionary).value(forKey: "customURL") as! String)
            navigationController?.pushViewController(webVC, animated: true)
        } else {
            let productVC = ProductDetailViewController(goods: (freshHot?["data"] as! NSArray)[indexPath.row] as! NSDictionary)
            navigationController?.pushViewController(productVC, animated: true)
        }
    }
}

