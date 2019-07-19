//
//  learnwordsTests.swift
//  learnwordsTests
//
//  Created by Krzysztof Kapała on 13/07/2019.
//  Copyright © 2019 kapala. All rights reserved.
//

import XCTest
@testable import learnwords

class MainViewControllerWordsLogicTests: XCTestCase {
    
    var mainViewController: MainViewController!
    
    override func setUp() {
        
        mainViewController = MainViewController()
        mainViewController.wordsTable = [Word]()
        mainViewController.textField = UITextField()
        mainViewController.wordLabel = UILabel()
        
        let word1 = Word()
        let word2 = Word()
        let word3 = Word()
        
        word2.knownLanguage = "Cat"
        
        mainViewController.wordsTable?.append(word1)
        mainViewController.wordsTable?.append(word2)
        mainViewController.wordsTable?.append(word3)
    }
    
    override func tearDown() {
        mainViewController = nil
    }
    
    func testLoopIndex() {
        XCTAssertEqual(mainViewController.loopIndex(index: mainViewController.wordsTable.count), 0)
        XCTAssertEqual(mainViewController.loopIndex(index: -1), mainViewController.wordsTable.count-1)
        XCTAssertEqual(mainViewController.loopIndex(index: 1), 1)
    }
    
    func testLoadWord() {
        mainViewController.loadWord(index: 30)
        XCTAssertEqual(mainViewController.wordLabel.text, "Cat")
    }
}
