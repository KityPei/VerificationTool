//
//  GesturesView.swift
//  VerificationTool
//
//  Created by Katy on 2018/5/4.
//  Copyright © 2018年 Katy. All rights reserved.
//

import UIKit


typealias GestureBlock = (_ selectedID: [String]) -> Void
typealias UnlockBlock = (_ isSuccess: Bool) -> Void

typealias SettingFailBlock = () -> Void

class GesturesView: UIView {

    
    static let GESTURESPOSSWORD: String = "GESTURESPOSSWORD"
    
    var gestureBlock: GestureBlock?
    
    var unlockBlock: UnlockBlock?
    
    var failBlock: SettingFailBlock?
    
    var settingGesture: Bool = false // 默认解锁
    
    fileprivate var pointViews: [PointView] = []

    fileprivate var startPoint: CGPoint = CGPoint.zero
    
    fileprivate var endPoint: CGPoint = CGPoint.zero
    
    fileprivate var selectedIDList: [String] = []
    
    fileprivate lazy var lineLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        return layer
    }()
    
    fileprivate lazy var linePath: UIBezierPath = {
        let path = UIBezierPath.init()
        return path
    }()
    
    fileprivate var selectedCenterList: [CGPoint] = []
    
    fileprivate var touchEnd: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initData()
        self.initView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initData()
        self.initView()
    }
    
    fileprivate func initData() {
        self.touchEnd = false
    }
    
    fileprivate func initView() {
        self.startPoint = CGPoint.zero
        self.endPoint = CGPoint.zero
        
        let rowHeight  = (self.bounds.width - 180)/4
        let lineHeight = (self.bounds.height - 180)/4
        
        
        for index in 0..<9 {
            let x: CGFloat = (rowHeight + 60) * CGFloat(index % 3) + rowHeight
            let y: CGFloat = CGFloat(index / 3) * (lineHeight + 60) + lineHeight
            let pointView = PointView.init(frame: CGRect.init(x: x, y: y, width: 60, height: 60), ID: "\(index+1)")
            self.addSubview(pointView)
            self.pointViews.append(pointView)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.touchEnd {
            return
        }
        
        let touch = touches.first
        let point: CGPoint = touch?.location(in: self) ?? CGPoint.zero
        for pointView in self.pointViews {
            if pointView.frame.contains(point) {
                if self.startPoint == CGPoint.zero {
                    self.startPoint = pointView.center
                }
                
                if !self.selectedCenterList.contains(pointView.center) {
                    self.selectedCenterList.append(pointView.center)
                }
                
                if !self.selectedIDList.contains(pointView.ID) {
                    self.selectedIDList.append(pointView.ID)
                    pointView.isSelected = true
                }
            }
        }
        if self.startPoint != CGPoint.zero {
            self.endPoint = point
            self.drawLines()
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endPoint = self.selectedCenterList.last ?? CGPoint.zero
        
        if self.endPoint == CGPoint.zero {
            return
        }
        
        self.drawLines()
        
        self.touchEnd = true
        
        if settingGesture ,self.gestureBlock != nil {
            self.touchEnd = false
            if self.selectedIDList.count < 4 {
                if self.failBlock != nil {
                    self.failBlock!()
                }
            } else {
                if self.gestureBlock != nil {
                    self.gestureBlock!(self.selectedIDList)
                }
            }
            
            for pointView in self.pointViews {
                pointView.isSelected = false
            }
            
            self.lineLayer.removeFromSuperlayer()
            self.selectedIDList.removeAll()
            self.startPoint = CGPoint.zero
            self.endPoint = CGPoint.zero
            self.selectedCenterList.removeAll()
            return
        }
        
        let selectedIDs = UserDefaults.standard.object(forKey: "GESTUREPASSORD") as? String ?? ""
        
        let array: NSArray = NSArray.init(array: selectedIDs.components(separatedBy: ","))
        let arrayList: NSArray = NSArray.init(array: self.selectedIDList)
        
        if array.isEqual(to: arrayList as! [Any]) {//解锁成功，遍历pointview，设置为成功状态
            for pointView in self.pointViews {
                pointView.isSuccess = true
            }
            
            self.lineLayer.strokeColor = UIColor.init(red: 43/255.0, green: 210/255.0, blue: 110/255.0, alpha: 1).cgColor
            
            if let block = unlockBlock {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    self.touchEnd = false
                    for pointView in self.pointViews {
                        pointView.isSelected = false
                    }
                    
                    self.lineLayer.removeFromSuperlayer()
                    self.selectedIDList.removeAll()
                    self.startPoint = CGPoint.zero
                    self.endPoint = CGPoint.zero
                    self.selectedCenterList.removeAll()
                    block(true)
                }
            }
        }else {//解锁失败，遍历pointView，设置为失败状态
            for pointView in self.pointViews {
                pointView.isError = true
            }
            self.lineLayer.strokeColor = UIColor.init(red: 222/255.0, green: 64/255.0, blue: 60/255.0, alpha: 1).cgColor
            if let block = unlockBlock {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    self.touchEnd = false
                    for pointView in self.pointViews {
                        pointView.isSelected = false
                    }
                    
                    self.lineLayer.removeFromSuperlayer()
                    self.selectedIDList.removeAll()
                    self.startPoint = CGPoint.zero
                    self.endPoint = CGPoint.zero
                    self.selectedCenterList.removeAll()
                    block(false)
                }
            }
        }
    }
    
    func drawLines() {
        if self.touchEnd {
            return
        }
        
        self.lineLayer.removeFromSuperlayer()
        self.linePath.removeAllPoints()
        
        self.linePath.move(to: self.startPoint)
        for pointValue in self.selectedCenterList {
            self.linePath.addLine(to: pointValue)
        }
        self.linePath.addLine(to: self.endPoint)
        
        self.lineLayer.path = self.linePath.cgPath
        self.lineLayer.lineWidth = 4
        self.lineLayer.strokeColor = UIColor.init(red: 30/255.0, green: 180/255.0, blue: 244/255.0, alpha: 1).cgColor
        self.lineLayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(self.lineLayer)
        
        self.layer.masksToBounds = true
        
    }
    
    
}
