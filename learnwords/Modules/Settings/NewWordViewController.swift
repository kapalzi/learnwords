//
//  NewWordViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 30.03.2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class NewWordViewController: BaseNavBarViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var language: String!
    var original: String!
    var english: String!
    var polish: String!
    var alternative: String!
    
    override func viewDidLoad() {
        super.navTitle = "Add New Word"
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewWordCell", for: indexPath) as! NewWordCell
        
        initCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func initCell(cell: NewWordCell, indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            do {
                cell.titleLabel?.text = "Language"
                cell.valueField?.isEnabled = false
                
            }
            break
        case 1:
            do {
                cell.titleLabel?.text = "Original"
            }
            break
        case 2:
            do {
                cell.titleLabel?.text = "English"
            }
            break
        case 3:
            do {
                cell.titleLabel?.text = "Polish"
            }
            break
        case 4:
            do {
                cell.titleLabel?.text = "Alternative Alphabet"
            }
            break
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row==0 {
            let ac = UIAlertController.init(title: "Select Language", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            ac.addAction(UIAlertAction.init(title: "Japan", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                self.language = "Japan"
            }))
            ac.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(ac, animated: true, completion: nil)
        }
    }
}
