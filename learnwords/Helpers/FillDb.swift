//
//  FillDb.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 23/12/2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class FillDb {
    
    static func loadWordsFromFilesIfFirstLaunch() {
        if UserDefaults.standard.bool(forKey: "launchedBefore")  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            loadWordsFromFiles()
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }

   private static func loadWordsFromFiles() {
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
