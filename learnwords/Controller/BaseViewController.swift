//
//  BaseViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 31.03.2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var originalViewFrame: CGRect!
    var isKeyboardVisible: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalViewFrame = self.view.frame;
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardShow(notification: NSNotification) {
//        let info = notification.userInfo!
//        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        self.view.frame.size.height = keyboardFrame.origin.y;
        self.isKeyboardVisible = true
    }
    
    @objc func keyboardHide(notification: NSNotification) {
        self.isKeyboardVisible = false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func playHaptic() {
        let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        lightImpactFeedbackGenerator.prepare()
        lightImpactFeedbackGenerator.impactOccurred()
    }

    
}
