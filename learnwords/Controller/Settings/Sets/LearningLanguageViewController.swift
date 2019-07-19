//
//  LearningLanguageViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 27/02/2019.
//  Copyright © 2019 kapala. All rights reserved.
//

import UIKit

class LearningLanguageViewController: BaseSetViewController  {
    
    var tableData: [(code: String, name: String)]? = nil
    var knownLanguage: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        tableData = LanguageSet.getLearningLanguages(forSelectedKnownLanguage: self.knownLanguage!, inContext: context)
        self.navigationItem.title = "Select Your Learning Language"
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
        
        let set = self.tableData![indexPath.row]
        cell.mainLabel.text = set.name
        cell.depictionLbl.text = ""
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let set = self.tableData![indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "languageSet") as! LanguageSetViewController
        vc.knownLanguage = self.knownLanguage
        vc.learningLanguage = set.code
        
        self.navigationController?.show(vc, sender: nil)
    }
}
