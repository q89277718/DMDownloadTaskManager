//
//  DownloadTaskDataManager.swift
//  DMDownloadTaskManager
//
//  Created by 夏路遥 on 16/7/6.
//  Copyright © 2016年 xialuyao. All rights reserved.
//

import UIKit

class DownloadTaskDataManager : NSObject {
    
    var taskData = Array<DownloadTaskEntity>()
    
    func shareInstance() -> DownloadTaskDataManager {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : DownloadTaskDataManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = DownloadTaskDataManager()
        }
        return Static.instance!
    }
    
    func addTask(title:String, url:String, tagsArr:Array<String>) -> Bool {
        let taskEntity = DownloadTaskEntity(title:title, url: url, tagsArr: tagsArr)
        self.taskData .append(taskEntity)
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
}
