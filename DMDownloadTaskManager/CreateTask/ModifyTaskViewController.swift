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

        self.edgesForExtendedLayout = []
        
        let saveBtn = UIBarButtonItem.init(title: "保存", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ModifyTaskViewController.saveTask))
        self.navigationItem.rightBarButtonItem = saveBtn
        
        if self.taskData != nil {
            self.titleInput.text = self.taskData!.title
            self.urlInput.text = self.taskData!.url
            self.descriptionInput.text = self.taskData!.descriptionStr
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func saveTask(){
        if self.titleInput.text == "" && self.urlInput.text == ""{
            let alertVC = UIAlertController.init(title: "错误提示", message: "标题和url不能为同时空", preferredStyle:.alert)
            alertVC.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: nil))
            self.navigationController?.present(alertVC, animated: true, completion: nil)
        } else {
            if self.titleInput.text == "" {
                self.titleInput.text = self.urlInput.text
            } else if self.urlInput.text == "" {
                self.urlInput.text = self.titleInput.text
            }
            
            if self.taskData == nil {
                let task = DownloadTaskEntity(title: self.titleInput.text, url: self.urlInput.text, description: self.descriptionInput.text)
                if(self.taskManger.add(task: task)){
                    
                }
            } else {
                self.taskData!.title = self.titleInput.text
                self.taskData!.url = self.urlInput.text
                self.taskData!.descriptionStr = self.descriptionInput.text
                DownloadTaskDataManager.shareInstance.saveTasksToLocal()
            }
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    convenience init(taskData:DownloadTaskEntity){
        self.init(nibName: "ModifyTaskViewController", bundle: Bundle.main);
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
