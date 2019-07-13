//
//  CategoryViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 13/07/2019.
//  Copyright © 2019 kapala. All rights reserved.
//

import UIKit

class CategoryViewController: BaseSetViewController  {
    
    var tableData: [String]? = nil
    var knownLanguage: String? = nil
    var learningLanguage: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if let sets = LanguageSet.getAllLanguageSets(forKnownLanguage: self.knownLanguage!, forLearningLanguage: self.learningLanguage!, inContext: context) {
            var categories = sets.map {$0.category ?? ""}
            categories = categories.filter {$0 != ""}
            self.tableData = categories
        }
        
        self.navigationItem.title = "Select Category"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        
        let category = self.tableData![indexPath.row]
        cell.nameLbl.text = category
        cell.depictionLbl.text = ""
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "languageSet") as! LanguageSetViewController
        vc.knownLanguage = self.knownLanguage
        vc.learningLanguage = self.learningLanguage
        
        self.navigationController?.show(vc, sender: nil)
    }
}
