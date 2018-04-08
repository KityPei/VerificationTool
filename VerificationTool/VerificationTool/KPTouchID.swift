//
//  KPTouchID.swift
//  VerificationTool
//
//  Created by Katy on 2018/4/4.
//  Copyright © 2018年 Katy. All rights reserved.
//

import UIKit
import LocalAuthentication


enum KPTouchIDCompleteType: Int {
    case success = 0
    case cancel
    case doother
    case fail
}

typealias KPTouchIDComplete = (_ type: KPTouchIDCompleteType) -> Void

class KPTouchID: NSObject {
    
    /**
     noticeStr: 说明提示
     fallBackStr: 另外一种验证方式
     complete: 回调
     */
    class func touchIdEvaluatePolicy(_ noticeStr: String?, _ fallBackStr: String?, _ complete: KPTouchIDComplete?) {
        let context = LAContext()
        if let fallback = fallBackStr, fallback.count > 0 {
            context.localizedFallbackTitle = fallback
        } else {
            context.localizedFallbackTitle = ""
        }
        
        var error: NSError?
        let canUseTouchId = context.canEvaluatePolicy(LAPolicy(rawValue: LAPolicy.RawValue(kLAPolicyDeviceOwnerAuthenticationWithBiometrics))!, error: &error)
        if !canUseTouchId {
            if complete != nil {
                DispatchQueue.main.async {
                    complete!(.fail)
                }
            }
            return
        }
        
        var notice: String = "指纹验证"
        if let str = noticeStr, str.count > 0 {
            notice = str
        }
        
        context.evaluatePolicy(LAPolicy.init(rawValue: Int(kLAPolicyDeviceOwnerAuthenticationWithBiometrics))!, localizedReason: notice) { (success: Bool, error: Error?) in
            if success {
                if complete != nil {
                    DispatchQueue.main.async {
                        complete!(.success)
                    }
                }
            } else {
                var finalType: KPTouchIDCompleteType = .fail
                if let err = error {
                    let code = (err as NSError).code
                    if code == kLAErrorUserFallback {
                        finalType = .doother
                    } else if (code == kLAErrorSystemCancel) || (code == kLAErrorUserCancel) {
                        finalType = .cancel
                    }
                    if complete != nil {
                        DispatchQueue.main.async {
                            complete!(finalType)
                        }
                    }
                }
            }
        }
    }
}
