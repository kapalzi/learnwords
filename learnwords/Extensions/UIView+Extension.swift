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
                    imgName: String = "") -> CAShapeLayer {
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        shadowLayer.fillColor = fillColor.cgColor
//        shadowLayer.fillColor = UIColor.init(red: 36/255, green: 185/255, blue: 255/255, alpha: 1).cgColor
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = radius
 
//        let whiteLayer = CALayer()
//        whiteLayer.frame = self.bounds
//        whiteLayer.cornerRadius = radius
//        whiteLayer.masksToBounds = true
//        shadowLayer.addSublayer(whiteLayer)
        
        if imgName != "" {
            let imgLayer = CALayer()
            let img = UIImage(named: imgName)?.cgImage
            imgLayer.frame = self.bounds
            imgLayer.contents = img
            imgLayer.cornerRadius = radius
            imgLayer.masksToBounds = true
            shadowLayer.addSublayer(imgLayer)
        }
        
        
        
        
//        layer.insertSublayer(shadowLayer, at: 0)
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

//        layer.insertSublayer(shadowLayer, at: 0)
        return shadowLayer
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

extension UIView
{
    func roundedCornersWithShadow()
    {
        self.layoutSubviews()
        
        var shadowLayer: CAShapeLayer!
        let cornerRadius: CGFloat = 25.0
        let fillColor: UIColor = .blue // the color applied to the shadowLayer, rather than the view's backgroundColor
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
//            shadowLayer.fillColor = fillColor.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
}
