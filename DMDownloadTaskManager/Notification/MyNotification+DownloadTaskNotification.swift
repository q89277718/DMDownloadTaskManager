//
//  Notification+DownloadTaskNotification.swift
//  DMDownloadTaskManager
//
//  Created by 夏路遥 on 16/7/12.
//  Copyright © 2016年 xialuyao. All rights reserved.
//

import UIKit

let DownloadTaskDataDidChangeNotification_ = "DownloadTaskDataDidChangeNotification"

extension Notification {
    static var DownloadTaskDataDidChangeNotification:String{
        return DownloadTaskDataDidChangeNotification_
    }
}
