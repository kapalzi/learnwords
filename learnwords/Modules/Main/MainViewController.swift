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
    @IBOutlet weak var badCounterLbl: UILabel!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var goodCounterLbl: UILabel!
    var word: Word!
    var wordsTable: Array<Word>!
    var currentWordIndex: Int!
    var appDelegate: AppDelegate!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var settingsButton: UIButton!    
    @IBOutlet weak var card: UIView!
    var cardCenter: CGPoint?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cardCenter = self.card.center
        WordsForLanguage(language: "German")
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
        badCounterLbl.backgroundColor = UIColor.init(white: 1, alpha: 0.8)
        goodCounterLbl.backgroundColor = UIColor.init(white: 1, alpha: 0.8)
        helpBtn.backgroundColor = UIColor.init(white: 1, alpha: 0.8)
        
        initSwipe()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func initSwipe() {
        let swipeRight = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeR))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeL))
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func swipeR(){
//        loadNextWord()
    }
    
    @objc func swipeL(){
//        loadPrevWord()
    }
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        card.center = CGPoint(x: self.view.center.x + point.x, y: view.center.y + point.y)
        let xFromCenter = card.center.x - self.view.center.x
        
//        https://www.youtube.com/watch?v=sBnqFLJqn9M
        
        if sender.state == UIGestureRecognizerState.ended {
            print(xFromCenter)
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x:card.center.x-200, y: card.center.y+75)
                    card.alpha = 0
                }
                self.loadNextWord()
                return
            } else if card.center.x > (self.view.frame.width - 75) {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x:card.center.x+200, y: card.center.y+75)
                    card.alpha = 0
                }
                self.loadPrevWord()
                return
            }
            
            UIView.animate(withDuration: 0.2) {
//                print(self.wordLabel.frame.origin.y)
//                let center = CGPoint(x: self.view.center.x, y:self.wordLabel.frame.origin.y + (self.card.frame.size.height/2))
                card.center = self.cardCenter!
                
            }
        }
    }
    func WordsForLanguage(language: String) {
//        wordsTable = mockupObjects()
        wordsTable = loadWordsFromLanguage(language: "German")
        
    }
    
    func loadWord(index: Int) {
        word = wordsTable[index]
        
        currentWordIndex = index
        textField.text=""
        wordLabel.text = word.english
        optionalWordLabel.text = word.alternativeAlphabet
        self.goodCounterLbl.text = String(format: "%i", word.goodCounter)
        self.badCounterLbl.text = String.init(format: "%i", word.badCounter)
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
        return Int(arc4random_uniform(UInt32(numberOfWords)))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isWordCorrect(typedWord: textField.text)
        
        return true
    }
    
    func isWordCorrect(typedWord: String?) {
        print(word.original)
        if(typedWord?.lowercased() == word.original?.lowercased()) {
            word.goodCounter = word.goodCounter+1
            helpBtn.setTitle("", for: .normal)
            self.loadNextWord()
        }
        else {
            helpBtn.setTitle("Help", for: .normal)
            word.badCounter = word.badCounter+1
            self.badCounterLbl.text = String.init(format: "%i", word.badCounter)
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
        isWordCorrect(typedWord: textField.text)
        
//        if isWordCorrect {
//            var ac = UIAlertController()
//
//            ac = UIAlertController.init(title: nil, message: "Correct", preferredStyle: UIAlertControllerStyle.alert)
//            ac.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) in
//                self.textField.text=""
//                self.loadNextWord()
//            }))
//            self.present(ac, animated: true, completion: nil)
//        }
       
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func showHelp(_ sender: UIButton) {
        
        let popVC = storyboard?.instantiateViewController(withIdentifier: "popVC") as! HelpPopoverViewController
        
        popVC.modalPresentationStyle = .popover
        
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.helpBtn
        popOverVC?.sourceRect = CGRect(x: self.helpBtn.bounds.midX, y: self.helpBtn.bounds.minY, width: 0, height: 0)
        popVC.preferredContentSize = CGSize(width: 250, height: 50)
        
        let helpLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        helpLbl.text = word.original
        helpLbl.font = UIFont.systemFont(ofSize: 30)
        helpLbl.textAlignment = .center
        helpLbl.textColor = UIColor.purple
        popVC.view.addSubview(helpLbl)

        self.present(popVC, animated: true)
    }
    
    func mockupObjects() -> Array<Word> {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let word1 = Word.init(entity: Word.entity(), insertInto: context)

        word1.id = 1
        word1.language = "Japan"
        word1.original = "tenjou"
        word1.english = "Ceiling"
        word1.usersLanguage = "sufit"
        word1.alternativeAlphabet = "天井"
        

        let word2 = Word.init(entity: Word.entity(), insertInto: context)

        word2.id = 2
        word2.language = "Japan"
        word2.original = "anata"
        word2.english = "You"
        word2.usersLanguage = "ty"
        word2.alternativeAlphabet = "あなた"
        

        let word3 = Word.init(entity: Word.entity(), insertInto: context)

        word3.id = 1
        word3.language = "Japan"
        word3.original = "neko"
        word3.english = "Cat"
        word3.usersLanguage = "kot"
        word3.alternativeAlphabet = "ネコ"
        

        let words = [word1,word2,word3]

        return words
    }

    func loadWordsFromLanguage(language: String) -> Array<Word>? {
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
                return words
            } catch {
                print(error)
            }
        }
        return nil
    }
    
}

extension UIViewController: UIPopoverPresentationControllerDelegate {
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
}
}
