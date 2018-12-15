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
    var cardY: CGFloat?
    var checkButtonBg: UIColor?
    var isReadingMode: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.cardY = self.card.frame.size.height/2 - self.card.frame.origin.y
        self.cardY = self.card.center.y
        self.cardCenter = CGPoint(x: self.view.center.x, y: self.cardY!)
        
        

        self.loadWords()
        if wordsTable != nil  {
            loadWord(index: firstWordIndex(numberOfWords: wordsTable.count))
        }
        else {
            wordLabel.text = "No words"
        }

        self.textField.borderStyle = UITextBorderStyle.roundedRect
        self.textField.backgroundColor = UIColor.init(white: 1, alpha: 0.9)
        
        badCounterLbl.backgroundColor = UIColor.init(white: 1, alpha: 0.8)
        goodCounterLbl.backgroundColor = UIColor.init(white: 1, alpha: 0.8)
        self.badCounterLbl.isHidden = true
        self.goodCounterLbl.isHidden = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(rightBarButtonClicked))
        let origImage = UIImage(named: "helpIcon")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        self.helpBtn.setImage(tintedImage, for: .normal)
        self.helpBtn.tintColor = UIColor.white //UIColor.init(red: 36/255, green: 185/255, blue: 255/255, alpha: 1.0)
        self.checkButtonBg = self.checkButton.backgroundColor
        initSwipe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func initSwipe() {
        
        let swipeUp = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeU))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.textField.addGestureRecognizer(swipeUp)
        
        let swipeRight = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeR))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeL))
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(swipeLeft)
        
    }
    
    override func keyboardShow(notification: NSNotification) {
        super.keyboardShow(notification: notification)
        self.cardY = self.card.frame.size.height/2 - self.card.frame.origin.y/2 + self.card.frame.origin.x
        self.cardY = self.card.center.y
        self.cardY = self.card.frame.size.height/2 + self.card.frame.origin.y
        self.cardCenter = CGPoint(x: self.view.center.x, y: self.cardY!)
        self.card.layoutIfNeeded()
    }
    
    override func keyboardHide(notification: NSNotification) {
        super.keyboardHide(notification: notification)
        self.cardY = 255
        self.cardY = self.card.frame.size.height/2 + self.card.frame.origin.y
        self.cardCenter = CGPoint(x: self.view.center.x, y: self.cardY!)
        self.card.layoutIfNeeded()
    }
    
    override func viewWillLayoutSubviews() {
        self.card.dropShadow(imgName: "mainBg")
    }
    
    @objc func swipeR(){
//        loadNextWord()
    }
    
    @objc func swipeL(){
//        loadPrevWord()
    }
    
    @objc func swipeU(){
        
        self.textField.text = self.word.learningLanguage
    }
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        card.center = CGPoint(x: self.view.center.x + point.x, y: card.center.y)
//        https://www.youtube.com/watch?v=sBnqFLJqn9M
        
        if sender.state == UIGestureRecognizerState.ended {
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x:card.center.x-200, y: card.center.y)
                    card.alpha = 0
                }
                self.loadNextWord()
                return
            } else if card.center.x > (self.view.frame.width - 75) {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x:card.center.x+200, y: card.center.y)
                    card.alpha = 0
                }
                self.loadPrevWord()
                return
            }
            
            UIView.animate(withDuration: 0.2) {
//                print(self.wordLabel.frame.origin.y)
//                let center = CGPoint(x: self.view.center.x, y:self.wordLabel.frame.origin.y + (self.card.frame.size.height/2))
                card.center.x = self.cardCenter!.x
                
            }
        }
    }
    func loadWords() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.wordsTable = Word.getWordsForSelectedSet(inContext: context)
    }
    
    func loadWord(index: Int) {
        
        word = wordsTable[index]
        currentWordIndex = index
        textField.text=""
        wordLabel.text = word.knownLanguage
        if isReadingMode {
            self.textField.text = word.learningLanguage
        }
        self.goodCounterLbl.text = String(format: "%i", word.goodCounter)
        self.badCounterLbl.text = String.init(format: "%i", word.badCounter)
        UserDefaults.standard.set(index, forKey: "lastWordId")
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isWordCorrect(typedWord: textField.text)
        
        return true
    }
    
    func isWordCorrect(typedWord: String?) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if(typedWord?.lowercased() == word.learningLanguage?.lowercased()) {
            if !self.isReadingMode {
                Word.addGoodAnwer(wordId: word.id, context: context)
                
                if word.goodCounter >= UserDefaults.standard.integer(forKey: "answersToMaster") {
                    wordsTable.remove(at: Int(word!.id-1))
                }
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.checkButton.backgroundColor = UIColor.green
                
            }, completion: { (true) in
                self.checkButton.backgroundColor = self.checkButtonBg
            })
            self.loadNextWord()
        }
        else {
            if !isReadingMode {
                Word.addBadAnwer(wordId: word.id, context: context)
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
            self.badCounterLbl.text = String.init(format: "%i", word.badCounter)
            UIView.animate(withDuration: 0.2, animations: {
                self.checkButton.backgroundColor = UIColor.red

            }, completion: { (true) in
                self.checkButton.backgroundColor = self.checkButtonBg
            })
        }
    }
    
    @IBAction func didClickCheckButton(_ sender: UIButton) {
        isWordCorrect(typedWord: textField.text)
       
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func showHelp(_ sender: UIButton) {
        //        let popVC = storyboard?.instantiateViewController(withIdentifier: "popVC") as! HelpPopoverViewController
        //
        //        popVC.modalPresentationStyle = .popover
        //
        //        let popOverVC = popVC.popoverPresentationController
        //        popOverVC?.delegate = self
        //        popOverVC?.sourceView = self.textField
        ////        popOverVC?.sourceRect = CGRect(x: self.helpBtn.bounds.midX, y: self.helpBtn.bounds.minY, width: 0, height: 0)
        //        popOverVC?.sourceRect = CGRect(x: self.textField.center.x, y: self.textField.frame.origin.y, width: 0, height: 0)
        //        popVC.preferredContentSize = CGSize(width: 250, height: 50)
        //
        //        let helpLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        //        helpLbl.text = word.learningLanguage
        //        helpLbl.font = UIFont.systemFont(ofSize: 30)
        //        helpLbl.textAlignment = .center
        //        helpLbl.textColor = UIColor.purple
        //        popVC.view.addSubview(helpLbl)
        //
        //        self.present(popVC, animated: true)

    }

   @objc func rightBarButtonClicked() {
        var ac = UIAlertController()
    
        ac = UIAlertController.init(title: "Mode", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        ac.addAction(UIAlertAction.init(title: "Reading", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            self.isReadingMode = true
            self.loadPrevWord()
            self.loadNextWord()
        }))
        ac.addAction(UIAlertAction.init(title: "Writing", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            self.isReadingMode = false
            self.loadPrevWord()
            self.loadNextWord()
        }))
    
    ac.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) in
        
    }))
    
        self.present(ac, animated: true, completion: nil)
    }
    @IBAction func rightSideBtnClicked(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            self.card.center = CGPoint(x:self.card.center.x+200, y: self.card.center.y)
            self.card.alpha = 0
        }
        
       
        self.loadNextWord()
    }
    @IBAction func leftSideBtnClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.card.center = CGPoint(x:self.card.center.x-200, y: self.card.center.y)
            self.card.alpha = 0
        }
        self.loadPrevWord()
    }
}

extension UIViewController: UIPopoverPresentationControllerDelegate {
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
}
}
