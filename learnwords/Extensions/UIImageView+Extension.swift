//
//  UIImageView+Extension.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 21.07.2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}
