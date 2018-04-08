//
//  ViewController.swift
//  VerificationTool
//
//  Created by Katy on 2018/4/4.
//  Copyright © 2018年 Katy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        KPTouchID.touchIdEvaluatePolicy("验证TouchID", "密码登录") { (completeType: KPTouchIDCompleteType) in
            switch completeType {
            case .success:
                print("=======验证成功")
            case .cancel:
                print("=======取消验证")
            case .doother:
                print("=======使用其他验证方式")
            default:
                print("=======验证失败")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

