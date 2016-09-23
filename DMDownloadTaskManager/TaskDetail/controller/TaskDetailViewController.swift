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
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    convenience init(taskData:DownloadTaskEntity){
        self.init(nibName: "TaskDetailViewController", bundle: Bundle.main);
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
        
        
        self.edgesForExtendedLayout = []
        
        self.tagsTableView.register(UITableViewCell.self, forCellReuseIdentifier: taskTagCellIdentifier)
        
        let changeBtn = UIBarButtonItem.init(title: "修改", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TaskDetailViewController.changeTask))
        self.navigationItem.rightBarButtonItem = changeBtn
        
        let backItem = UIBarButtonItem.init()
        backItem.title = "Back"
        self.navigationItem.backBarButtonItem = backItem;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.urlLabel.text = self.taskDetailData?.url
        self.navigationItem.title = self.taskDetailData?.title
        self.descriptionText.text = self.taskDetailData?.descriptionStr
        self.tipLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeTask(){
        let viewController = ModifyTaskViewController(taskData: self.taskDetailData)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskDetailData?.tagsArr?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tagsTableView.dequeueReusableCell(withIdentifier: taskTagCellIdentifier, for: indexPath)
        cell.textLabel?.text = self.taskDetailData!.tagsArr![indexPath.row]
        return cell
    }
    
    @IBAction func OnUrlClick(_ sender: AnyObject) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = self.urlLabel.text
        self.tipLabel.isHidden = false
        weak var weakSelf = self
        let popTime = DispatchTime.now() + .seconds(1);
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            weakSelf?.tipLabel.isHidden = true
        }
    }
    
    @IBAction func OnPreBtnClick(_ sender: AnyObject) {
        
    }
    
    @IBAction func OnShareBtnClick(_ sender: AnyObject) {
        let controller = UIActivityViewController(activityItems: [self.taskDetailData.shareUrl()], applicationActivities: nil)
        
        // Exclude all activities except AirDrop.
        let excludedActivities = [UIActivityType.postToTwitter, UIActivityType.postToFacebook,
        UIActivityType.postToWeibo,
        UIActivityType.message, UIActivityType.mail,
        UIActivityType.print, UIActivityType.copyToPasteboard,
        UIActivityType.assignToContact, UIActivityType.saveToCameraRoll,
        UIActivityType.addToReadingList, UIActivityType.postToFlickr,
        UIActivityType.postToVimeo, UIActivityType.postToTencentWeibo];
        controller.excludedActivityTypes = excludedActivities;
        
        // Present the controller
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func OnDeleteBtnClick(_ sender: AnyObject) {
        let alertVC = UIAlertController.init(title: "提示", message: "是否删除任务", preferredStyle:.alert)
        alertVC.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            if(DownloadTaskDataManager.shareInstance.removeTaskOfId(id: self.taskDetailData.id)){
                self.navigationController!.popViewController(animated: true)
            }
        }))
        alertVC.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
        
        
        alertVC.view.alpha = 0.0;
        self.navigationController?.present(alertVC, animated: false, completion: nil)
        
        UIView.animate(withDuration: 0.25) {
            alertVC.view.alpha = 1.0
        }
        alertVC.view.center = CGPoint.init(x: self.view.center.x, y: 0.0);
        let snapBehaviour = UISnapBehavior.init(item: alertVC.view, snapTo: self.view.window!.center)
        snapBehaviour.damping = CGFloat.init(NSNumber.init(value: arc4random() % 100)) / 200.0 + 0.5
        self.animator.addBehavior(snapBehaviour)
    }
    @IBAction func OnNxtBtnClick(_ sender: AnyObject) {
        
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
