//
//  GesturesViewController.swift
//  VerificationTool
//
//  Created by Katy on 2018/5/7.
//  Copyright © 2018年 Katy. All rights reserved.
//

import UIKit

class GesturesViewController: UIViewController {

    @IBOutlet weak var gestureView: GesturesView!
    @IBOutlet weak var tipLab: UILabel!
    
    var setPassword: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let selectedIDs = UserDefaults.standard.object(forKey: "GESTUREPASSORD") as? String ?? ""
        if selectedIDs.count > 0 {
            self.gestureView.settingGesture = false
            
            self.gestureView.unlockBlock = { [weak self] (isSuccess: Bool) in
                guard let sSelf = self else { return }
                if isSuccess {
                    let vc = SecondViewController()
                    vc.title = "私密相册"
                    sSelf.navigationController?.pushViewController(vc, animated: true)
                } else {
                    sSelf.tipLab.text = "密码错误"
                }
            }
            
        } else {
            self.gestureView.settingGesture = true
            self.gestureView.gestureBlock = { [weak self] (selectedIDList: [String]) in
                guard let sSelf = self else { return }
                var password = ""
                for (index,str) in selectedIDList.enumerated() {
                    if index == 0 {
                        password += str
                    } else {
                        password += ("," + str)
                    }
                }
                if sSelf.setPassword.count == 0 {
                    sSelf.setPassword = password
                    sSelf.tipLab.text = "请再次绘制解锁图案"
                } else {
                    if sSelf.setPassword == password {
                        sSelf.tipLab.text = "设置成功"
                        UserDefaults.standard.set(password, forKey: "GESTUREPASSORD")
                        self?.navigationController?.popViewController(animated: true)
                    } else {
                        sSelf.setPassword = ""
                        sSelf.tipLab.text = "与上一次输入不一致，请重新设置"
                    }
                }
            }
            self.gestureView.failBlock = {
                print("手势密码不得少于4个点")
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
