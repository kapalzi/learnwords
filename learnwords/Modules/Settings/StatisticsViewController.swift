//
//  StatisticsViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 21/11/2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class StatisticsViewController: UITableViewController  {
    
    var tableData: [Word]? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    }
    
    func initControls() {
        
    }
    
    func initNewWordButton() {
        
    }
    
    //table
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.tableData?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticsCell", for: indexPath) as! StatisticsCell
        
        self.configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    private func configureCell(cell: StatisticsCell, indexPath: IndexPath) {
    
        let word = self.tableData![indexPath.row] as Word
        
        cell.knownLabel.text = word.knownLanguage
        cell.learnedLabel.text = word.learningLanguage
        cell.goodLabel.text = String(word.goodCounter)
        cell.badLabel.text = String(word.badCounter)
        
        cell.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
