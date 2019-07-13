//
//  MainViewController+IBActions.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 13/07/2019.
//  Copyright © 2019 kapala. All rights reserved.
//

import UIKit

extension MainViewController {
    
    @IBAction func didClickCheckButton(_ sender: UIButton) {
        isWordCorrect(typedWord: textField.text)
        
    }
    
    @IBAction func showHelp(_ sender: UIButton) {
    }
    
    @IBAction func rightSideBtnClicked(_ sender: UIButton) {
        guard self.wordsTable != nil, self.wordsTable.count > 0 else {
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.card.center = CGPoint(x:self.card.center.x+200, y: self.card.center.y)
            self.card.alpha = 0
        }
        self.loadNextWord()
    }
    
    @IBAction func leftSideBtnClicked(_ sender: UIButton) {
        guard self.wordsTable != nil, self.wordsTable.count > 0 else {
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.card.center = CGPoint(x:self.card.center.x-200, y: self.card.center.y)
            self.card.alpha = 0
        }
        self.loadPrevWord()
    }
    
    @IBAction func microphoneBtnClicked(_ sender: RecordButton) {
        if self.isSpeechSupported {
            self.recordBtn.isSelected = !sender.isSelected
            if self.recordBtn.isSelected {
                self.authorizeSpeechRecognition()
            } else {
                self.stopRecording()
            }
        }
    }
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        guard self.wordsTable != nil, self.wordsTable.count > 0 else {
            return
        }
        
        let card = sender.view!
        let point = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        card.center = CGPoint(x: self.view.center.x + point.x, y: card.center.y)
        
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
            
            if velocity.y < 100 && point.y < -150 {
                self.willRotate()
                card.flipFromBot()
            } else if velocity.y > 100 && point.y > 150 {
                self.willRotate()
                card.flipFromTop()
            }
        }
    }
}
