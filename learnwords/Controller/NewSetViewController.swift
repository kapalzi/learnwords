//
//  NewSetViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 02/02/2019.
//  Copyright © 2019 kapala. All rights reserved.
//

import UIKit

class NewSetViewController: UITableViewController {
    
    var setName: String? = nil
    var setDepiction: String? = nil
    var learningLanguage: (name:String?, code:String?) = (name: nil, code: nil)
    var words: [(knownLanguage:String?, learningLanguage:String?)] = [(knownLanguage:String?, learningLanguage:String?)]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        self.tableView.visibleCells.forEach {
            ($0 as! NewSetCell).shadowView.dropShadow()
        }
         self.navigationController?.navigationBar.topItem?.title = "New Set"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NewSetCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellIdentifier) as! NewSetCell
        }
        
        self.configureCell(cell: cell as! NewSetCell, indexPath: indexPath)
        return cell!
    }
    
    private func configureCell(cell: NewSetCell, indexPath: IndexPath) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        cell.selectedBackgroundView = backgroundView
        switch indexPath.row {
        case 0:
            cell.mainButton.setTitle((self.setName != nil) ? self.setName : "Set Name", for: .normal)
            cell.mainButton.addTarget(self, action: #selector(setNameDidTouch), for: .touchUpInside)
        case 1:
            cell.mainButton.setTitle((self.setDepiction != nil) ? self.setDepiction : "Set Depiction", for: .normal)
            cell.mainButton.addTarget(self, action: #selector(setDepictionDidTouch), for: .touchUpInside)
            cell.mainButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        case 2:
            cell.mainButton.setTitle((self.learningLanguage.name != nil) ? self.learningLanguage.name : "Learning Language", for: .normal)
            cell.mainButton.addTarget(self, action: #selector(learningLanguageDidTouch), for: .touchUpInside)
        case 3:
            cell.mainButton.setTitle("Add Word", for: .normal)
            cell.mainButton.addTarget(self, action: #selector(addWordDidTouch), for: .touchUpInside)
        case 4:
            cell.mainButton.setTitle("Show Words", for: .normal)
            cell.mainButton.addTarget(self, action: #selector(showWordsDidTouch), for: .touchUpInside)
        case 5:
            cell.mainButton.setTitle("Save", for: .normal)
            cell.mainButton.addTarget(self, action: #selector(saveDidTouch), for: .touchUpInside)
        default:
            print("default")
        }
    }
    
    @objc func setNameDidTouch(){
        let alert = UIAlertController(style: .actionSheet, title: "New Set Name")
        let config: TextField.Config = { textField in
            textField.becomeFirstResponder()
            textField.textColor = .black
            textField.placeholder = "Enter name"
//            textField.left(image: image, color: .black)
            textField.leftViewPadding = 12
            textField.borderWidth = 1
            textField.cornerRadius = 8
            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
            textField.backgroundColor = nil
            textField.keyboardAppearance = .default
            textField.keyboardType = .default
            textField.returnKeyType = .done
            textField.action { textField in
                if textField.text != "" {
                    self.setName = textField.text
                    self.tableView.reloadData()
                }
                
            }
        }
        alert.addOneTextField(configuration: config)
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }
    
    @objc func setDepictionDidTouch(){
        let alert = UIAlertController(style: .actionSheet, title: "New Set Depiction")
        let config: TextField.Config = { textField in
            textField.becomeFirstResponder()
            textField.textColor = .black
            textField.placeholder = "Enter name"
            //            textField.left(image: image, color: .black)
            textField.leftViewPadding = 12
            textField.borderWidth = 1
            textField.cornerRadius = 8
            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
            textField.backgroundColor = nil
            textField.keyboardAppearance = .default
            textField.keyboardType = .default
            textField.returnKeyType = .done
            textField.action { textField in
                if textField.text != "" {
                    self.setDepiction = textField.text
                    self.tableView.reloadData()
                }
            }
        }
        alert.addOneTextField(configuration: config)
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }
    
    @objc func learningLanguageDidTouch(){
        
        let alert = UIAlertController(style: .actionSheet, message: "Select Country")
        alert.addLocalePicker(type: .country) { info in
            self.learningLanguage.code = info?.code
            self.learningLanguage.name = info?.country
            self.tableView.reloadData()
        }
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
        
    }
    
    @objc func addWordDidTouch(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "newWord") as! NewWordViewController
        vc.delegate = self
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func showWordsDidTouch(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "wordsList") as! WordsListViewController
        vc.words = self.words
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func saveDidTouch(){
        if self.setName != nil && self.setName != "" {
            if self.setDepiction != nil && self.setDepiction != "" {
                if self.learningLanguage.code != nil && self.learningLanguage.code != "" {
                    if self.words.count != 0 {
                        
                        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                        let code = "mySetNr\(LanguageSet.countLanguageSets(inContext: context)!+1)"
                        
                        LanguageSet.addNewLanguageSet(name: self.setName!, depiction: self.setDepiction!, code: code, isUnlocked: true, identifier: self.learningLanguage.code!,isUserMade: true, context: context)
                        
                        for word in words {
                            Word.addNewWord(id: Word.getWordsNextIndex(inContext: context)!, knownLanguage: word.knownLanguage, learningLanguage: word.learningLanguage, languageSetCode: code, context: context)
                        }
                        self.showAlert(title: "Succesfully added new set!")
                        
                    } else {
                        self.showAlert(title: "No words were added!")
                        return
                    }
                } else {
                    self.showAlert(title: "Learning language is not set!")
                    return
                }
            } else {
                self.showAlert(title: "Depiction is not set!")
                return
            }
        } else {
            self.showAlert(title: "Name is not set!")
            return
        }
        
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(title: String){
        let alert = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension NewSetViewController: NewWordViewControllerDelegate {
    func didSaveWord(sender: NewWordViewController){
        self.words.append(sender.newWord)
    }
}
