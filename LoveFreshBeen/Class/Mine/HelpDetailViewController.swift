//
//  HelpDetailViewController.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class HelpDetailViewController: BaseViewController {
    
    var questionTableView: LFBTableView?
    var questions: [Question]?
    var lastOpenIndex = -1
    var isOpenCell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "常见问题"
        view.backgroundColor = UIColor.white
        
        buildQuestionTableView()
        
        loadHelpData()
    }
    
    private func buildQuestionTableView() {
        questionTableView = LFBTableView(frame: view.bounds, style: UITableViewStyle.plain)
        questionTableView?.backgroundColor = UIColor.white
        questionTableView?.register(HelpHeadView.self, forHeaderFooterViewReuseIdentifier: "headView")
        questionTableView?.sectionHeaderHeight = 50
        questionTableView!.delegate = self
        questionTableView!.dataSource = self
        questionTableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: NavigationH, right: 0)
        view.addSubview(questionTableView!)
    }
    
    private func loadHelpData() {
        weak var tmpSelf = self
        
        Question.loadQuestions { (questions) -> () in
            tmpSelf!.questions = questions
            tmpSelf!.questionTableView?.reloadData()
        }
    }
}


extension HelpDetailViewController: UITableViewDelegate, UITableViewDataSource, HelpHeadViewDelegate {

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AnswerCell.answerCell(tableView: tableView)
        cell.question = questions![indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lastOpenIndex == section && isOpenCell {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if lastOpenIndex == indexPath.section && isOpenCell {
            return questions![indexPath.section].cellHeight
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return questions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headView") as? HelpHeadView
        headView!.tag = section
        headView?.delegate = self
        let question = questions![section]
        headView?.question = question
        
        return headView!
    }
    
    func headViewDidClck(headView: HelpHeadView) {
        if lastOpenIndex != -1 && lastOpenIndex != headView.tag && isOpenCell {
            let headView = questionTableView?.headerView(forSection: lastOpenIndex) as? HelpHeadView
            headView?.isSelected = false
            
            let deleteIndexPaths = [IndexPath(row: 0, section: lastOpenIndex)]
            isOpenCell = false
            questionTableView?.deleteRows(at: deleteIndexPaths, with: UITableViewRowAnimation.automatic)
        }
        

        if lastOpenIndex == headView.tag && isOpenCell {
            let deleteIndexPaths = [IndexPath(row: 0, section: lastOpenIndex)]
            isOpenCell = false
            questionTableView?.deleteRows(at: deleteIndexPaths, with: UITableViewRowAnimation.automatic)
            return
        }
        
        lastOpenIndex = headView.tag
        isOpenCell = true
        let insertIndexPaths = [IndexPath(row: 0, section: headView.tag)]
        questionTableView?.insertRows(at: insertIndexPaths, with: UITableViewRowAnimation.top)
    }
    
}

