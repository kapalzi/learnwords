//
//  ViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 16.03.2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var optionalWordLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var checkButton: UIButton!
    var originalViewFrame: CGRect!
    var word: Word!
    var wordsTable: Array<Word>!
    var currentWordIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WordsForLanguage(language: "japan")
        
        if wordsTable != nil  {
            loadWord(index: firstWordIndex(numberOfWords: wordsTable.count))
        }
        else {
            wordLabel.text = "No words"
            optionalWordLabel.text = ""
        }
        originalViewFrame = self.view.frame;
        self.textField.borderStyle = UITextBorderStyle.line
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func keyboardShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.view.frame.size.height = keyboardFrame.origin.y;
        print("keyboardFrame: \(keyboardFrame)")
    }
    
    @objc func keyboardHide(notification: NSNotification) {
        
        self.view.frame = originalViewFrame
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
        word.counter = word.counter+1
        
        let nextIndex = loopIndex(index: currentWordIndex+1)
        loadWord(index: nextIndex)
    }
    
    func loadPrevWord() {
        let prevIndex = loopIndex(index: currentWordIndex-1)
        loadWord(index: prevIndex)
    }
    
    func loopIndex(index: Int) -> Int {
        if index==wordsTable.count {
            return 0
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
            self.loadNextWord()
        }
        else {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = UIColor.red

            }, completion: { (true) in
                self.view.backgroundColor = UIColor.white
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
        word2.alternativeAlphabet = ""
        word2.counter = 0

        let word3 = Word.init(entity: Word.entity(), insertInto: context)

        word3.id = 1
        word3.language = "japan"
        word3.original = "neko"
        word3.english = "Cat"
        word3.polish = "kot"
        word3.alternativeAlphabet = ""
        word3.counter = 0

        let words = [word1,word2,word3]

        return words
    }

}

