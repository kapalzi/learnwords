//
//  LanguageSetViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 21/11/2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class LanguageSetViewController: BaseSetViewController  {
    
    var tableData: [LanguageSet]? = nil
    var isMainMode: Bool = false
    var knownLanguage: String? = nil
    var learningLanguage: String? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Your Language Sets"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        if self.navigationController?.viewControllers.count == 1 {
            self.isMainMode = true
            self.navigationController?.navigationBar.topItem?.title = "Statistics"
        }
        
        if self.isMainMode {
            tableData = LanguageSet.getUsedLanguageSets(inContext: context)
        } else {
            tableData = LanguageSet.getAllLanguageSets(forKnownLanguage: self.knownLanguage!, forLearningLanguage: self.learningLanguage!, inContext: context)
        }
        
        self.tableView.reloadData()
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
        
        if set.isUserMade == true &&  self.isMainMode {//
            cell.editBtn.isHidden = false
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let set = self.tableData![indexPath.row] as LanguageSet
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if self.isMainMode {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "statistics") as! StatisticsViewController
//            vc.tableData = Word.getWords(ForSet: set, inContext: context)
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            LanguageSet.setLanguageSetAsSelected(code: set.code!, context: context)
            UserDefaults.standard.set(0, forKey: "lastWordId")
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
            
            
        }
    }
    
    @IBAction func editBtnDidTouchUpInside(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "newSet") as! NewSetViewController
        guard let cell = sender.superview?.superview?.superview as? SetsCell else {
            return // or fatalError() or whatever
        }
        let indexPath = tableView.indexPath(for: cell)
        let set = self.tableData![indexPath!.row] as LanguageSet
        
        vc.setName = set.name
        vc.setDepiction = set.depiction
        vc.learningLanguage = (set.learningLanguage, set.identifier)
        
//        let locale = NSLocale(localeIdentifier: set.knownLanguage!)
//        print(locale)
//        print(set)
//        print(locale.displayName(forKey: NSLocale.Key.identifier, value: set.knownLanguage)!)
//        
//        vc.yourLanguage = (locale.displayName(forKey: NSLocale.Key.identifier, value: set.knownLanguage)! , set.knownLanguage!)
        vc.setCode = set.code
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let words = Word.getWords(ForSet: set, inContext: context)
//        var tupleWords: [(knownLanguage:String?, learningLanguage:String?)] = [(knownLanguage:String?, learningLanguage:String?)]()
//        words.forEach { (word) in
//            let tuple = (knownLanguage:word.knownLanguage, learningLanguage:word.learningLanguage)
//            tupleWords.append(tuple)
//        }
        vc.words = words
        self.navigationController?.show(vc, sender: nil)
    }
}

