//
//  ShopCartViewController.swift
//  LoveFreshBee
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class ShopCartViewController: BaseViewController {
    
    let userShopCar = UserShopCarTool.sharedUserShopCar
    
    private let shopImageView         = UIImageView()
    private let emptyLabel            = UILabel()
    private let emptyButton           = UIButton(type: .custom)
    private var receiptAdressView: ReceiptAddressView?
    private var tableHeadView         = UIView()
    private let signTimeLabel         = UILabel()
    private let reserveLabel          = UILabel()
    private let signTimePickerView    = UIPickerView()
    let commentsView          = ShopCartCommentsView()
    private let supermarketTableView  = LFBTableView(frame: CGRect(x:0, y:0, width:ScreenWidth, height:ScreenHeight - 64 - 50), style: .plain)
    private let tableFooterView       = ShopCartSupermarketTableFooterView()
    private var isFristLoadData       = false
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNSNotification()
        
        buildNavigationItem()
        
        buildEmptyUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        weak var tmpSelf = self
        
        if userShopCar.isEmpty() {
            showshopCarEmptyUI()
        } else {
            
            if !ProgressHUDManager.isVisible() {
                ProgressHUDManager.setBackgroundColor(color: UIColor.colorWithCustom(r: 230, g: 230, b: 230))
                ProgressHUDManager.showWithStatus(status: "正在加载商品信息")
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                tmpSelf!.showProductView()
                ProgressHUDManager.dismiss()
            })
//            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.5 * Double(NSEC_PER_SEC)))
//            dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
//                
//                tmpSelf!.showProductView()
//                ProgressHUDManager.dismiss()
//            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK - Add Notification KVO Action
    private func addNSNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(ShopCartViewController.shopCarProductsDidRemove), name: NSNotification.Name(rawValue: LFBShopCarDidRemoveProductNSNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ShopCartViewController.shopCarBuyPriceDidChange), name: NSNotification.Name(rawValue: LFBShopCarBuyPriceDidChangeNotification), object: nil)
    }
    
    func shopCarProductsDidRemove() {
        
        if UserShopCarTool.sharedUserShopCar.isEmpty() {
            showshopCarEmptyUI()
        }
        
        self.supermarketTableView.reloadData()
    }
    
    func shopCarBuyPriceDidChange() {
        tableFooterView.priceLabel.text = UserShopCarTool.sharedUserShopCar.getAllProductsPrice()
    }
    
    // MARK: - Build UI
    private func buildNavigationItem() {
        navigationItem.title = "购物车"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.barButton(image: UIImage(named: "v2_goback")!, target: self, action: #selector(ShopCartViewController.leftNavigitonItemClick))
    }
    
    private func buildEmptyUI() {
        shopImageView.image = UIImage(named: "v2_shop_empty")
        shopImageView.contentMode = UIViewContentMode.center
        shopImageView.frame = CGRect(x:(view.width - shopImageView.width) * 0.5, y:view.height * 0.25, width:shopImageView.width, height:shopImageView.height)
        shopImageView.isHidden = true
        view.addSubview(shopImageView)
        
        emptyLabel.text = "亲,购物车空空的耶~赶紧挑好吃的吧"
        emptyLabel.textColor = UIColor.colorWithCustom(r: 100, g: 100, b: 100)
        emptyLabel.textAlignment = NSTextAlignment.center
        emptyLabel.frame = CGRect(x:0, y:shopImageView.frame.maxY + 55, width:view.width, height:50)
        emptyLabel.font = UIFont.systemFont(ofSize: 16)
        emptyLabel.isHidden = true
        view.addSubview(emptyLabel)
        
        emptyButton.frame = CGRect(x:(view.width - 150) * 0.5, y:emptyLabel.frame.maxY + 15, width:150, height:30)
        emptyButton.setBackgroundImage(UIImage(named: "btn.png"), for: UIControlState.normal)
        emptyButton.setTitle("去逛逛", for: UIControlState.normal)
        emptyButton.setTitleColor(UIColor.colorWithCustom(r: 100, g: 100, b: 100), for: UIControlState.normal)
        emptyButton.addTarget(self, action: #selector(ShopCartViewController.leftNavigitonItemClick), for: UIControlEvents.touchUpInside)
        emptyButton.isHidden = true
        view.addSubview(emptyButton)
    }
    
    private func showProductView() {
        
        if !isFristLoadData {
            
            buildTableHeadView()
            
            buildSupermarketTableView()
            
            isFristLoadData = true
        }
    }
    
    private func buildTableHeadView() {
        tableHeadView.backgroundColor = view.backgroundColor
        tableHeadView.frame = CGRect(x:0, y:0, width:view.width, height:250)
        
        buildReceiptAddress()
        
        buildMarketView()
        
        buildSignTimeView()
        
        buildSignComments()
    }
    
    private func buildSupermarketTableView() {
        supermarketTableView.tableHeaderView = tableHeadView
        tableFooterView.frame = CGRect(x:0, y:ScreenHeight - 64 - 50, width:ScreenWidth, height:50)
        view.addSubview(tableFooterView)
        tableFooterView.delegate = self
        supermarketTableView.delegate = self
        supermarketTableView.dataSource = self
        supermarketTableView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0)
        supermarketTableView.rowHeight = ShopCartRowHeight
        supermarketTableView.backgroundColor = view.backgroundColor
        view.addSubview(supermarketTableView)
    }
    
    private func buildReceiptAddress() {
        
        receiptAdressView = ReceiptAddressView(frame: CGRect(x:0, y:10, width:view.width, height:70), modifyButtonClickCallBack: { () -> () in
            
        })
        
        tableHeadView.addSubview(receiptAdressView!)
        
        if UserInfo.sharedUserInfo.hasDefaultAdress() {
            receiptAdressView?.adress = UserInfo.sharedUserInfo.defaultAdress()
        } else {
            weak var tmpSelf = self
            AdressData.loadMyAdressData { (data, error) -> Void in
                if error == nil {
                    print(data)
                    
//                    if (data!.data?.count)! > 0 {
//                        UserInfo.sharedUserInfo.setAllAdress(adresses: data!.data!)
//                        tmpSelf!.receiptAdressView?.adress = UserInfo.sharedUserInfo.defaultAdress()
//                    }
                }
            }
        }
    }
    
    private func buildMarketView() {
        let markerView = ShopCartMarkerView(frame: CGRect(x:0, y:90, width:ScreenWidth, height:60))
        
        tableHeadView.addSubview(markerView)
    }
    
    private func buildSignTimeView() {
        let signTimeView = UIView(frame: CGRect(x:0, y:150, width:view.width, height:ShopCartRowHeight))
        signTimeView.backgroundColor = UIColor.white
        tableHeadView.addSubview(signTimeView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ShopCartViewController.modifySignTimeViewClick))
        tableHeadView.addGestureRecognizer(tap)
        
        let signTimeTitleLabel = UILabel()
        signTimeTitleLabel.text = "收货时间"
        signTimeTitleLabel.textColor = UIColor.black
        signTimeTitleLabel.font = UIFont.systemFont(ofSize: 15)
        signTimeTitleLabel.sizeToFit()
        signTimeTitleLabel.frame = CGRect(x:15, y:0, width:signTimeTitleLabel.width, height:ShopCartRowHeight)
        signTimeView.addSubview(signTimeTitleLabel)
        
        signTimeLabel.frame = CGRect(x:signTimeTitleLabel.frame.maxX + 10, y:0, width:view.width * 0.5, height:ShopCartRowHeight)
        signTimeLabel.textColor = UIColor.red
        signTimeLabel.font = UIFont.systemFont(ofSize: 15)
        signTimeLabel.text = "闪电送,及时达"
        signTimeView.addSubview(signTimeLabel)
        
        reserveLabel.text = "可预定"
        reserveLabel.backgroundColor = UIColor.white
        reserveLabel.textColor = UIColor.red
        reserveLabel.font = UIFont.systemFont(ofSize: 15)
        reserveLabel.frame = CGRect(x:view.width - 72, y:0, width:60, height:ShopCartRowHeight)
        signTimeView.addSubview(reserveLabel)
        
        let arrowImageView = UIImageView(image: UIImage(named: "icon_go"))
        arrowImageView.frame = CGRect(x:view.width - 15, y:(ShopCartRowHeight - arrowImageView.height) * 0.5, width:arrowImageView.width, height:arrowImageView.height)
        signTimeView.addSubview(arrowImageView)
        
    }
    
    private func buildSignComments() {
        commentsView.frame = CGRect(x:0, y:200, width:view.width, height:ShopCartRowHeight)
        tableHeadView.addSubview(commentsView)
    }
    
    private func lineView(frame: CGRect) -> UIView {
        let lineView = UIView(frame: frame)
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        return lineView
    }
    
    // MARK: - Private Method
    private func showshopCarEmptyUI() {
        shopImageView.isHidden = false
        emptyButton.isHidden = false
        emptyLabel.isHidden = false
        supermarketTableView.isHidden = true
    }
    
    // MARK: -  Action
    func leftNavigitonItemClick() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LFBShopCarBuyProductNumberDidChangeNotification), object: nil)
//        NotificationCenter.default.postNotificationName(LFBShopCarBuyProductNumberDidChangeNotification, object: nil, userInfo: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func modifySignTimeViewClick() {
        print("修改收货时间")
    }
    
    func selectedSignTimeTextFieldDidChange(sender: UIButton) {
        
    }
    
    // MARK: - Override SuperMethod
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        commentsView.textField.endEditing(true)
    }
}

// MARK: - ShopCartSupermarketTableFooterViewDelegate
extension ShopCartViewController: ShopCartSupermarketTableFooterViewDelegate {
    
    func supermarketTableFooterDetermineButtonClick() {
        let orderPayVC = OrderPayWayViewController()
        navigationController?.pushViewController(orderPayVC, animated: true)
    }
}

// MARK: - UITableViewDeletate UITableViewDataSource
extension ShopCartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserShopCarTool.sharedUserShopCar.getShopCarProductsClassifNumber()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ShopCartCell.shopCarCell(tableView: tableView)
        cell.goods = UserShopCarTool.sharedUserShopCar.getShopCarProducts()[indexPath.row]
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        commentsView.textField.endEditing(true)
    }
}





