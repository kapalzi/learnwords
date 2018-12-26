//
//  SettingsViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 29.03.2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController  {
    
    @IBOutlet weak var selectSetBtn: UIButton!
    @IBOutlet weak var numberOfGoodBtn: UIButton!
    @IBOutlet weak var createSetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.topItem?.title = "Settings"
    }
    
    func initControls() {
        self.selectSetBtn.dropShadow()
        self.numberOfGoodBtn.dropShadow()
        self.createSetBtn.dropShadow()
//        initButtons()
    }
    
    func initButtons() {
        let newWordButton = UIButton.init(type: UIButtonType.roundedRect)
        newWordButton.frame = CGRect.init(x:20, y: view.frame.height/2, width: view.frame.width-40, height: 90)
        newWordButton.setTitle("Add New Word", for: UIControlState.normal)
        newWordButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        newWordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        newWordButton.addTarget(self, action: #selector(newWordButtonPressed), for: UIControlEvents.touchUpInside)
        newWordButton.dropShadow()
        self.view.addSubview(newWordButton)
        
        let newWordButton2 = UIButton.init(type: UIButtonType.roundedRect)
        newWordButton2.frame = CGRect.init(x:20, y: view.frame.height/2 + 100, width: view.frame.width-40, height: 90)
        newWordButton2.setTitle("Add New Word", for: UIControlState.normal)
        newWordButton2.setTitleColor(UIColor.black, for: UIControlState.normal)
        newWordButton2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        newWordButton2.addTarget(self, action: #selector(newWordButtonPressed), for: UIControlEvents.touchUpInside)
        newWordButton2.dropShadow()
        self.view.addSubview(newWordButton2)
    }
    
    @objc func newWordButtonPressed() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "newWord") as! NewWordViewController
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func selectSetClicked(_ sender: UIButton) {
    }
    @IBAction func numberOfGoodCLicked(_ sender: UIButton) {
        var ac = UIAlertController()
        
        ac = UIAlertController.init(title: nil, message: "Select number", preferredStyle: UIAlertControllerStyle.actionSheet)
        ac.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        for i in 1 ... 10 {
            ac.addAction(UIAlertAction(title: String(i), style: .default, handler: { (UIAlertAction) in
                UserDefaults.standard.set(i, forKey: "answersToMaster")
            }))
        }
        
        self.present(ac, animated: true, completion: nil)
    }
    @IBAction func createSetClicked(_ sender: UIButton) {
    }
}
