//
//  ViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 16.03.2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit
import Speech

class MainViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var checkButton: UIButton!
    var word: Word!
    var wordsTable: Array<Word>!
    var currentWordIndex: Int!
    var appDelegate: AppDelegate!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var card: UIView!
    var cardCenter: CGPoint?
//    var cardY: CGFloat?
    var checkButtonBg: UIColor?
    var isReadingMode: Bool = false
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "de"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    override func viewDidLoad() {
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            self.loadWordsFromFiles()
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        super.viewDidLoad()
//        self.cardY = self.card.frame.size.height/2 - self.card.frame.origin.y
//        self.cardY = self.card.center.y
        self.cardCenter = CGPoint(x: self.view.center.x, y: self.card.center.y)
        
        

        self.loadWords()
        if wordsTable != nil  {
            loadWord(index: firstWordIndex(numberOfWords: wordsTable.count))
        }
        else {
            wordLabel.text = "No words"
        }

        self.textField.borderStyle = UITextBorderStyle.roundedRect
        self.textField.backgroundColor = UIColor.init(white: 1, alpha: 0.9)
        
//        self.navigationItem.rightBarButtonItem =
//        self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(rightBarButtonClicked))
//        self.checkButtonBg = self.checkButton.backgroundColor
        
        self.initSwipe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.topItem?.title = "Learning"
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
//        self.cardY = self.card.frame.size.height/2 - self.card.frame.origin.y/2 + self.card.frame.origin.x
//        self.cardY = self.card.center.y
//        self.cardY = self.card.frame.size.height/2 + self.card.frame.origin.y
//        self.cardCenter = CGPoint(x: self.view.center.x, y: self.cardY!)
        self.card.layoutIfNeeded()
    }
    
    override func keyboardHide(notification: NSNotification) {
        super.keyboardHide(notification: notification)
//        self.cardY = 255
//        self.cardY = self.card.frame.size.height/2 + self.card.frame.origin.y
//        self.cardCenter = CGPoint(x: self.view.center.x, y: self.cardY!)
        self.card.layoutIfNeeded()
    }
    
    override func viewWillLayoutSubviews() {
        self.card.dropShadow()
//        self.textField.dropShadow()
//        self.checkButton.dropShadow()
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
//                self.checkButton.backgroundColor = UIColor.green
                
            }, completion: { (true) in
//                self.checkButton.backgroundColor = self.checkButtonBg
            })
            self.loadNextWord()
        }
        else {
            if !isReadingMode {
                Word.addBadAnwer(wordId: word.id, context: context)
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
            self.card.shake()
            let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            
            // Prepare shortly before playing
            lightImpactFeedbackGenerator.prepare()
            
            // Play the haptic signal
            lightImpactFeedbackGenerator.impactOccurred()
            UIView.animate(withDuration: 0.3, animations: {
//                self.checkButton.backgroundColor = UIColor.red

            }, completion: { (true) in
//                self.checkButton.backgroundColor = self.checkButtonBg
            })
        }
    }
    
    @IBAction func didClickCheckButton(_ sender: UIButton) {
        isWordCorrect(typedWord: textField.text)
       
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
    @IBAction func microphoneBtnClicked(_ sender: RecordButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.animate()
//            let tintedImage = sender.backgroundImage(for: .normal)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//            sender.setBackgroundImage(tintedImage, for: .normal)
//            sender.tintColor = #colorLiteral(red: 0.2980392157, green: 0.8196078431, blue: 0.2156862745, alpha: 1)
            self.authorizeSpeechRecognition()
            
        } else {
            let tintedImage = sender.backgroundImage(for: .normal)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            sender.setBackgroundImage(tintedImage, for: .normal)
            sender.tintColor = .black
            self.stopRecording()
        }
    }
    
    func authorizeSpeechRecognition() {
        SFSpeechRecognizer.requestAuthorization {
            [unowned self] (authStatus) in
            switch authStatus {
            case .authorized:
                do {
                    try self.startRecording()
                } catch let error {
                    print("There was a problem starting recording: \(error.localizedDescription)")
                }
            case .denied:
                print("Speech recognition authorization denied")
            case .restricted:
                print("Not available on this device")
            case .notDetermined:
                print("Not determined")
            }
        }
    }
    
    fileprivate func startRecording() throws {
        // 1
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        // 2
        node.installTap(onBus: 0, bufferSize: 1024,
                        format: recordingFormat) { [unowned self]
                            (buffer, _) in
                            self.request.append(buffer)
        }
        
        // 3
        audioEngine.prepare()
        try audioEngine.start()
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request) {
            [unowned self]
            (result, _) in
            if let transcription = result?.bestTranscription {
                self.textField.text = transcription.formattedString
                self.isWordCorrect(typedWord: self.textField.text)
                
            }
            self.stopRecording()
        }
    }
    
    fileprivate func stopRecording() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        request.endAudio()
        recognitionTask?.cancel()
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

extension UIViewController: UIPopoverPresentationControllerDelegate {
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
}
}
