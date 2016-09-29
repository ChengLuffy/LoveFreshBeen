//
//  IdeaViewController.swift
//  LoveFreshBeen
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class IdeaViewController: BaseViewController {
    
    private let margin: CGFloat = 15
    private var promptLabel: UILabel!
    private var iderTextView: PlaceholderTextView!
    weak var mineVC: MineViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        buildRightItemButton()
        
        buildPlaceholderLabel()
        
        buildIderTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        iderTextView.becomeFirstResponder()
    }
    
    // MARK: - Build UI
    private func setUpUI() {
        view.backgroundColor = LFBGlobalBackgroundColor
        navigationItem.title = "意见反馈"
    }
    
    private func buildRightItemButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButton(title: "发送", titleColor: UIColor.colorWithCustom(r: 100, g: 100, b: 100), target: self, action: #selector(IdeaViewController.rightItemClick))
    }
    
    private func buildPlaceholderLabel() {
        promptLabel = UILabel(frame: CGRect(x:margin, y:5, width:ScreenWidth - 2 * margin, height:50))
        promptLabel.text = "你的批评和建议能帮助我们更好的完善产品,请留下你的宝贵意见!"
        promptLabel.numberOfLines = 2;
        promptLabel.textColor = UIColor.black
        promptLabel.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(promptLabel)
    }
    
    private func buildIderTextView() {
        iderTextView = PlaceholderTextView(frame: CGRect(x:margin, y:promptLabel.frame.maxY + 10, width:ScreenWidth - 2 * margin, height:150))
        iderTextView.placeholder = "请输入宝贵意见(300字以内)"
        view.addSubview(iderTextView)
    }
    
    // MARK: - Action
    func rightItemClick() {
        
        if iderTextView.text == nil || 0 == iderTextView.text?.characters.count {
            ProgressHUDManager.showImage(image: UIImage(named: "v2_orderSuccess")!, status: "请输入意见,心里空空的")
        } else if (iderTextView.text?.characters.count)! < 5 {
            ProgressHUDManager.showImage(image: UIImage(named: "v2_orderSuccess")!, status: "请输入超过5个字啊亲~")
        } else if (iderTextView.text?.characters.count)! >= 300 {
            ProgressHUDManager.showImage(image: UIImage(named: "v2_orderSuccess")!, status: "说的太多了,臣妾做不到啊~")
        } else {
            ProgressHUDManager.showWithStatus(status: "发送中")
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                self.navigationController?.popViewController(animated: true)
                self.mineVC?.iderVCSendIderSuccess = true
                ProgressHUDManager.dismiss()
            })
//            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
//            dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
//                self.navigationController?.popViewControllerAnimated(true)
//                self.mineVC?.iderVCSendIderSuccess = true
//                ProgressHUDManager.dismiss()
//            })
        }
    }
}
