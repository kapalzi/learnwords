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
    var masteredWords: [Word]? = nil
    var restOfWords: [Word]? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let toMaster = UserDefaults.standard.value(forKey: "answersToMaster") as! Int16
        self.masteredWords = tableData?.filter{$0.goodCounter >= toMaster}
        self.restOfWords = tableData?.filter{$0.goodCounter < toMaster}
        
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 70))
        header.backgroundColor = #colorLiteral(red: 0.2642498016, green: 0.7589192986, blue: 0.9943001866, alpha: 1)
        let goodLbl = UILabel(frame:CGRect(x: view.frame.width/2, y: 20, width: 150, height: 30))
        goodLbl.textColor = .white
        goodLbl.text = "Good"
        header.addSubview(goodLbl)
        
        let wrongLbl = UILabel(frame:CGRect(x: view.frame.width-75, y: 20, width: 150, height: 30))
        wrongLbl.textColor = .white
        wrongLbl.text = "Wrong"
        header.addSubview(wrongLbl)
        
        if section == 0 {
            
            let lbl = UILabel(frame: CGRect(x: 20, y: 20, width: view.frame.width, height: 30))
            lbl.text = "Mastered"
            lbl.textColor = .white
            header.addSubview(lbl)
        } else {
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (masteredWords?.count)!
        } else {
            return (restOfWords?.count)!
        }
//        return (self.tableData?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticsCell", for: indexPath) as! StatisticsCell
        
        self.configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    private func configureCell(cell: StatisticsCell, indexPath: IndexPath) {
//    let word = self.tableData![indexPath.row] as Word
        var word = Word()
        if indexPath.section == 0 {
             word = self.masteredWords![indexPath.row] as Word
        } else {
            word = self.restOfWords![indexPath.row] as Word
        }
        
        
        
        cell.knownLabel.text = word.knownLanguage
        cell.learnedLabel.text = word.learningLanguage
        cell.goodLabel.text = String(word.goodCounter)
        cell.badLabel.text = String(word.badCounter)
        
        cell.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
