//
//  SearchProductViewController.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class SearchProductViewController: AnimationViewController {
    
    let contentScrollView = UIScrollView(frame: ScreenBounds)
    let searchBar = UISearchBar()
    var hotSearchView: SearchView?
    var historySearchView: SearchView?
    let cleanHistoryButton: UIButton = UIButton()
    var searchCollectionView: LFBCollectionView?
    var goodses: [NSDictionary]?
    var collectionHeadView: NotSearchProductsView?
    var yellowShopCar: YellowShopCarView?
    
    // MARK: - Lief Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildContentScrollView()
        
        buildSearchBar()
        
        buildCleanHistorySearchButton()
        
        loadHotSearchButtonData()
        
        loadHistorySearchButtonData()
        
        buildsearchCollectionView()
        
        buildYellowShopCar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = LFBNavigationBarWhiteBackgroundColor
        
        if searchCollectionView != nil && (goodses?.count)! > 0 {
            searchCollectionView!.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LFBSearchViewControllerDeinit"), object: nil)
    }
    
    // MARK: - Build UI
    private func buildContentScrollView() {
        contentScrollView.backgroundColor = view.backgroundColor
        contentScrollView.alwaysBounceVertical = true
        contentScrollView.delegate = self
        view.addSubview(contentScrollView)
    }
    
    private func buildSearchBar() {
        
        (navigationController as! BaseNavigationController).backBtn.frame = CGRect(x:0, y:0, width:10, height:40)
        
        let tmpView = UIView(frame: CGRect(x:0, y:0, width:ScreenWidth * 0.8, height:30))
        tmpView.backgroundColor = UIColor.white
        tmpView.layer.masksToBounds = true
        tmpView.layer.cornerRadius = 6
        tmpView.layer.borderColor = UIColor(red: 100 / 255.0, green: 100 / 255.0, blue: 100 / 255.0, alpha: 1).cgColor
        tmpView.layer.borderWidth = 0.2
        let image = UIImage.createImageFromView(view: tmpView)
        
        searchBar.frame = CGRect(x:0, y:0, width:ScreenWidth * 0.9, height:30)
        searchBar.placeholder = "请输入商品名称"
        searchBar.barTintColor = UIColor.white
        searchBar.keyboardType = UIKeyboardType.default
        searchBar.setSearchFieldBackgroundImage(image, for: .normal)
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        
        let navVC = navigationController as! BaseNavigationController
        let leftBtn = navigationItem.leftBarButtonItem?.customView as? UIButton
        leftBtn!.addTarget(self, action: #selector(SearchProductViewController.leftButtonClcik), for: UIControlEvents.touchUpInside)
        navVC.isAnimation = false
    }
    
    private func buildYellowShopCar() {
        
        weak var tmpSelf = self
        
        yellowShopCar = YellowShopCarView(frame: CGRect(x:ScreenWidth - 70, y:ScreenHeight - 70 - NavigationH, width:61, height:61), shopViewClick: { () -> () in
            let shopCarVC = ShopCartViewController()
            let nav = BaseNavigationController(rootViewController: shopCarVC)
            tmpSelf!.present(nav, animated: true, completion: nil)
        })
        yellowShopCar?.isHidden = true
        view.addSubview(yellowShopCar!)
    }
    
    private func loadHotSearchButtonData() {
        var array: [String]?
        var historySearch = UserDefaults.standard.object(forKey: LFBSearchViewControllerHistorySearchArray) as? [String]
        if historySearch == nil {
            historySearch = [String]()
            UserDefaults.standard.set(historySearch, forKey: LFBSearchViewControllerHistorySearchArray)
        }
        weak var tmpSelf = self
        let pathStr = Bundle.main.path(forResource: "SearchProduct", ofType: nil)
        let data = NSData(contentsOfFile: pathStr!)
        if data != nil {
            let dict: NSDictionary = (try! JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments)) as! NSDictionary
            array = (dict.object(forKey: "data")! as! NSDictionary).object(forKey: "hotquery") as? [String]
            if (array?.count)! > 0 {
                hotSearchView = SearchView(frame: CGRect(x:10, y:20, width:ScreenWidth - 20, height:100), searchTitleText: "热门搜索", searchButtonTitleTexts: array!) { (sender) -> () in
                    let str = sender.title(for: UIControlState.normal)
                    tmpSelf!.writeHistorySearchToUserDefault(str: str!)
                    tmpSelf!.searchBar.text = sender.title(for: UIControlState.normal)
                    tmpSelf!.loadProductsWithKeyword(keyWord: sender.title(for: UIControlState.normal)!)
                }
                hotSearchView!.frame.size.height = hotSearchView!.searchHeight
                
                contentScrollView.addSubview(hotSearchView!)
            }
        }
    }
    
    private func loadHistorySearchButtonData() {
        if historySearchView != nil {
            historySearchView?.removeFromSuperview()
            historySearchView = nil
        }
        
        weak var tmpSelf = self;
        let array = UserDefaults.standard.object(forKey: LFBSearchViewControllerHistorySearchArray) as? [String]
        if (array?.count)! > 0 {
            historySearchView = SearchView(frame: CGRect(x:10, y:hotSearchView!.frame.maxY + 20, width:ScreenWidth - 20, height:0), searchTitleText: "历史记录", searchButtonTitleTexts: array!, searchButtonClickCallback: { (sender) -> () in
                tmpSelf!.searchBar.text = sender.title(for: UIControlState.normal)
                tmpSelf!.loadProductsWithKeyword(keyWord: sender.title(for: UIControlState.normal)!)
            })
            historySearchView!.frame.size.height = historySearchView!.searchHeight
            
            contentScrollView.addSubview(historySearchView!)
            updateCleanHistoryButton(hidden: false)
        }
    }
    
    private func buildCleanHistorySearchButton() {
        cleanHistoryButton.setTitle("清 空 历 史", for: UIControlState.normal)
        cleanHistoryButton.setTitleColor(UIColor.colorWithCustom(r: 163, g: 163, b: 163), for: UIControlState.normal)
        cleanHistoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cleanHistoryButton.backgroundColor = view.backgroundColor
        cleanHistoryButton.layer.cornerRadius = 5
        cleanHistoryButton.layer.borderColor = UIColor.colorWithCustom(r: 200, g: 200, b: 200).cgColor
        cleanHistoryButton.layer.borderWidth = 0.5
        cleanHistoryButton.isHidden = true
        cleanHistoryButton.addTarget(self, action: #selector(SearchProductViewController.cleanSearchHistorySearch), for: UIControlEvents.touchUpInside)
        contentScrollView.addSubview(cleanHistoryButton)
    }
    
    private func updateCleanHistoryButton(hidden: Bool) {
        if historySearchView != nil {
            cleanHistoryButton.frame = CGRect(x:0.1 * ScreenWidth, y:historySearchView!.frame.maxY + 20, width:ScreenWidth * 0.8, height:40)
        }
        cleanHistoryButton.isHidden = hidden
    }
    
    private func buildsearchCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: HomeCollectionViewCellMargin, bottom: 0, right: HomeCollectionViewCellMargin)
        layout.headerReferenceSize = CGSize(width:0, height:HomeCollectionViewCellMargin)
        
        searchCollectionView = LFBCollectionView(frame: CGRect(x:0, y:0, width:ScreenWidth, height:ScreenHeight - 64), collectionViewLayout: layout)
        searchCollectionView!.delegate = self
        searchCollectionView!.dataSource = self
        searchCollectionView!.backgroundColor = LFBGlobalBackgroundColor
        searchCollectionView!.register(HomeCell.self, forCellWithReuseIdentifier: "Cell")
        searchCollectionView?.isHidden = true
        collectionHeadView = NotSearchProductsView(frame: CGRect(x:0, y:-80, width:ScreenWidth, height:80))
        searchCollectionView?.addSubview(collectionHeadView!)
        searchCollectionView?.contentInset = UIEdgeInsetsMake(80, 0, 30, 0)
        searchCollectionView?.register(HomeCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView")
        view.addSubview(searchCollectionView!)
    }
    
    // MARK: - Private Method
    func writeHistorySearchToUserDefault(str: String) {
        var historySearch = UserDefaults.standard.object(forKey: LFBSearchViewControllerHistorySearchArray) as? [String]
        for text in historySearch! {
            if text == str {
                return
            }
        }
        historySearch!.append(str)
        UserDefaults.standard.set(historySearch, forKey: LFBSearchViewControllerHistorySearchArray)
        loadHistorySearchButtonData()
    }
    
    // MARK: - Action
    func cleanSearchHistorySearch() {
        var historySearch = UserDefaults.standard.object(forKey: LFBSearchViewControllerHistorySearchArray) as? [String]
        historySearch?.removeAll()
        UserDefaults.standard.set(historySearch, forKey: LFBSearchViewControllerHistorySearchArray)
        loadHistorySearchButtonData()
        updateCleanHistoryButton(hidden: true)
    }
    
    func leftButtonClcik() {
        searchBar.endEditing(false)
    }
    
    // MARK: - Private Method
    func loadProductsWithKeyword(keyWord: String?) {
        if keyWord == nil || keyWord?.characters.count == 0 {
            return
        }
        
        ProgressHUDManager.setBackgroundColor(color: UIColor.white)
        ProgressHUDManager .showWithStatus(status: "正在全力加载")
        
        weak var tmpSelf = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            SearchProducts.loadSearchData { (data, error) -> Void in
                if ((data?["data"] as! NSArray).count) > 0 {
                    tmpSelf?.goodses = data?["data"] as? [NSDictionary]
                    tmpSelf?.searchCollectionView?.isHidden = false
                    tmpSelf?.yellowShopCar?.isHidden = false
                    tmpSelf?.searchCollectionView?.reloadData()
                    tmpSelf?.collectionHeadView?.setSearchProductLabelText(text: keyWord!)
                    tmpSelf?.searchCollectionView?.setContentOffset(CGPoint(x:0, y:-80), animated: false)
                    ProgressHUDManager.dismiss()
                }
            }

        }
