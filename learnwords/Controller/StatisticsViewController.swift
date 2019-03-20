//
//  StatisticsViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 21/11/2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController  {
    
    var tableData: [Word]? = nil
    var masteredWords: [Word]? = nil
    var restOfWords: [Word]? = nil
    @IBOutlet weak var rememberedWordsLbl: UILabel!
    @IBOutlet weak var masteredWordsLbl: UILabel!
    @IBOutlet weak var lastMonthBtn: UIButton!
    @IBOutlet weak var last7DaysBtn: UIButton!
    @IBOutlet weak var lastYearBtn: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var filtersView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let toMaster = UserDefaults.standard.value(forKey: "answersToMaster") as! Int16
        self.masteredWords = tableData?.filter{$0.goodCounter >= toMaster}
        self.restOfWords = tableData?.filter{$0.goodCounter < toMaster}
        self.cardView.dropShadow()
        self.filtersView.dropShadow()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if let wordHistory = WordHistory.getWordHistory(forDate: Calendar.current.startOfDay(for: Date()), inContext: context) {
            self.rememberedWordsLbl.text = "\(wordHistory.remembered)"
            self.masteredWordsLbl.text = "\(wordHistory.mastered)"
        }
    }
    
    @IBAction func last7DaysDidTouch(_ sender: UIButton) {
        self.lastMonthBtn.isSelected = false
        self.lastYearBtn.isSelected = false
        sender.isSelected = true
    }
    
    @IBAction func lastMonthDidTOuch(_ sender: UIButton) {
        self.lastYearBtn.isSelected = false
        self.last7DaysBtn.isSelected = false
        sender.isSelected = true
    }
    @IBAction func lastYearDidTouch(_ sender: UIButton) {
        self.last7DaysBtn.isSelected = false
        self.lastMonthBtn.isSelected = false
        sender.isSelected = true
    }
}
