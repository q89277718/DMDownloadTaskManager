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
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)
    }
    
    func urlDecode() -> String? {
        return self.removingPercentEncoding
    }
    
    func base64Encode() -> String? {
        let utf8str = self.data(using: String.Encoding.utf8)
        return utf8str!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    func base64Decode() -> String? {
        let data = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
        return String(data: data! as Data, encoding: String.Encoding.utf8)
    }
}
