//
//  ProductDetailViewController.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class ProductDetailViewController: BaseViewController {
    
    private let grayBackgroundColor = UIColor.colorWithCustom(r: 248, g: 248, b: 248)
    
    private var scrollView: UIScrollView?
    private var productImageView: UIImageView?
    private var titleNameLabel: UILabel?
    private var priceView: DiscountPriceView?
    private var presentView: UIView?
    private var detailView: UIView?
    private var brandTitleLabel: UILabel?
    private var detailTitleLabel: UILabel?
    private var promptView: UIView?
    private let nameView = UIView()
    private var detailImageView: UIImageView?
    private var bottomView: UIView?
    private var yellowShopCar: YellowShopCarView?
    private var goods: NSDictionary?
    private var buyView: BuyView?
    private let shareActionSheet: LFBActionSheet = LFBActionSheet()
    
    init () {
        super.init(nibName: nil, bundle: nil)
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView?.backgroundColor = UIColor.white
        scrollView?.bounces = false
        view.addSubview(scrollView!)
        
        productImageView = UIImageView(frame: CGRect(x:0, y:0, width:ScreenWidth, height:400))
        productImageView?.contentMode = UIViewContentMode.scaleAspectFill
        scrollView!.addSubview(productImageView!)
        
        buildLineView(frame: CGRect(x:0, y:productImageView!.frame.maxY - 1, width:ScreenWidth, height:1), addView: productImageView!)
        
        let leftMargin: CGFloat = 15
        
        nameView.frame = CGRect(x:0, y:productImageView!.frame.maxY, width:ScreenWidth, height:80)
        nameView.backgroundColor = UIColor.white
        scrollView!.addSubview(nameView)
        
        titleNameLabel = UILabel(frame: CGRect(x:leftMargin, y:0, width:ScreenWidth, height:60))
        titleNameLabel?.textColor = UIColor.black
        titleNameLabel?.font = UIFont.systemFont(ofSize: 16)
        nameView.addSubview(titleNameLabel!)
        
        buildLineView(frame: CGRect(x:0, y:80 - 1, width:ScreenWidth, height:1), addView: nameView)
        
        presentView = UIView(frame: CGRect(x:0, y:nameView.frame.maxY, width:ScreenWidth, height:50))
        presentView?.backgroundColor = grayBackgroundColor
        scrollView?.addSubview(presentView!)
        
        let presentButton = UIButton(frame: CGRect(x:leftMargin, y:13, width:55, height:24))
        presentButton.setTitle("促销", for: .normal)
        presentButton.backgroundColor = UIColor.colorWithCustom(r: 252, g: 85, b: 88)
        presentButton.layer.cornerRadius = 8
        presentButton.setTitleColor(UIColor.white, for: .normal)
        presentView?.addSubview(presentButton)
        
        let presentLabel = UILabel(frame: CGRect(x:100, y:0, width:ScreenWidth * 0.7, height:50))
        presentLabel.textColor = UIColor.black
        presentLabel.font = UIFont.systemFont(ofSize: 14)
        presentLabel.text = "买一赠一 (赠品有限,赠完为止)"
        presentView?.addSubview(presentLabel)
        
        buildLineView(frame: CGRect(x:0, y:49, width:ScreenWidth, height:1), addView: presentView!)
        
        detailView = UIView(frame: CGRect(x:0, y:presentView!.frame.maxY, width:ScreenWidth, height:150))
        detailView?.backgroundColor = grayBackgroundColor
        scrollView?.addSubview(detailView!)
        
        let brandLabel = UILabel(frame: CGRect(x:leftMargin, y:0, width:80, height:50))
        brandLabel.textColor = UIColor.colorWithCustom(r: 150, g: 150, b: 150)
        brandLabel.text = "品       牌"
        brandLabel.font = UIFont.systemFont(ofSize: 14)
        detailView?.addSubview(brandLabel)
        
        brandTitleLabel = UILabel(frame: CGRect(x:100, y:0, width:ScreenWidth * 0.6, height:50))
        brandTitleLabel?.textColor = UIColor.black
        brandTitleLabel?.font = UIFont.systemFont(ofSize: 14)
        detailView?.addSubview(brandTitleLabel!)
        
        buildLineView(frame: CGRect(x:0, y:50 - 1, width:ScreenWidth, height:1), addView: detailView!)
        
        let detailLabel = UILabel(frame: CGRect(x:leftMargin, y:50, width:80, height:50))
        detailLabel.text = "产品规格"
        detailLabel.textColor = brandLabel.textColor
        detailLabel.font = brandTitleLabel!.font
        detailView?.addSubview(detailLabel)
        
        detailTitleLabel = UILabel(frame: CGRect(x:100, y:50, width:ScreenWidth * 0.6, height:50))
        detailTitleLabel?.textColor = brandTitleLabel!.textColor
        detailTitleLabel?.font = brandTitleLabel!.font
        detailView?.addSubview(detailTitleLabel!)
        
        buildLineView(frame: CGRect(x:0, y:100 - 1, width:ScreenWidth, height:1), addView: detailView!)
        
        let textImageLabel = UILabel(frame: CGRect(x:leftMargin, y:100, width:80, height:50))
        textImageLabel.textColor = brandLabel.textColor
        textImageLabel.font = brandLabel.font
        textImageLabel.text = "图文详情"
        detailView?.addSubview(textImageLabel)
        
        promptView = UIView(frame: CGRect(x:0, y:detailView!.frame.maxY, width:ScreenWidth, height:80))
        promptView?.backgroundColor = UIColor.white
        scrollView?.addSubview(promptView!)
        
        let promptLabel = UILabel(frame: CGRect(x:15, y:5, width:ScreenWidth, height:20))
        promptLabel.text = "温馨提示:"
        promptLabel.textColor = UIColor.black
        promptView?.addSubview(promptLabel)
        
        let promptDetailLabel = UILabel(frame: CGRect(x:15, y:20, width:ScreenWidth - 30, height:60))
        promptDetailLabel.textColor = presentButton.backgroundColor
        promptDetailLabel.numberOfLines = 2
        promptDetailLabel.text = "商品签收后, 如有问题请您在24小时内联系4008484842,并将商品及包装保留好,拍照发给客服"
        promptDetailLabel.font = UIFont.systemFont(ofSize: 14)
        promptView?.addSubview(promptDetailLabel)
        
        buildLineView(frame: CGRect(x:0, y:ScreenHeight - 51 - NavigationH, width:ScreenWidth, height:1), addView: view)
        
        bottomView = UIView(frame: CGRect(x:0, y:ScreenHeight - 50 - NavigationH, width:ScreenWidth, height:50))
        bottomView?.backgroundColor = grayBackgroundColor
        view.addSubview(bottomView!)
        
        let addProductLabel = UILabel(frame: CGRect(x:15, y:0, width:70, height:50))
        addProductLabel.text = "添加商品:"
        addProductLabel.textColor = UIColor.black
        addProductLabel.font = UIFont.systemFont(ofSize: 15)
        bottomView?.addSubview(addProductLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(goods: NSDictionary) {
        self.init()
        self.goods = goods
        productImageView?.sd_setImage(with: URL.init(string: goods.value(forKey: "img") as! String), placeholderImage: UIImage.init(named: "v2_placeholder_square"))
//        productImageView?.sd_setImage(widt: URL.init(string: goods.img!), placeholderImage: UIImage(named: "v2_placeholder_square"))
        titleNameLabel?.text = goods.value(forKey: "name") as! String?
        priceView = DiscountPriceView(price: goods.value(forKey: "price") as! String?, marketPrice: goods.value(forKey: "market_price") as! String?)
        priceView?.frame = CGRect(x:15, y:40, width:ScreenWidth * 0.6, height:40)
        nameView.addSubview(priceView!)
        
        if (goods.value(forKey: "pm_desc") as! String) == "买一赠一" {
            presentView?.frame.size.height = 50
            presentView?.isHidden = false
        } else {
            presentView?.frame.size.height = 0
            presentView?.isHidden = true
            detailView?.frame.origin.y -= 50
            promptView?.frame.origin.y -= 50
        }
        
        brandTitleLabel?.text = goods.value(forKey: "brand_name") as! String?
        detailTitleLabel?.text = goods.value(forKey: "specifics") as! String?
        
        detailImageView = UIImageView(image: UIImage(named: "aaaa"))
        let scale: CGFloat = 320.0 / ScreenWidth
        detailImageView?.frame = CGRect(x:0, y:promptView!.frame.maxY, width:ScreenWidth, height:detailImageView!.height / scale)
        scrollView?.addSubview(detailImageView!)
        scrollView?.contentSize = CGSize(width:ScreenWidth, height:detailImageView!.frame.maxY + 50 + NavigationH)
        
        buildNavigationItem(titleText: goods.value(forKey: "name")! as! String)
        
        buyView = BuyView(frame: CGRect(x:85, y:12, width:80, height:25))
        buyView!.zearIsShow = true
        buyView!.goods = NSMutableDictionary(dictionary: goods)
        bottomView?.addSubview(buyView!)
        
        weak var tmpSelf = self
        yellowShopCar = YellowShopCarView(frame: CGRect(x:ScreenWidth - 70, y:50 - 61 - 10, width:61, height:61), shopViewClick: { () -> () in
            let shopCarVC = ShopCartViewController()
            let nav = BaseNavigationController(rootViewController: shopCarVC)
            tmpSelf!.present(nav, animated: true, completion: nil)
        })
        
        bottomView!.addSubview(yellowShopCar!)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LFBSearchViewControllerDeinit"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = LFBNavigationBarWhiteBackgroundColor
        
        if goods != nil {
            buyView?.goods = NSMutableDictionary(dictionary: goods!)
        }
        
        (navigationController as! BaseNavigationController).isAnimation = true
    }
    
    // MARK: - Build UI
    private func buildLineView(frame: CGRect, addView: UIView) {
        let lineView = UIView(frame: frame)
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        addView.addSubview(lineView)
    }
    
    private func buildNavigationItem(titleText: String) {
        self.navigationItem.title = titleText
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButton(title: "分享", titleColor: UIColor.colorWithCustom(r: 100, g: 100, b: 100), target: self, action: #selector(ProductDetailViewController.rightItemClick))
    }
    
    // MARK: - Action
    func rightItemClick() {
        shareActionSheet.showActionSheetViewShowInView(inView: view) { (shareType) -> () in
            ShareManager.shareToShareType(shareType: shareType, vc: self)
        }
    }
}
