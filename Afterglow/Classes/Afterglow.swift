//
//  Afterglow.swift
//  Afterglow
//
//  Created by Vien Van Nguyen on 9/2/16.
//  Copyright © 2016 Vien Van Nguyen. All rights reserved.
//

import UIKit
import RandomColorSwift

extension UIView {
    public func addAfterglow() -> (mainView: UIView, maskView: UIView) {
        return addAfterglowWith(40, line: 15, speed: 10, backgroundColor: UIColor.blackColor(), hue: .Pink)
    }
    public func addAfterglowWith(leaf: Int, line: Int, speed: Int, backgroundColor: UIColor, hue: Hue) -> (mainView: UIView, maskView: UIView) {
        let mainView = UIView()
        let maskView = UIView()
        
        // Setup main view and mask view
        mainView.translatesAutoresizingMaskIntoConstraints = false
        maskView.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.backgroundColor = backgroundColor
        maskView.backgroundColor = backgroundColor
        
        self.addSubview(mainView)
        self.insertSubview(maskView, aboveSubview: mainView)
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-0-[self]-0-|", options: [], metrics: nil, views: ["self" : mainView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-0-[self]-0-|", options: [], metrics: nil, views: ["self" : mainView]))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-0-[self]-0-|", options: [], metrics: nil, views: ["self" : maskView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-0-[self]-0-|", options: [], metrics: nil, views: ["self" : maskView]))
        
        mainView.layoutIfNeeded()
        maskView.layoutIfNeeded()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        
        // Create a crescent layer
        for i in 0..<leaf {
            let angle = CGFloat(i) * CGFloat(M_PI * 2) / CGFloat(leaf)
            let color = randomColor(hue: hue, luminosity: .Bright)
            
            mainView.layer.addCrescentLayerWith(angle, color: color)
        }
        
        // Create a mark layer
        maskView.layer.addLineMark(line)
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z");
        animation.fromValue = 0.0
        animation.toValue = M_PI * 2
        animation.duration = Double(speed)
        animation.repeatCount = HUGE
        mainView.layer.addAnimation(animation, forKey: "")
        
        return (mainView, maskView)
    }
}

extension CALayer {
    private func addCrescentLayerWith(rotate: CGFloat, color: UIColor) {
        let rad : CGFloat = self.frame.width / 4 // radius of a crescent layer
        let distance : CGFloat = 3 // distance of two curves
        let angle = acos((distance / 2.0) / rad) // angle (in radians) between the north and a crescent layer
        let x : CGFloat = rad * 2
        let y : CGFloat = rad
        
        let crescentPath = UIBezierPath()
        crescentPath.addArcWithCenter(CGPointMake(x, y), radius: rad,
                                      startAngle: angle - CGFloat(M_PI), endAngle: CGFloat(M_PI) - angle, clockwise: true)
        crescentPath.addArcWithCenter(CGPointMake(x - distance, y), radius: rad,
                                      startAngle: angle, endAngle: -angle, clockwise: false)
        crescentPath.closePath()
        
        let crescent = CAShapeLayer()
        crescent.frame = self.bounds
        crescent.bounds = self.bounds
        crescent.fillColor = color.CGColor
        crescent.path = crescentPath.CGPath
        crescent.transform = CATransform3DMakeRotation(rotate, 0.0, 0.0, 1.0)
        
        self.addSublayer(crescent)
    }
    
    private func addLineMark(numberLine: Int) {
        let mask : CAShapeLayer = CAShapeLayer()
        
        let weight : CGFloat = 1 // Weight of line
        let p0 : CGPoint = CGPoint(x: self.frame.midX, y: self.frame.midY)
        let p1 : CGPoint = CGPoint(x: self.frame.midX - (weight / 2), y: 0)
        let p2 : CGPoint = CGPoint(x: self.frame.midX - (weight / 2), y: self.frame.height)
        let p3 : CGPoint = CGPoint(x: self.frame.midX + weight, y: self.frame.height)
        let p4 : CGPoint = CGPoint(x: self.frame.midX + weight, y: 0)
        
        let maskPath = CGPathCreateMutable()
        
        for i in 0..<numberLine {
            let sharp : UIBezierPath = UIBezierPath()
            let angle = CGFloat(M_PI) * CGFloat(i) / CGFloat(numberLine)
            
            sharp.moveToPoint(p1.rotateWithCenter(p0, angle: angle))
            sharp.addLineToPoint(p2.rotateWithCenter(p0, angle: angle))
            sharp.addLineToPoint(p3.rotateWithCenter(p0, angle: angle))
            sharp.addLineToPoint(p4.rotateWithCenter(p0, angle: angle))
            
            CGPathAddPath(maskPath, nil, sharp.CGPath)
        }
        CGPathAddRect(maskPath, nil, self.bounds)
        
        mask.path = maskPath
        mask.fillRule = kCAFillRuleEvenOdd
        
        self.mask = mask
    }
}

extension CGPoint {
    private func rotateWithCenter(center: CGPoint, angle: CGFloat) -> CGPoint {
        let x = (self.x - center.x) * cos(angle) - (self.y - center.y) * sin(angle) + center.x
        let y = (self.x - center.x) * sin(angle) + (self.y - center.y) * cos(angle) + center.y
        return CGPoint(x: x, y: y)
    }
}