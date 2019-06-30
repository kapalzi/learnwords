//
//  KnownLanguageViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 27/02/2019.
//  Copyright © 2019 kapala. All rights reserved.
//

import UIKit

class KnownLanguageViewController: BaseSetViewController  {
    
    var tableData: [(code: String, name: String)]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        tableData = LanguageSet.getKnownLanguages(inContext: context)
        self.navigationItem.title = "Select Your Known Language"
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
        cell.nameLbl.text = set.name
        cell.depictionLbl.text = ""
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let set = self.tableData![indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "learningSet") as! LearningLanguageViewController
        vc.knownLanguage = set.code
        
        self.navigationController?.show(vc, sender: nil)
    }
}
