//
//  UIView+Extension.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 06/12/2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

extension UIView{
    
    func dropShadow() {
        self.backgroundColor = #colorLiteral(red: 0.9803171754, green: 0.9804343581, blue: 0.9802773595, alpha: 1)
        self.layer.cornerRadius = 15
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
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

