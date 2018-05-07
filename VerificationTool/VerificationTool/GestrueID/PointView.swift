//
//  PointView.swift
//  VerificationTool
//
//  Created by Katy on 2018/5/4.
//  Copyright © 2018年 Katy. All rights reserved.
//

import UIKit

class PointView: UIView {

    fileprivate(set) var ID: String = ""
    
    fileprivate var _isSelected: Bool = false
    var isSelected: Bool {
        set {
            _isSelected = newValue
            if _isSelected {
                self.centerLayer.isHidden = false
                self.borderLayer.strokeColor = UIColor.init(red: 30/255.0, green: 180/255.0, blue: 244/255.0, alpha: 1).cgColor
            } else {
                self.centerLayer.isHidden = true
                self.borderLayer.strokeColor = UIColor.init(red: 105/255.0, green: 108/255.0, blue: 111/255.0, alpha: 1).cgColor
            }
        }
        get {
            return _isSelected
        }
    }
    
    fileprivate var _isError: Bool = false
    var isError: Bool {
        set {
            _isError = newValue
            if _isError {
                self.centerLayer.fillColor = UIColor.init(red: 222/255.0, green: 64/255.0, blue: 60/255.0, alpha: 1).cgColor
            } else {
                self.centerLayer.fillColor = UIColor.init(red: 30/255.0, green: 180/255.0, blue: 244/255.0, alpha: 1).cgColor
            }
        }
        get {
            return _isError
        }
    }
    
    fileprivate var _isSuccess: Bool = false
    var isSuccess: Bool {
        set {
            _isSuccess = newValue
            if _isSuccess {
                self.centerLayer.fillColor = UIColor.init(red: 43/255.0, green: 210/255.0, blue: 110/255.0, alpha: 1).cgColor
            } else {
                self.centerLayer.fillColor = UIColor.init(red: 30/255.0, green: 180/255.0, blue: 244/255.0, alpha: 1).cgColor
            }
        }
        get {
            return _isSuccess
        }
    }
    
    fileprivate lazy var contentLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        let path: UIBezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 2, y: 2, width: self.bounds.width - 4, height: self.bounds.height - 4), cornerRadius: (self.bounds.width - 4) / 2)
        layer.path = path.cgPath
        layer.fillColor = UIColor.white.cgColor//UIColor.init(red: 46/255.0, green: 47/255.0, blue: 50/255.0, alpha: 1).cgColor
        layer.strokeColor = UIColor.init(red: 182/255.0, green: 182/255.0, blue: 185/255.0, alpha: 1).cgColor
        layer.strokeStart = 0
        layer.strokeEnd = 1
        layer.lineWidth = 2
        layer.cornerRadius = self.bounds.size.width / 2
        return layer
    }()
    
    fileprivate lazy var borderLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        let path: UIBezierPath = UIBezierPath.init(arcCenter: CGPoint.init(x: self.bounds.width / 2, y: self.bounds.height / 2), radius: self.bounds.width / 2, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: false)
        layer.path = path.cgPath
        layer.strokeColor = UIColor.init(red: 105/255.0, green: 108/255.0, blue: 111/255.0, alpha: 1).cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeStart = 0
        layer.strokeEnd = 1
        layer.lineWidth = 2
        return layer
    }()
    
    fileprivate lazy var centerLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        let path = UIBezierPath.init(roundedRect: CGRect.init(x: self.bounds.width/2-(self.bounds.width-4)/4, y: self.bounds.height/2-(self.bounds.height-4)/4, width: (self.bounds.width - 4) / 2, height: (self.bounds.width - 4) / 2), cornerRadius: (self.bounds.width - 4) / 4)
        layer.path = path.cgPath
        layer.lineWidth = 3
        layer.strokeColor = UIColor.init(white: 0, alpha: 0.7).cgColor
        layer.fillColor = UIColor.init(red: 30/255.0, green: 180/255.0, blue: 244/255.0, alpha: 1).cgColor
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.addSublayer(self.contentLayer)
        self.layer.addSublayer(self.borderLayer)
        self.layer.addSublayer(self.centerLayer)
        
        self.centerLayer.isHidden = true
    }
    
    convenience init(frame: CGRect, ID: String) {
        self.init(frame: frame)
        self.ID = ID
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.addSublayer(self.contentLayer)
        self.layer.addSublayer(self.borderLayer)
        self.layer.addSublayer(self.centerLayer)
        
        self.centerLayer.isHidden = true
    }
    
}

