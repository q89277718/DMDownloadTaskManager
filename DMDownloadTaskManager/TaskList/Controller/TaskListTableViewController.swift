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
        self.tasksDataManager.addTask(task)
        
        titleStr = "test2"
        urlStr = "test//2"
        des = "测试案例2"
//        tags = ["123", "456"]
        task = DownloadTaskEntity(title: titleStr, url: urlStr, description: des)
        self.tasksDataManager.addTask(task)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.createTestData()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        let creatBtn = UIBarButtonItem.init(title: "+", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TaskListTableViewController.createTask))
        self.navigationItem.rightBarButtonItem = creatBtn
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasksDataManager.taskCount()
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        let entity = self.tasksDataManager.taskOfIndex(indexPath.row)
        
        cell.textLabel?.text = entity!.title

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let taskData = self.tasksDataManager.taskOfIndex(indexPath.row)
        let taskVC = TaskDetailViewController(taskData: taskData!)
        self.navigationController?.pushViewController(taskVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.tasksDataManager.removeTaskOfIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
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
