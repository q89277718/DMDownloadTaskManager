//
//  DownloadTaskEntity.swift
//  DMDownloadTaskManager
//
//  Created by 夏路遥 on 16/7/6.
//  Copyright © 2016年 xialuyao. All rights reserved.
//

import UIKit

class DownloadTaskEntity :NSObject, NSCoding {

    var id : Int!
    var title : String?
    var tagsArr : Array<String>?
    var url : String?
    var descriptionStr : String?
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeInt64(Int64(self.id), forKey: "id")
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.url, forKey: "url")
        aCoder.encodeObject(self.descriptionStr, forKey: "descriptionStr")
        aCoder.encodeObject(self.tagsArr, forKey: "tagsArr")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObjectForKey("id") as? Int ?? -1
        self.title = aDecoder.decodeObjectForKey("title") as? String
        self.url = aDecoder.decodeObjectForKey("url") as? String
        self.descriptionStr = aDecoder.decodeObjectForKey("descriptionStr") as? String
        self.tagsArr = aDecoder.decodeObjectForKey("descriptionStr") as? Array<String>
    }

    func addTag(tagStr : String) -> Bool {
        if self.tagsArr == nil {
            self.tagsArr = []
        }
        
        if !self.tagsArr!.contains(tagStr) {
            self.tagsArr!.append(tagStr);
            return true;
        }
        return false;
    }
    
    func removeTag(targStr : String) -> Bool {
        if let index = self.tagsArr?.indexOf(targStr) {
            self.tagsArr!.removeAtIndex(index)
            return true
        }
        return false
    }
    
    init(title:String?){
        self.id = -1
        self.title = title
    }
    
    convenience init(title:String?, url:String?){
        self.init(title:title)
        self.url = url
    }
    
    convenience init(title:String?, url:String?, description:String?){
        self.init(title:title, url: url)
        self.descriptionStr = description
    }
    
    convenience init(title:String?, url:String?, description:String?, tagsArr:Array<String>){
        self.init(title:title, url: url, description: description)
        self.tagsArr = tagsArr
    }
    
    init?(shareUrl:NSURL) {
        let data = shareUrl.path
        let stringArray = data?.componentsSeparatedByString("#")
        if stringArray == nil {
            return nil
        }
        let tempArr = stringArray!
        if tempArr.count == 0  {
            return nil
        }
        var tempStr = tempArr[0]
        if tempStr.characters.count == 0 {
            return nil
        }
        if tempStr.hasPrefix("/") {
            tempStr = tempStr.substringFromIndex(tempStr.startIndex.advancedBy(1))
        }
        self.title = tempStr.urlDecode()
        self.id = -1;
        if tempArr.count > 1 {
            self.url = tempArr[1].urlDecode()
        }
        
        if tempArr.count > 2 {
            self.descriptionStr = tempArr[2].urlDecode()
        }
    }
    
    func shareUrl() -> NSURL {
        let title = (self.title != nil) ? self.title!.urlEncode() : ""
        let url = self.url != nil ? self.url!.urlEncode() : ""
        let des = self.descriptionStr != nil ? self.descriptionStr!.urlEncode() : ""
        let tempStr = String(format: "downloadTaskDrop://%@#%@#%@", title!, url!, des!)
        return NSURL.init(fileURLWithPath: tempStr)
    }
}
