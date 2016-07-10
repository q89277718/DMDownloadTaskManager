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
    //提供静态访问方法
    class var shareInstance: DownloadTaskDataManager {
        return Inner.instance
    }
    
    //通过结构体来保存实例引用
    private struct Inner {
        private static let instance = DownloadTaskDataManager()
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
}
