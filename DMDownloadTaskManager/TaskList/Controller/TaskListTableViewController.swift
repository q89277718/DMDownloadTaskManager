//
//  TaskListTableViewController.swift
//  DMDownloadTaskManager
//
//  Created by 夏路遥 on 16/7/6.
//  Copyright © 2016年 xialuyao. All rights reserved.
//

import UIKit

private let cellIdentifier = "testCell"

class TaskListTableViewController: UITableViewController {

    let tasksDataManager = DownloadTaskDataManager.shareInstance
    
    func createTestData() -> Void {
        var titleStr = "test1"
        var urlStr = "test://1"
        var des = "测试案例1"
//        var tags = ["123", "456"]
        var task = DownloadTaskEntity(title: titleStr, url: urlStr, description: des)
        if(self.tasksDataManager.add(task: task)){}
        
        titleStr = "test2"
        urlStr = "test//2"
        des = "测试案例2"
//        tags = ["123", "456"]
        task = DownloadTaskEntity(title: titleStr, url: urlStr, description: des)
        if(self.tasksDataManager.add(task: task)){}
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.createTestData()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        let creatBtn = UIBarButtonItem.init(title: "+", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TaskListTableViewController.createTask))
        self.navigationItem.rightBarButtonItem = creatBtn
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: Notification.DownloadTaskDataDidChangeNotification),
                                                                object: nil, queue: OperationQueue.main)
        {
            (notification:Notification) in
            self.tableView.reloadData()
        }
        self.title = "首页"
        
        let backItem = UIBarButtonItem.init()
        backItem.title = "Back"
        self.navigationItem.backBarButtonItem = backItem;
    }

    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createTask() -> Void {
        let createVC = ModifyTaskViewController()
        self.navigationController?.pushViewController(createVC, animated: true)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasksDataManager.taskCount()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let entity = self.tasksDataManager.taskOfIndex(index: indexPath.row)
        
        cell.textLabel?.text = entity!.title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskData = self.tasksDataManager.taskOfIndex(index: indexPath.row)
        let taskVC = TaskDetailViewController(taskData: taskData!)
        self.navigationController?.pushViewController(taskVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertVC = UIAlertController.init(title: "提示", message: "是否删除任务", preferredStyle:.alert)
            alertVC.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                if(self.tasksDataManager.removeTaskOfIndex(index: indexPath.row)){
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }))
            alertVC.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
            self.navigationController?.present(alertVC, animated: true, completion: nil)
        }
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