//        let time = dispatch_time(DISPATCH_TIME_NOW,Int64(1.0 * Double(NSEC_PER_SEC)))
//        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
//            SearchProducts.loadSearchData { (data, error) -> Void in
//                if data?.data?.count > 0 {
//                    tmpSelf?.goodses = data!.data!
//                    tmpSelf?.searchCollectionView?.hidden = false
//                    tmpSelf?.yellowShopCar?.hidden = false
//                    tmpSelf?.searchCollectionView?.reloadData()
//                    tmpSelf?.collectionHeadView?.setSearchProductLabelText(keyWord!)
//                    tmpSelf?.searchCollectionView?.setContentOffset(CGPointMake(0, -80), animated: false)
//                    ProgressHUDManager.dismiss()
//                }
//            }
//        }
    }
}


extension SearchProductViewController: UISearchBarDelegate, UIScrollViewDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if (searchBar.text?.characters.count)! > 0 {
            
            writeHistorySearchToUserDefault(str: searchBar.text!)
            
            loadProductsWithKeyword(keyWord: searchBar.text!)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        searchBar.endEditing(false)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            searchCollectionView?.isHidden = true
            yellowShopCar?.isHidden = true
        }
    }
}


extension SearchProductViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return goodses?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! HomeCell
        cell.goods = goodses![indexPath.row]
        weak var tmpSelf = self
        cell.addButtonClick = ({ (imageView) -> () in
            tmpSelf?.addProductsToBigShopCarAnimation(imageView: imageView)
        })
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    
        let itemSize = CGSize(width:(ScreenWidth - HomeCollectionViewCellMargin * 2) * 0.5 - 4, height:250)
        
        return itemSize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if (goodses!.count) <= 0 || goodses == nil {
            return CGSize.zero
        }
        
        return CGSize(width:ScreenWidth, height:30)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView", for: indexPath as IndexPath) as! HomeCollectionFooterView

            footerView.setFooterTitle(text: "无更多商品", textColor: UIColor.colorWithCustom(r: 50, g: 50, b: 50))

            return footerView

        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView", for: indexPath as IndexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailVC = ProductDetailViewController(goods: goodses![indexPath.row])
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}





