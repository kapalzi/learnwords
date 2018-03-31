//
//  SettingsViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 29.03.2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class SettingsViewController: BaseNavBarViewController  {
    
    override func viewDidLoad() {
        super.navTitle = "Settings"
        super.viewDidLoad()
        
        initControls()
    }
    
    func initControls() {
        let newWordButton = UIButton.init(type: UIButtonType.roundedRect)
        newWordButton.frame = CGRect.init(x:0, y: view.frame.height/2, width: view.frame.width, height: 45)
        newWordButton.setTitle("Add New Word", for: UIControlState.normal)
        newWordButton.setTitleColor(UIColor.purple, for: UIControlState.normal)
        newWordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        newWordButton.addTarget(self, action: #selector(newWordButtonPressed), for: UIControlEvents.touchUpInside)
        self.view.addSubview(newWordButton)
        
    }
    
    @objc func newWordButtonPressed() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "newWord") as! NewWordViewController
        self.present(vc, animated: true, completion: nil)
    }
}
