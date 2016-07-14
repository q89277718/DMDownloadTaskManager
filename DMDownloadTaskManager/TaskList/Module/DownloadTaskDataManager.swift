//
//  DownloadTaskDataManager.swift
//  DMDownloadTaskManager
//
//  Created by 夏路遥 on 16/7/6.
//  Copyright © 2016年 xialuyao. All rights reserved.
//

import UIKit

class DownloadTaskDataManager{
    
    enum taskDataLoadState {
        case Unload,loaded
    }
    
    var taskData = Array<DownloadTaskEntity>()
    var maxTaskId : Int!
    var taskDataState: taskDataLoadState
    
    private static let _instance = DownloadTaskDataManager()
    
    class var shareInstance: DownloadTaskDataManager {
        return _instance
    }
    
    init() {
        self.taskDataState = .Unload
        self.loadTasksFromLocal()
        self.maxTaskId = NSUserDefaults.standardUserDefaults().integerForKey("taskMaxId") ?? 0
    }
    
    func addTask(task:DownloadTaskEntity) -> Bool {
        if task.id == -1 {
            task.id = self.maxTaskId + 1
            self.maxTaskId = self.maxTaskId + 1
            NSUserDefaults.standardUserDefaults().setInteger(self.maxTaskId, forKey: "taskMaxId")
        }
        self.taskData.append(task)
        return true
    }
    
    func taskCount() -> Int {
        return self.taskData.count
    }
    
    func taskOfId(id:Int!) -> DownloadTaskEntity? {
        for task in self.taskData {
            if task.id == id {
                return task
            }
        }
        return nil
    }
    
    func removeTaskOfId(id:Int!) -> Bool {
        for index in 0 ... (self.taskData.count - 1){
            if self.taskData[index].id == id {
                self.taskData.removeAtIndex(index)
                return true
            }
        }
        return false
    }
    
    func taskOfIndex(index:Int) -> DownloadTaskEntity? {
        if index >= 0 && index < self.taskData.count {
            return self.taskData[index]
        }
        return nil
    }
    
    func removeTaskOfIndex(index:Int) -> Bool {
        if (index >= 0 && index < self.taskData.count) {
            self.taskData.removeAtIndex(index)
            self.saveTasksToLocal()
            return true
        }
        return false
    }
    
    func saveTasksToLocal() {
        let path: AnyObject=NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        let filePath=path.stringByAppendingPathComponent("task_records.archive")
        //归档
        let array = NSArray.init(array: self.taskData)
        if(NSKeyedArchiver.archiveRootObject(array, toFile: filePath)){
            NSLog("Archive Success")
        }
    }
    
    func loadTasksFromLocal() {
        let path: AnyObject=NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        let filePath=path.stringByAppendingPathComponent("task_records.archive")
        //反归档
        let data=NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? Array<DownloadTaskEntity>
        if data == nil {
            self.taskData = []
        } else {
            self.taskData = data!
        }
    }

    func handleStringArray(stringArray:Array<String>?) -> Bool {
        if stringArray == nil {
            return false
        }
        let tempArr = stringArray!
        if tempArr.count == 0  {
            return false
        }
        var tempStr = tempArr[0]
        if tempStr.characters.count == 0 {
            return false
        }
        if tempStr.hasPrefix("/") {
            tempStr = tempStr.substringFromIndex(tempStr.startIndex.advancedBy(1))
        }
        let entity = DownloadTaskEntity(title: tempStr)
        if tempArr.count > 1 {
            entity.url = tempArr[1]
        }
        
        if tempArr.count > 2 {
            entity.descriptionStr = tempArr[2]
        }
        self.addTask(entity)
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: NSNotification.DownloadTaskDataDidChangeNotification, object: nil))
        return true
    }
}
