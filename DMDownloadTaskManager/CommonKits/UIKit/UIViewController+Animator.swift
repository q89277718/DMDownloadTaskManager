//
//  UIViewController+Animator.swift
//  DMDownloadTaskManager
//
//  Created by 夏路遥 on 16/9/1.
//  Copyright © 2016年 xialuyao. All rights reserved.
//

import UIKit

extension UIViewController {
    private struct AssociatedKey {
        static var animatorKey = "animatorKey"
    }
    
    var animator : UIDynamicAnimator!{
        get{
            if let v = objc_getAssociatedObject(self, &AssociatedKey.animatorKey) as? UIDynamicAnimator{
                return v
            } else {
                let v = UIDynamicAnimator.init()
                objc_setAssociatedObject(self, &AssociatedKey.animatorKey, v, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                return v
            }
        }
    }
}
