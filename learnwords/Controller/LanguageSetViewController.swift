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
        if self.navigationController?.viewControllers.count == 1 {
            self.isMainMode = true
            self.navigationController?.navigationBar.topItem?.title = "Statistics"
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.tableView.visibleCells.forEach {
            ($0 as! SetsCell).shadowView.dropShadow()
        }
    }
    
    //table
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (self.tableData?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SetsCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellIdentifier) as! SetsCell
        }
        
        self.configureCell(cell: cell as! SetsCell, indexPath: indexPath)
        
        return cell!
    }
    
    private func configureCell(cell: SetsCell, indexPath: IndexPath) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        cell.selectedBackgroundView = backgroundView
        
        let set = self.tableData![indexPath.row] as LanguageSet
        cell.nameLbl.text = set.name
        cell.depictionLbl.text = set.depiction
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

