//
//  MenuViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 03.10.2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let bgView = UIImageView(frame: tableView.bounds)
        bgView.image = UIImage.init(named: "mainBg")
        self.tableView.backgroundView = bgView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func checkDb() {
        let language = "german"
        
        
        
        if let path = Bundle.main.path(forResource: language, ofType: "txt") {
            do {
            
                
                
                let info = ProcessInfo.processInfo
                let begin = info.systemUptime
                
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                var words = [Word]()
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                var wordId = Int16(1)
                for myString in myStrings
                {
                    let myStringArray = myString.components(separatedBy: " ")
                    let word1 = Word.init(entity: Word.entity(), insertInto: context)
                    word1.id = wordId
                    word1.language = language
                    word1.original = myStringArray.first
                    word1.english = myStringArray.last
                    word1.badCounter = 0
                    word1.badCounter = 0
                    
                    wordId = wordId + 1
                    
                    words.append(word1)
                }
                let diff = (info.systemUptime - begin)
                print("\(language) added in time: \(diff)")
//                return words
            } catch {
                print(error)
            }
        }
    }
    
}
