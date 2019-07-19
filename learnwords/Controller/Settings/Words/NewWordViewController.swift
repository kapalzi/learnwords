//
//  NewWordViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 30.03.2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit
import CoreData

protocol NewWordViewControllerDelegate: AnyObject {
    func didSaveWord(sender: NewWordViewController)
    func didEditWord(sender: NewWordViewController)
}

class NewWordViewController: UITableViewController {
    
    var knownLanguage: String? = nil
    var learningLanguage: String? = nil
    var newWord: Word? = nil
    weak var delegate: NewWordViewControllerDelegate?
    var isEditMode: Bool = false
    var setCode: String?
    var wordId: Int16?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        self.navigationController?.navigationBar.topItem?.title = "New Word"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
            cell.mainButton.setTitle((self.knownLanguage != nil) ? self.knownLanguage : "Word in known language", for: .normal)
            cell.mainButton.addTarget(self, action: #selector(setKnownDidTouch), for: .touchUpInside)
        case 1:
            cell.mainButton.setTitle((self.learningLanguage != nil) ? self.learningLanguage : "Word in learning language", for: .normal)
            cell.mainButton.addTarget(self, action: #selector(setLearningDidTouch), for: .touchUpInside)
            cell.mainButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        case 2:
            cell.mainButton.setTitle("Save", for: .normal)
            cell.mainButton.addTarget(self, action: #selector(saveDidTouch), for: .touchUpInside)
        default:
            print("default")
        }
    }
    
    @objc func setKnownDidTouch(){
        let alert = UIAlertController(style: .actionSheet, title: "Word in known language")
        let config: TextField.Config = { textField in
            textField.becomeFirstResponder()
            textField.textColor = .black
            textField.text = (self.knownLanguage != nil) ? self.knownLanguage : ""
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
                    self.knownLanguage = textField.text
                    self.tableView.reloadData()
                }
                
            }
        }
        alert.addOneTextField(configuration: config)
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }
    
    @objc func setLearningDidTouch(){
        let alert = UIAlertController(style: .actionSheet, title: "Word in learning language")
        let config: TextField.Config = { textField in
            textField.becomeFirstResponder()
            textField.textColor = .black
            textField.text = (self.learningLanguage != nil) ? self.learningLanguage : ""
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
                    self.learningLanguage = textField.text
                    self.tableView.reloadData()
                }
            }
        }
        alert.addOneTextField(configuration: config)
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }
    
    @objc func saveDidTouch(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if self.knownLanguage != nil && self.knownLanguage != "" {
            if self.learningLanguage != nil && self.learningLanguage != "" {
                let entityDescription = NSEntityDescription.entity(forEntityName: "Word", in: context)
                
                
                if self.isEditMode {
                    Word.editWord(
                        newKnownLanguage: self.knownLanguage!,
                        newLearningLanguage: self.learningLanguage!,
                        forId: self.wordId!,
                        inContext: context)
                } else {
                    if let code = self.setCode {
                        Word.addNewWord(
                            id: Word.getWordsNextIndex(inContext: context)!,
                            knownLanguage: self.knownLanguage,
                            learningLanguage: self.learningLanguage,
                            languageSetCode: code,
                            context: context)
                    }
                }
                
                self.newWord = Word(entity: entityDescription!, insertInto: nil)
                self.newWord?.learningLanguage = self.learningLanguage
                self.newWord?.knownLanguage = self.knownLanguage
            } else {
                self.showAlert(title: "Learning language is not set!")
                return
            }
        } else {
            self.showAlert(title: "Known language is not set!")
            return
        }
        
        if  self.isEditMode {
            delegate?.didEditWord(sender: self)
            self.navigationController?.popViewController(animated: true)
            return
        }
        delegate?.didSaveWord(sender: self)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(title: String){
        let alert = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

}
