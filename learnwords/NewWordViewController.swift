//
//  NewWordViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 30.03.2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class NewWordViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.navTitle = "Add New Word"
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NewWordCell.init(style: UITableViewCellStyle.default, reuseIdentifier: nil)

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
                cell.titleLabel?.textColor = UIColor.black
                cell.titleLabel?.isHidden = false
                
            }
            break
        case 1:
            do {
            cell.titleLabel?.text = "Original"
//            cell.titleLabel.textColor = UIColor.black
//            cell.titleLabel.isHidden = false
//            cell.valueField.placeholder = "enter value"
            }
            break
        case 2:
            do {
            cell.titleLabel?.text = "English"
//            cell.titleLabel.textColor = UIColor.black
//            cell.titleLabel.isHidden = false
//            cell.valueField.placeholder = "enter value"
            }
            break
        case 3:
            do {
            cell.titleLabel?.text = "Polish"
//            cell.titleLabel.textColor = UIColor.black
//            cell.titleLabel.isHidden = false
//            cell.valueField.placeholder = "enter value"
            }
            break
        case 4:
            do {
            cell.titleLabel?.text = "Alternative Alphabet"
//            cell.titleLabel.textColor = UIColor.black
//            cell.titleLabel.isHidden = false
//            cell.valueField.placeholder = "enter value"
            }
            break
        default:
            break
        }
    }
    
}
