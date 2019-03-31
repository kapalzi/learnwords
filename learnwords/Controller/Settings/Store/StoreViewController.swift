//
//  StoreViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 31/03/2019.
//  Copyright © 2019 kapala. All rights reserved.
//

import UIKit

class StoreViewController: UITableViewController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.topItem?.title = "Store"
    }
    
    override func viewWillLayoutSubviews() {
        self.tableView.visibleCells.forEach {
            ($0 as! SettingsCell).shadowView.dropShadow()
        }
    }
    
    //table
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SettingsCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellIdentifier) as! SettingsCell
        }
        
        self.configureCell(cell: cell as! SettingsCell, indexPath: indexPath)
        return cell!
    }
    
    private func configureCell(cell: SettingsCell, indexPath: IndexPath) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        cell.selectedBackgroundView = backgroundView
        switch indexPath.row {
        case 0:
            cell.mainLabel.text = "Browse Sets"
        case 1:
            cell.mainLabel.text = "Remove Ads"
        case 2:
            cell.mainLabel.text = "dupa dupa"
        default:
            cell.mainLabel.text = "Coming soon"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "languageSet") as! LanguageSetViewController
            //            self.navigationController?.show(vc, sender: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "knownSet") as! KnownLanguageViewController
            self.navigationController?.show(vc, sender: nil)
            
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "newSet") as! NewSetViewController
            self.navigationController?.show(vc, sender: nil)
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "newSet") as! KnownLanguageViewController
            self.navigationController?.show(vc, sender: nil)
        case 10:
            var ac = UIAlertController()
            ac = UIAlertController.init(title: nil, message: "Select number", preferredStyle: UIAlertControllerStyle.actionSheet)
            ac.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            for i in 1 ... 10 {
                ac.addAction(UIAlertAction(title: String(i), style: .default, handler: { (UIAlertAction) in
                    UserDefaults.standard.set(i, forKey: "answersToMaster")
                }))
            }
            self.present(ac, animated: true, completion: nil)
            
        default:
            print("coming soon")
        }
    }
}

