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
    var word: Word!
    var wordsTable: Array<Word>!
    var currentWordIndex: Int!
    var appDelegate: AppDelegate!
    @IBOutlet weak var card: UIView!
    var cardCenter: CGPoint?
    var checkButtonBg: UIColor?
    var isRotated: Bool = false
    
    let audioEngine = AVAudioEngine()
    var speechRecognizer = SFSpeechRecognizer()
    var request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    @IBOutlet weak var recordBtn: RecordButton!
    
    override func viewDidLoad() {
        FillDb.loadWordsFromFilesIfFirstLaunch()
        super.viewDidLoad()
        self.cardCenter = CGPoint(x: self.view.center.x, y: self.card.center.y)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Learning"
        
        self.loadWords()
        if self.wordsTable != nil  {
            loadWord(index: firstWordIndex(numberOfWords: wordsTable.count))
        }
        else {
            wordLabel.text = "No words"
        }
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(rightBarButtonClicked))
//        let navigationItem = UINavigationItem(title: "Title")
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(rightBarButtonClicked))
//        self.navigationController?.navigationBar.pushItem(navigationItem, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
                UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
                    
                    if self.isKeyboardVisible {
//                        self.view.frame.origin.y -= 49
                        self.view.frame = self.originalViewFrame
                    } else {
                        self.view.frame.origin.y += 49
                    }
                    
                    self.view.frame.size.height = targetFrame.origin.y
                    self.card.dropShadow()
        
                },completion: {(true) in
                    self.card.layoutIfNeeded()
                    
                })
    }
    
    override func viewWillLayoutSubviews() {
        self.card.dropShadow()
    }
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
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
                card.center.x = self.cardCenter!.x
            }
//            if card.center.x >= 75 && card.center.x <= (self.view.frame.width - 75) {
//
//                return
//            }
            
            if velocity.y < 100 && point.y < -150 {
                self.willRotate()
                card.flipFromBot()
                print("bot")
            } else if velocity.y > 100 && point.y > 150 {
                self.willRotate()
                card.flipFromTop()
                print("up")
            }
            print(velocity.y)
            print(point.y)
        }
    }
    func loadWords() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.wordsTable = Word.getWordsForSelectedSet(inContext: context)
        print( LanguageSet.getSelectedSet(context: context).identifier!)
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: LanguageSet.getSelectedSet(context: context).identifier!))
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isWordCorrect(typedWord: textField.text)
        
        return true
    }
    
    func willRotate() {
        self.isRotated = !self.isRotated
        if self.isRotated {
            self.wordLabel.text = self.word.learningLanguage
        } else {
            self.wordLabel.text = self.word.knownLanguage
        }
    }
    
    func isWordCorrect(typedWord: String?) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if(typedWord?.lowercased() == word.learningLanguage?.lowercased()) {
            Word.addGoodAnwer(wordId: word.id, context: context)
            
            if word.goodCounter >= UserDefaults.standard.integer(forKey: "answersToMaster") {
                wordsTable.remove(at: Int(currentWordIndex))
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
    
    @IBAction func didClickCheckButton(_ sender: UIButton) {
        isWordCorrect(typedWord: textField.text)
       
    }
    
    @IBAction func showHelp(_ sender: UIButton) {
    }

   @objc func rightBarButtonClicked() {
        var ac = UIAlertController()
    
        ac = UIAlertController.init(title: "Mode", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        ac.addAction(UIAlertAction.init(title: "Reading", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            self.loadPrevWord()
            self.loadNextWord()
        }))
        ac.addAction(UIAlertAction.init(title: "Writing", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
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
        print("DID CLICK")
        self.recordBtn.isSelected = !sender.isSelected
        if self.recordBtn.isSelected {
            self.authorizeSpeechRecognition()
        } else {
            self.stopRecording()
        }
    }
    
    func authorizeSpeechRecognition() {
        self.recordBtn.stopAnimation()
        SFSpeechRecognizer.requestAuthorization {
            [unowned self] (authStatus) in
            switch authStatus {
            case .authorized:
                do {
                    self.recordBtn.startAnimation()
                    try self.startRecording()
                } catch let error {
                    self.recordBtn.stopAnimation()
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
                print(transcription.formattedString)
                self.textField.text = transcription.formattedString
                self.stopRecording()
                self.isWordCorrect(typedWord: self.textField.text)
                
            }
        }
    }
    
    fileprivate func stopRecording() {
        self.recordBtn.stopAnimation()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        request.endAudio()
        request = SFSpeechAudioBufferRecognitionRequest()
        recognitionTask?.cancel()
    }
    
    
}
