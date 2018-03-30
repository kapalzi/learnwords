//
//  BaseViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 30.03.2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    public var navTitle: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavBar()
    }
    
    func initNavBar() {
        let navBar = UINavigationBar.init(frame:CGRect.init(x: 0, y: 10, width: self.view.frame.width, height: 200))
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.purple]
        self.view.addSubview(navBar)
        let navItem = UINavigationItem.init()
        navItem.title = navTitle
        let backItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: nil, action:#selector(backClicked))
        backItem.tintColor = UIColor.purple
        navItem.leftBarButtonItem = backItem
        navBar.setItems([navItem], animated: false)
    }
    
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}
