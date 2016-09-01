//
//  String+URL.swift
//  DMDownloadTaskManager
//
//  Created by 夏路遥 on 16/9/1.
//  Copyright © 2016年 xialuyao. All rights reserved.
//

import UIKit

extension String {
    func urlEncode() -> String? {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
    }
    
    func urlDecode() -> String? {
        return self.stringByRemovingPercentEncoding
    }
    
    func base64Encode() -> String? {
        let utf8str = self.dataUsingEncoding(NSUTF8StringEncoding)
        return utf8str!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
    
    func base64Decode() -> String? {
        let data = NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions(rawValue: 0))
        return String(data: data!, encoding: NSUTF8StringEncoding)
    }
}
