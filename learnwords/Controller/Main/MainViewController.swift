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
    var isSpeechSupported = true
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
        if self.wordsTable != nil, self.wordsTable.count > 0  {
            loadWord(index: firstWordIndex(numberOfWords: wordsTable.count))
        }
        else {
            wordLabel.text = "No words"
        }
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
                UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
                    
                    if self.isKeyboardVisible {
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
}
