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
    var yourLanguage: (name:String?, code:String?) = (name: nil, code: nil)
    var words: [Word]? = [Word]()
    var setCode: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.setName == nil {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            self.setCode = "mySetNr\(LanguageSet.countLanguageSets(inContext: context)!+1)"
            LanguageSet.addNewLanguageSet(name: "", depiction: "", code: self.setCode!, isUnlocked: true, identifier: "", isUserMade: true, learningLanguage: "", knownLanguage: "", learningLanguageName: "", knownLanguageName: "", context: context)
        }
    }
    
    override func viewWillLayoutSubviews() {   
        if self.setName == nil {
            self.navigationController?.navigationBar.topItem?.title = "New Set"
        } else {
            self.navigationController?.navigationBar.topItem?.title = "Edit Set"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
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
            
            if self.setName != nil {
                cell.bottomLabel.isHidden = false
                cell.bottomLabel.text = "Set's Name"
            }
        case 1:
            cell.mainButton.setTitle((self.setDepiction != nil) ? self.setDepiction : "Set Depiction", for: .normal)
            cell.mainButton.addTarget(self, action: #selector(setDepictionDidTouch), for: .touchUpInside)
            cell.mainButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            
            if self.setDepiction != nil {
                cell.bottomLabel.isHidden = false
                cell.bottomLabel.text = "Set's Depiction"
            }
        case 2:
            cell.mainButton.setTitle((self.learningLanguage.name != nil) ? self.learningLanguage.name : "Learning Language", for: .normal)
            cell.mainButton.addTarget(self, action: #selector(learningLanguageDidTouch), for: .touchUpInside)
            
            if self.learningLanguage.name != nil {
                cell.bottomLabel.isHidden = false
                cell.bottomLabel.text = "Learning Language"
            }
        case 3:
            cell.mainButton.setTitle((self.yourLanguage.name != nil) ? self.yourLanguage.name : "Your Language", for: .normal)
            cell.mainButton.addTarget(self, action: #selector(yourLanguageDidTouch), for: .touchUpInside)
            
            if self.yourLanguage.name != nil {
                cell.bottomLabel.isHidden = false
                cell.bottomLabel.text = "Your Language"
            }
        case 4:
            cell.mainButton.setTitle("Add Word", for: .normal)
            cell.mainButton.addTarget(self, action: #selector(addWordDidTouch), for: .touchUpInside)
        case 5:
            cell.mainButton.setTitle("Show Words", for: .normal)
            cell.mainButton.addTarget(self, action: #selector(showWordsDidTouch), for: .touchUpInside)
        case 6:
            cell.mainButton.setTitle("Save", for: .normal)
            cell.mainButton.addTarget(self, action: #selector(saveDidTouch), for: .touchUpInside)
        default:
            print("default")
        }
    }
    
    func showAlertWithTextField(withTitle title:String, text:String?, placeholder:String, action:@escaping (UITextField)->Void) {
        
        let alert = UIAlertController(style: .actionSheet, title: title)
        let config: TextField.Config = { textField in
            textField.becomeFirstResponder()
            textField.textColor = .black
            textField.placeholder = placeholder
            if let _ = text {
                textField.text = text
            }
            textField.leftViewPadding = 12
            textField.borderWidth = 1
            textField.cornerRadius = 8
            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
            textField.backgroundColor = nil
            textField.keyboardAppearance = .default
            textField.keyboardType = .default
            textField.returnKeyType = .done
            textField.action(closure: action)
        }
        alert.addOneTextField(configuration: config)
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }
    
    @objc func setNameDidTouch(){
        self.showAlertWithTextField(withTitle: "Set Name", text:self.setName, placeholder: "Enter Name") { (textField) in
            if textField.text != "" {
                self.setName = textField.text
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func setDepictionDidTouch(){
        self.showAlertWithTextField(withTitle: "Set Depiction", text:self.setDepiction, placeholder: "Enter depiction") { (textField) in
            if textField.text != "" {
                self.setDepiction = textField.text
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func learningLanguageDidTouch(){
        
        let alert = UIAlertController(style: .actionSheet, message: "Select Language")
        alert.addLocalePicker(type: .country) { info in
            self.learningLanguage.code = info?.code
            self.learningLanguage.name = info?.country
            self.tableView.reloadData()
        }
        alert.addAction(title: "Cancel", style: .cancel)
        alert.show()
        
    }
    
    @objc func yourLanguageDidTouch(){
        
        let alert = UIAlertController(style: .actionSheet, message: "Select Language")
        alert.addLocalePicker(type: .country) { info in
            self.yourLanguage.code = info?.code
            self.yourLanguage.name = info?.country
            self.tableView.reloadData()
        }
        alert.addAction(title: "Cancel", style: .cancel)
        alert.show()
        
    }
    
    @objc func addWordDidTouch(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "newWord") as! NewWordViewController
        vc.delegate = self
        vc.setCode = self.setCode
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func showWordsDidTouch(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "wordsList") as! WordsListViewController
        vc.words = self.words
        vc.delegate = self
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func saveDidTouch(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if self.setName != nil && self.setName != "" {
            if self.setDepiction != nil && self.setDepiction != "" {
                if self.learningLanguage.code != nil && self.learningLanguage.code != "" && self.learningLanguage.name != nil && self.learningLanguage.name != "" {
                    if self.yourLanguage.code != nil && self.yourLanguage.code != "" && self.yourLanguage.name != nil && self.yourLanguage.name != "" {
                        if let set = LanguageSet.getLanguageSet(forCode: self.setCode!, inContext: context) {
                            if Word.getWords(ForSet: set, inContext: context).count > 0 {
                                LanguageSet.editLanguageSet(
                                    newName: self.setName!,
                                    newDepiction: self.setDepiction!,
                                    newIdentifier: self.learningLanguage.code!,
                                    newKnownLanguage: self.yourLanguage.code!,
                                    newLearningLanguage: self.learningLanguage.code!,
                                    newKnownLanguageName: self.yourLanguage.name!,
                                    newLearningLanguageName: self.learningLanguage.name!,
                                    forCode: self.setCode!,
                                    inContext: context)
                                
                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                                let alert = UIAlertController(title: "Succesfully edited set!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                    self.navigationController?.popViewController(animated: true)
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            else {
                                self.showAlert(title: "No words were added!")
                                return
                            }
                        }
                    } else {
                        self.showAlert(title: "Your language is not set or is not supported!")
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
    }
    
    func showAlert(title: String, completion: (() -> Void)? = nil){
        let alert = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: completion)
    }
}

extension NewSetViewController: NewWordViewControllerDelegate {
    func didEditWord(sender: NewWordViewController) {
        
    }
    
    func didSaveWord(sender: NewWordViewController){
        self.words?.append(sender.newWord!)
//        self.editWords.append(sender.newWord)
    }
}

extension NewSetViewController: WordsListViewControllerDelegate {
    func didSaveWords(sender: WordsListViewController) {
        self.words? = sender.words!
    }
}
