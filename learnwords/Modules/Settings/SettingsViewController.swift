//
//  SettingsViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 29.03.2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController  {
    
    override func viewDidLoad() {
//        super.navTitle = "Settings"
        super.viewDidLoad()
//        initControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.topItem?.title = "Settings"
    }
    
    func initControls() {
        initNewWordButton()
    }
    
    func initNewWordButton() {
        let newWordButton = UIButton.init(type: UIButtonType.roundedRect)
        newWordButton.frame = CGRect.init(x:0, y: view.frame.height/2, width: view.frame.width, height: 45)
        newWordButton.setTitle("Add New Word", for: UIControlState.normal)
        newWordButton.setTitleColor(UIColor.purple, for: UIControlState.normal)
        newWordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        newWordButton.addTarget(self, action: #selector(newWordButtonPressed), for: UIControlEvents.touchUpInside)
        self.view.addSubview(newWordButton)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = self.navigationController?.navigationBar.backgroundColor
        if indexPath.row == 1 {
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
    }
    
    @objc func newWordButtonPressed() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "newWord") as! NewWordViewController
        self.present(vc, animated: true, completion: nil)
    }
}
