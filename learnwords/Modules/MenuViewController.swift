//
//  MenuViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 03.10.2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    @IBOutlet weak var firstCellBg: UIImageView!
    @IBOutlet weak var secondCellBg: UIImageView!
    @IBOutlet weak var thirdCellBg: UIImageView!
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let bgView = UIImageView(frame: tableView.bounds)
        bgView.image = UIImage.init(named: "mainBg")
        bgView.addBlurEffect()
        self.tableView.backgroundView = bgView
        
        
//        let imgView = UIImageView.init(frame: tableView.bounds)
//        let img = UIImage.init(named: "mainBg")
//        imgView.image = img
//        imgView.backgroundColor = UIColor.blue
//        imgView.addBlurEffect()
//
//        self.view.insertSubview(imgView, at: 0)
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            loadWordsFromFiles()
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        self.firstCellBg.dropShadow(shadowColor: UIColor.white, fillColor: UIColor.clear ,imgName: "startLearningBg")
        self.secondCellBg.dropShadow(shadowColor: UIColor.white, fillColor: UIColor.clear ,imgName: "statsBg")
        self.thirdCellBg.dropShadow(shadowColor: UIColor.white, fillColor: UIColor.clear ,imgName: "settingsBg")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let viewHeight: CGFloat = view.frame.size.height
        let tableViewContentHeight: CGFloat = tableView.contentSize.height
        let marginHeight: CGFloat = (viewHeight - tableViewContentHeight) / 7.0
        
        self.tableView.contentInset = UIEdgeInsets(top: marginHeight, left: 0, bottom:  -marginHeight, right: 0)
    }
    
    func loadWordsFromFiles() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        LanguageSet.addNewLanguageSet(name: "German from English Top 1000", code: "germanenglishtop1000", isUnlocked: true, context: context)
        LanguageSet.addNewLanguageSet(name: "French from English Top 1000", code: "frenchenglishtop1000", isUnlocked: true, context: context)
        LanguageSet.addNewLanguageSet(name: "German from Polish Top 1000", code: "germanpolishtop1000", isUnlocked: true, context: context)
        LanguageSet.addNewLanguageSet(name: "Polish from German Top 1000", code: "polishgermantop1000", isUnlocked: true, context: context)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        var wordId = Int16(1)
        for language in ["germanenglishtop1000","frenchenglishtop1000","germanpolishtop1000","polishgermantop1000"] {
            if let path = Bundle.main.path(forResource: language, ofType: "txt") {
                do {
                    let info = ProcessInfo.processInfo
                    let begin = info.systemUptime
                    
                    let data = try String(contentsOfFile: path, encoding: .utf8)
                    let myStrings = data.components(separatedBy: .newlines)
                    
                    for myString in myStrings
                    {
                        let myStringArray = myString.components(separatedBy: " ")
                        
                        
                        Word.addNewWord(id: wordId, knownLanguage: myStringArray.last, learningLanguage: myStringArray.first, languageSetCode: language, context: context)
                        
                        wordId = wordId + 1
                        
                    }
                    let diff = (info.systemUptime - begin)
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    print("\(language) added in time: \(diff)")
                } catch {
                    print(error)
                }
            }
        }
        UserDefaults.standard.set(5, forKey: "answersToMaster")
    }
    
}
