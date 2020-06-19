//
//  MainViewController+WordsLogic.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 13/07/2019.
//  Copyright © 2019 kapala. All rights reserved.
//

import UIKit
import Speech

extension MainViewController {
    
    func loadWords() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.wordsTable = Word.getWordsForSelectedSet(inContext: context)
        
        guard let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: LanguageSet.getSelectedSet(context: context).identifier!)) else {
            let alert = UIAlertController.init(title: "Selected set's language is not supported by speech recognition feature.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            self.isSpeechSupported = false
            return
        }
        self.speechRecognizer = speechRecognizer
    }
    
    func loadWord(index: Int) {
        self.playHaptic()
        self.isRotated = false
        word = wordsTable[index]
        currentWordIndex = index
        textField.text=""
        wordLabel.text = word.knownLanguage
        UserDefaults.standard.set(index, forKey: "lastWordId")
        
        if self.recordBtn.isSelected {
            self.stopRecording()
            self.authorizeSpeechRecognition()
        }
    }
    
    func loadNextWord() {
        UIView.animate(withDuration: 0.3) {
            self.card.center = CGPoint(x:self.card.center.x-800, y: self.card.center.y)
            self.card.alpha = 1
        }
        let nextIndex = loopIndex(index: currentWordIndex+1)
        loadWord(index: nextIndex)
    }
    
    func loadPrevWord() {
        UIView.animate(withDuration: 0.3) {
            self.card.center = CGPoint(x:self.card.center.x+800, y: self.card.center.y)
            self.card.alpha = 1
        }
        let prevIndex = loopIndex(index: currentWordIndex-1)
        loadWord(index: prevIndex)
    }
    
    func loopIndex(index: Int) -> Int {
        if index == wordsTable.count {
            return 0
        }
        else if index == -1 {
            return wordsTable.count-1
        }
        else {
            return index
        }
    }
    
    func firstWordIndex(numberOfWords: Int) -> Int {
        //        return Int(arc4random_uniform(UInt32(numberOfWords)))
        let index = UserDefaults.standard.integer(forKey: "lastWordId")
        if index == -1 {
            return wordsTable.count-1
        }
        return index
    }
    
    func isWordCorrect(typedWord: String?) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if(typedWord?.lowercased() == word.learningLanguage?.lowercased()) {
            Word.addGoodAnwer(wordId: word.id, context: context)
            WordHistory.addOneRememberedForToday(inContext: context)
            if word.goodCounter >= UserDefaults.standard.integer(forKey: "answersToMaster") {
                wordsTable.remove(at: Int(currentWordIndex))
                WordHistory.addOneMasteredForToday(inContext: context)
            }
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.loadNextWord()
            
        }
        else {
            Word.addBadAnwer(wordId: word.id, context: context)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.card.shake()
            self.textField.text = ""
            self.playHaptic()
            if self.recordBtn.isSelected {
                self.stopRecording()
                self.authorizeSpeechRecognition()
            }
        }
    }
}
