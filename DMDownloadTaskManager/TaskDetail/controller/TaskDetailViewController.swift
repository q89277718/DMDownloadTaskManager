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
        
        let backItem = UIBarButtonItem.init()
        backItem.title = "Back"
        self.navigationItem.backBarButtonItem = backItem;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.urlLabel.text = self.taskDetailData?.url
        self.navigationItem.title = self.taskDetailData?.title
        self.descriptionText.text = self.taskDetailData?.descriptionStr
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
        return self.taskDetailData?.tagsArr?.count ?? 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tagsTableView.dequeueReusableCellWithIdentifier(taskTagCellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = self.taskDetailData!.tagsArr![indexPath.row]
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
    
    @IBAction func OnPreBtnClick(sender: AnyObject) {
        
    }
    
    @IBAction func OnShareBtnClick(sender: AnyObject) {
        let controller = UIActivityViewController(activityItems: [self.taskDetailData.shareUrl()], applicationActivities: nil)
        
        // Exclude all activities except AirDrop.
        let excludedActivities = [UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
        UIActivityTypePostToWeibo,
        UIActivityTypeMessage, UIActivityTypeMail,
        UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
        UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
        UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
        UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
        controller.excludedActivityTypes = excludedActivities;
        
        // Present the controller
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func OnDeleteBtnClick(sender: AnyObject) {
        let alertVC = UIAlertController.init(title: "提示", message: "是否删除任务", preferredStyle:.Alert)
        alertVC.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
            DownloadTaskDataManager.shareInstance.removeTaskOfId(self.taskDetailData.id)
            self.navigationController?.popViewControllerAnimated(true)
        }))
        alertVC.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        
        
        alertVC.view.alpha = 0.0;
        self.navigationController?.presentViewController(alertVC, animated: false, completion: nil)
        
        UIView.animateWithDuration(0.25) {
            alertVC.view.alpha = 1.0
        }
        alertVC.view.center = CGPointMake(self.view.center.x, 0.0)
        let snapBehaviour = UISnapBehavior.init(item: alertVC.view, snapToPoint: self.view.window!.center)
        snapBehaviour.damping = CGFloat.init(NSNumber.init(int: rand() % 100)) / 200.0 + 0.5
        self.animator.addBehavior(snapBehaviour)
    }
    @IBAction func OnNxtBtnClick(sender: AnyObject) {
        
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
