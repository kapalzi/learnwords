//
//  ViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 16.03.2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var optionalWordLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var checkButton: UIButton!
    var word: Word!
    var wordsTable: Array<Word>!
    var currentWordIndex: Int!
    var panTestCunter: Int!
    var appDelegate: AppDelegate!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var settingsButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        WordsForLanguage(language: "japan")
        panTestCunter = 0
        if wordsTable != nil  {
            loadWord(index: firstWordIndex(numberOfWords: wordsTable.count))
        }
        else {
            wordLabel.text = "No words"
            optionalWordLabel.text = ""
        }
        
        wordLabel.textColor=UIColor.purple
        wordLabel.font = UIFont.boldSystemFont(ofSize: 40)
        optionalWordLabel.textColor=UIColor.purple
        optionalWordLabel.font = UIFont.boldSystemFont(ofSize: 40)
        settingsButton.setTitleColor(UIColor.purple, for: UIControlState.normal)
        
        self.textField.borderStyle = UITextBorderStyle.roundedRect
        textField.backgroundColor = UIColor.init(white: 1, alpha: 0.8)
        checkButton.backgroundColor = UIColor.init(white: 1, alpha: 0.8)
        checkButton.setTitleColor(UIColor.purple, for: UIControlState.normal)
        let img = UIImage.init(named: "solojazz")!
        view.backgroundColor = UIColor.init(patternImage:img)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func WordsForLanguage(language: String) {
        wordsTable = mockupObjects()
        
    }
    
    func loadWord(index: Int) {
        word = wordsTable[index]
        
        currentWordIndex = index
        textField.text=""
        wordLabel.text = word.english
        optionalWordLabel.text = word.alternativeAlphabet
    }
    
    func loadNextWord() {
        let nextIndex = loopIndex(index: currentWordIndex+1)
        loadWord(index: nextIndex)
    }
    
    func loadPrevWord() {
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
        return Int(arc4random_uniform(UInt32(numberOfWords)))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isWordCorrect(typedWord: textField.text)
        
        return true
    }
    
    func isWordCorrect(typedWord: String?) {
        if(typedWord == word.original) {
            word.counter = word.counter+1
            self.loadNextWord()
        }
        else {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = UIColor.red

            }, completion: { (true) in
                let img = UIImage.init(named: "solojazz")!
                self.view.backgroundColor = UIColor.init(patternImage:img)
//                self.view.backgroundColor = UIColor.white
            })
        }
    }
    
    @IBAction func didClickCheckButton(_ sender: UIButton) {
        var enteredText = textField.text
        
        enteredText = enteredText?.lowercased()
        if false {
            var ac = UIAlertController()
            
            ac = UIAlertController.init(title: nil, message: "Correct", preferredStyle: UIAlertControllerStyle.alert)
            ac.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) in
                self.textField.text=""
                self.loadNextWord()
            }))
            self.present(ac, animated: true, completion: nil)
        }
        
        isWordCorrect(typedWord: textField.text)
    }
    @IBAction func didSwipeLeft(_ sender: UIScreenEdgePanGestureRecognizer) {
        loadPrevWord()
        panTestCunter=panTestCunter+1
        print(panTestCunter)
    }
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func mockupObjects() -> Array<Word> {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let word1 = Word.init(entity: Word.entity(), insertInto: context)

        word1.id = 1
        word1.language = "japan"
        word1.original = "tenjou"
        word1.english = "Ceiling"
        word1.polish = "sufit"
        word1.alternativeAlphabet = "天井"
        word1.counter = 0

        let word2 = Word.init(entity: Word.entity(), insertInto: context)

        word2.id = 2
        word2.language = "japan"
        word2.original = "anata"
        word2.english = "You"
        word2.polish = "ty"
        word2.alternativeAlphabet = "あなた"
        word2.counter = 0

        let word3 = Word.init(entity: Word.entity(), insertInto: context)

        word3.id = 1
        word3.language = "japan"
        word3.original = "neko"
        word3.english = "Cat"
        word3.polish = "kot"
        word3.alternativeAlphabet = "ネコ"
        word3.counter = 0

        let words = [word1,word2,word3]

        return words
    }

}

