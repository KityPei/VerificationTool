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
        
        self.title = "Home"
    }
    
    @IBAction func onClickToTouchIDVerification(_ sender: Any) {
        KPTouchID.touchIdEvaluatePolicy("验证TouchID", "手势解锁") { (completeType: KPTouchIDCompleteType) in
            switch completeType {
            case .success:
                let vc = FirstViewController()
                vc.title = "私密相册"
                self.navigationController?.pushViewController(vc, animated: true)
            case .cancel:
                print("=======取消验证")
            case .doother:
                print("=======使用其他验证方式")
            case .noTouchId:
                print("======未设置TouchID或者不支持TouchID")
            default:
                print("=======验证失败")
            }
        }
    }
    
    
    @IBAction func onClickToGestrueVerification(_ sender: Any) {
        let vc = GesturesViewController()
        
        let selectedIDs = UserDefaults.standard.object(forKey: "GESTUREPASSORD") as? String ?? ""
        vc.title = (selectedIDs.count > 0) ? "解锁手势" : "设置手势锁"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

