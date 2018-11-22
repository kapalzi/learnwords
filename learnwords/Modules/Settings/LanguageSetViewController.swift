//
//  LanguageSetViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 21/11/2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class LanguageSetViewController: UITableViewController  {
    
    var tableData: [LanguageSet]? = nil
    var isMainMode: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Your Language Sets"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        tableData = LanguageSet.getAllLanguageSets(inContext: context)

        if self.navigationController?.viewControllers.count == 2 {
            self.isMainMode = true
        }
    }
    
    func initControls() {
        
    }
    
    func initNewWordButton() {
       
    }
    
    //table
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (self.tableData?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LanguageSetCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellIdentifier)
        }
        
        self.configureCell(cell: cell!, indexPath: indexPath)
        
        return cell!
    }
    
    private func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        
//        let document = self.viewModel.tableData![indexPath.row]
        let set = self.tableData![indexPath.row] as LanguageSet
        
        cell.textLabel?.text = set.name
        
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0)
        cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 24)
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.lineBreakMode = .byWordWrapping
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let set = self.tableData![indexPath.row] as LanguageSet
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if self.isMainMode {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "statistics") as! StatisticsViewController
            vc.tableData = Word.getWords(ForSet: set, inContext: context)
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            LanguageSet.setLanguageSetAsSelected(code: set.code!, context: context)
            UserDefaults.standard.set(0, forKey: "lastWordId")
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

