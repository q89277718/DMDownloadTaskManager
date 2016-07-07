//
//  CreateTaskViewController.swift
//  DMDownloadTaskManager
//
//  Created by 夏路遥 on 16/7/7.
//  Copyright © 2016年 xialuyao. All rights reserved.
//

import UIKit

class ModifyTaskViewController: UIViewController {

    let taskManger = DownloadTaskDataManager.shareInstance
    
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var urlInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var tagsTableView: UITableView!
    
    var taskData : DownloadTaskEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge.None
        
        let saveBtn = UIBarButtonItem.init(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ModifyTaskViewController.saveTask))
        self.navigationItem.rightBarButtonItem = saveBtn
        
        if self.taskData != nil {
            self.titleInput.text = self.taskData!.title
            self.urlInput.text = self.taskData!.url
            self.descriptionInput.text = self.taskData!.description
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func saveTask(){
        if self.titleInput.text == "" {
            let alertView = UIAlertView()
            alertView.title = "错误提示"
            alertView.message = "标题不能为空"
            alertView.addButtonWithTitle("确定")
            alertView.cancelButtonIndex = 0
            alertView.delegate=self
            alertView.show()
        } else {
            if self.taskData == nil {
                let task = DownloadTaskEntity(title: self.titleInput.text, url: self.urlInput.text, description: self.descriptionInput.text, tagsArr: [])
                self.taskManger.addTask(task)
            } else {
                self.taskData!.title = self.titleInput.text
                self.taskData!.url = self.urlInput.text
                self.taskData!.description = self.descriptionInput.text
            }
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    convenience init(taskData:DownloadTaskEntity){
        self.init(nibName: "ModifyTaskViewController", bundle: NSBundle.mainBundle());
        self.taskData = taskData
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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