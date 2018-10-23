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
        addBlurBackground()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.view.frame.size.height = keyboardFrame.origin.y;
        self.isKeyboardVisible = true
    }
    
    @objc func keyboardHide(notification: NSNotification) {
        self.view.frame = originalViewFrame
    }
    
    @objc func dismissKeyboard() {
        self.isKeyboardVisible = false
        view.endEditing(true)
    }
    
    func addBlurBackground() {
        
        var modifiedFrame = originalViewFrame
        modifiedFrame?.size.height+=90
        let imgView = UIImageView.init(frame: modifiedFrame!)
        let img = UIImage.init(named: "mainBg")
        imgView.image = img
        imgView.backgroundColor = UIColor.blue
        imgView.addBlurEffect()
        
        self.view.insertSubview(imgView, at: 0)
    }
    
}
