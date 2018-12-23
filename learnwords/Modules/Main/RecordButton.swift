//
//  RecordButton.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 21/12/2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class RecordButton: UIButton {

    let shapeLayer = CAShapeLayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.addAnimation()

    }
    
    private func addAnimation() {
        
        // create my track layer
        let trackLayer = CAShapeLayer()
        
        print(self.center)
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.height/2), radius: 75, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = #colorLiteral(red: 0.262745098, green: 0.7589192986, blue: 0.9943001866, alpha: 0.4506367723)
        trackLayer.lineWidth = 15
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = kCALineCapRound
        
        self.layer.addSublayer(trackLayer)
        
        //        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = #colorLiteral(red: 0.2642498016, green: 0.7589192986, blue: 0.9943001866, alpha: 1)
        shapeLayer.lineWidth = 15
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = kCALineCapRound
        
        shapeLayer.strokeEnd = 0
        
        self.layer.addSublayer(shapeLayer)
        
//        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
    }
    
      func animate() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 0.69
        
        basicAnimation.duration = 4
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }

}
