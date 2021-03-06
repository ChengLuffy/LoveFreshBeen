//
//  MineViewController.swift
//  LoveFreshBee
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class MineViewController: BaseViewController {
    
    private var headView: MineHeadView!
    private var tableView: LFBTableView!
    private var headViewHeight: CGFloat = 150
    private var tableHeadView: MineTabeHeadView!
    private var couponNum: Int = 0
    let shareActionSheet: LFBActionSheet = LFBActionSheet()
    
    // MARK: Flag
    var iderVCSendIderSuccess = false
    
    // MARK: Lazy Property
    lazy var mines: [MineCellModel] = {
        let mines = MineCellModel.loadMineCellModels()
        return mines
        }()
    
    // MARK:- view life circle
    override func loadView() {
        super.loadView()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        
        weak var tmpSelf = self
        Mine.loadMineData { (data, error) -> Void in
            if error == nil {
                if (((data?["data"] as! NSDictionary)["availble_coupon_num"]) as! Int) > 0 {
                    tmpSelf!.couponNum = (((data?["data"] as! NSDictionary)["availble_coupon_num"]) as! Int)
                    tmpSelf!.tableHeadView.setCouponNumer(number: (((data?["data"] as! NSDictionary)["availble_coupon_num"]) as! Int))
                } else {
                    tmpSelf!.tableHeadView.setCouponNumer(number: 0)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if iderVCSendIderSuccess {
            ProgressHUDManager.showSuccessWithStatus(string: "已经收到你的意见了,我们会刚正面的,放心吧~~")
            iderVCSendIderSuccess = false
        }
    }
    

    // MARK:- Private Method
    // MARK: Build UI
    private func buildUI() {
        
        weak var tmpSelf = self
        headView =  MineHeadView(frame: CGRect(x:0, y:0, width:ScreenWidth, height:headViewHeight), settingButtonClick: { () -> Void in
            let settingVc = SettingViewController()
            tmpSelf!.navigationController?.pushViewController(settingVc, animated: true)
        })
        view.addSubview(headView)
        
        buildTableView()
    }
    
    private func buildTableView() {
        tableView = LFBTableView(frame: CGRect(x:0, y:headViewHeight, width:ScreenWidth, height:ScreenHeight - headViewHeight), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 46
        view.addSubview(tableView)
        
        weak var tmpSelf = self
        tableHeadView = MineTabeHeadView(frame: CGRect(x:0, y:0, width:ScreenWidth, height:70))
        // 点击headView回调
        tableHeadView.mineHeadViewClick = { (type) -> () in
            switch type {
            case .Order:
                let orderVc = OrderViewController()
                tmpSelf!.navigationController?.pushViewController(orderVc, animated: true)
                break
            case .Coupon:
                let couponVC = CouponViewController()
                tmpSelf!.navigationController!.pushViewController(couponVC, animated: true)
                break
            case .Message:
                let message = MessageViewController()
                tmpSelf!.navigationController?.pushViewController(message, animated: true)
                break
            }
        }
        
        tableView.tableHeaderView = tableHeadView
    }
}

/// MARK:- UITableViewDataSource UITableViewDelegate
extension MineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MineCell.cellFor(tableView: tableView)
        
        if 0 == indexPath.section {
            cell.mineModel = mines[indexPath.row]
        } else if 1 == indexPath.section {
            cell.mineModel = mines[2]
        } else {
            if indexPath.row == 0 {
                cell.mineModel = mines[3]
            } else {
                cell.mineModel = mines[4]
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 0 == section {
            return 2
        } else if (1 == section) {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if 0 == indexPath.section {
            if 0 == indexPath.row {
                let adressVC = MyAdressViewController()
                navigationController?.pushViewController(adressVC, animated: true)
            } else {
                let myShopVC = MyShopViewController()
                navigationController?.pushViewController(myShopVC, animated: true)
            }
        } else if 1 == indexPath.section {
            shareActionSheet.showActionSheetViewShowInView(inView: view) { (shareType) -> () in
                ShareManager.shareToShareType(shareType: shareType, vc: self)
            }
        } else if 2 == indexPath.section {
            if 0 == indexPath.row {
                let helpVc = HelpViewController()
                navigationController?.pushViewController(helpVc, animated: true)
            } else if 1 == indexPath.row {
                let ideaVC = IdeaViewController()
                ideaVC.mineVC = self
                navigationController!.pushViewController(ideaVC, animated: true)
            }
        }
    }
}
