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
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(Int64(self.id), forKey: "id")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(self.descriptionStr, forKey: "descriptionStr")
        aCoder.encode(self.tagsArr, forKey: "tagsArr")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObject(forKey: "id") as? Int ?? -1
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.url = aDecoder.decodeObject(forKey: "url") as? String
        self.descriptionStr = aDecoder.decodeObject(forKey: "descriptionStr") as? String
        self.tagsArr = aDecoder.decodeObject(forKey: "descriptionStr") as? Array<String>
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
        if let index = self.tagsArr?.index(of: targStr) {
            self.tagsArr!.remove(at: index)
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
    
    init?(shareUrl:URL) {
        let data = shareUrl.path
        if data.characters.count == 0 {
            return nil
        }
        let stringArray = data.components(separatedBy: "#")
        let tempArr = stringArray
        if tempArr.count == 0  {
            return nil
        }
        var tempStr = tempArr[0]
        if tempStr.characters.count == 0 {
            return nil
        }
        if tempStr.hasPrefix("/") {
            tempStr = tempStr.substring(from: tempStr.index(tempStr.startIndex, offsetBy: 1))
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
