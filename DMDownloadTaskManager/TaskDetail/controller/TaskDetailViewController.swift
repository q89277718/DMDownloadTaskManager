//
//  TaskDetailViewController.swift
//  DMDownloadTaskManager
//
//  Created by 夏路遥 on 16/7/6.
//  Copyright © 2016年 xialuyao. All rights reserved.
//

import UIKit

let taskTagCellIdentifier = "taskTagCellIdentifier"

class TaskDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var tagsTableView: UITableView!
    @IBOutlet weak var descriptionText : UITextView!
    @IBOutlet weak var tipLabel: UILabel!
    
    var taskDetailData : DownloadTaskEntity!
    
    ///------------------坑爹的初始化--------------------start
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    convenience init(taskData:DownloadTaskEntity){
        self.init(nibName: "TaskDetailViewController", bundle: NSBundle.mainBundle());
        self.taskDetailData = taskData
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    ///------------------坑爹的初始化--------------------end
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tagsTableView.delegate = self
        self.tagsTableView.dataSource = self
        
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.tagsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: taskTagCellIdentifier)
        
        let changeBtn = UIBarButtonItem.init(title: "修改", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TaskDetailViewController.changeTask))
        self.navigationItem.rightBarButtonItem = changeBtn
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.urlLabel.text = self.taskDetailData?.url
        self.navigationItem.title = self.taskDetailData?.title
        self.descriptionText.text = self.taskDetailData?.description
        self.tipLabel.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeTask(){
        let viewController = ModifyTaskViewController(taskData: self.taskDetailData)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskDetailData!.tagsArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tagsTableView.dequeueReusableCellWithIdentifier(taskTagCellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = self.taskDetailData!.tagsArr[indexPath.row]
        return cell
    }
    
    @IBAction func OnUrlClick(sender: AnyObject) {
        let pasteBoard = UIPasteboard.generalPasteboard()
        pasteBoard.string = self.urlLabel.text
        self.tipLabel.hidden = false
        weak var weakSelf = self
        let popTime = dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue()) {
            weakSelf?.tipLabel.hidden = true
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
