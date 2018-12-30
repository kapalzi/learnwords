//
//  UIView+Extension.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 06/12/2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

extension UIView{
    
    func dropShadow(shadowColor: UIColor = UIColor.black,
                    fillColor: UIColor = UIColor.white,
                    opacity: Float = 0.5,
                    offset: CGSize = CGSize(width: 0.0, height: 1.0),
                    radius: CGFloat = 15,
                    imgName: String = "") {
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = radius
        
        if imgName != "" {
            let imgLayer = CALayer()
            let img = UIImage(named: imgName)?.cgImage
            imgLayer.frame = self.bounds
            imgLayer.contents = img
            imgLayer.cornerRadius = radius
            imgLayer.masksToBounds = true
            shadowLayer.addSublayer(imgLayer)
        }
        shadowLayer.name = "shadow"
        
        if let layers = layer.sublayers {
            if let firstLayer = layers.first {
                if firstLayer.name == shadowLayer.name {
                    layer.replaceSublayer(firstLayer, with: shadowLayer)
                }
                else {
                    layer.insertSublayer(shadowLayer, at: 0)
                }
                
            } else {
                layer.insertSublayer(shadowLayer, at: 0)
            }
        } else {
            layer.insertSublayer(shadowLayer, at: 0)
        }
//        return shadowLayer
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func flipFromBot() {
        UIView.transition(with: self,
                          duration: 0.3,
                          options: .transitionFlipFromTop,
                          animations: nil,
                          completion: nil)
    }
    
    func flipFromTop() {
        UIView.transition(with: self,
                          duration: 0.3,
                          options: .transitionFlipFromBottom,
                          animations: nil,
                          completion: nil)
    }
}

