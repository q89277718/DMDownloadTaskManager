//
//  DownloadTaskEntity.swift
//  DMDownloadTaskManager
//
//  Created by 夏路遥 on 16/7/6.
//  Copyright © 2016年 xialuyao. All rights reserved.
//

import UIKit

class DownloadTaskEntity {

    var title : String?
    var tagsArr = Array<String>()
    var url : String?
    var description : String?
    
    func addTag(tagStr : String) -> Bool {
        if !self.tagsArr.contains(tagStr) {
            self.tagsArr.append(tagStr);
            return true;
        }
        return false;
    }
    
    func removeTag(targStr : String) -> Bool {
        if let index = self.tagsArr.indexOf(targStr) {
            self.tagsArr.removeAtIndex(index)
            return true
        }
        return false
    }
    
    init(title:String?, url:String?){
        self.title = title
        self.url = url
    }
    
    convenience init(title:String?, url:String?, description:String?){
        self.init(title:title, url: url)
        self.description = description
    }
    
    convenience init(title:String?, url:String?, description:String?, tagsArr:Array<String>){
        self.init(title:title, url: url, description: description)
        self.tagsArr = tagsArr
    }
}
