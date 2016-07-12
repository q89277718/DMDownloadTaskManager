//
//  DownloadTaskDataManager.swift
//  DMDownloadTaskManager
//
//  Created by 夏路遥 on 16/7/6.
//  Copyright © 2016年 xialuyao. All rights reserved.
//

import UIKit

class DownloadTaskDataManager{
    
    var taskData = Array<DownloadTaskEntity>()
    
    private static let _instance = DownloadTaskDataManager()
    
    class var shareInstance: DownloadTaskDataManager {
        return _instance
    }
    
    init() {
        self.unarchiveData()
    }
    
    func addTask(task:DownloadTaskEntity) -> Bool {
        self.taskData.append(task)
        return true
    }
    
    func taskCount() -> Int {
        return self.taskData.count
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
            self.saveTasks()
            return true
        }
        return false
    }
    
    func saveTasks() -> Bool {
        self.archiveData()
        return true
    }
    
    func archiveData(){
        
        let path: AnyObject=NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        let filePath=path.stringByAppendingPathComponent("task_records.archive")
        //归档
        let array = NSArray.init(array: self.taskData)
        if(NSKeyedArchiver.archiveRootObject(array, toFile: filePath)){
            NSLog("Archive Success")
        }
    }
    func unarchiveData(){
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
        let entity = DownloadTaskEntity(title: tempArr[0])
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
