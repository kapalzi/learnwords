//
//  WordsListViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 03/02/2019.
//  Copyright © 2019 kapala. All rights reserved.
//

import UIKit

protocol WordsListViewControllerDelegate: AnyObject {
    func didSaveWords(sender: WordsListViewController)
}

class WordsListViewController: UITableViewController {
    
//    var words: [(knownLanguage:String?, learningLanguage:String?)] = [(knownLanguage:String?, learningLanguage:String?)]()
    var words: [Word]? = nil
    var editIndex = 0
    weak var delegate: WordsListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        self.navigationController?.navigationBar.topItem?.title = "Words List"
//        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveDidClick))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = words?.count {
            return count
        } else {
          return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "wordsListCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellIdentifier) as! WordsListTableViewCell
        }
        
        self.configureCell(cell: cell as! WordsListTableViewCell, indexPath: indexPath)
        return cell!
    }
    
    private func configureCell(cell: WordsListTableViewCell, indexPath: IndexPath) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        cell.selectedBackgroundView = backgroundView
        
        cell.leftCell.text = words![indexPath.row].knownLanguage
        cell.rightCell.text = words![indexPath.row].learningLanguage
    }
    
    @IBAction func editBtnTouchUpInside(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "newWord") as! NewWordViewController
        
        guard let cell = sender.superview?.superview as? WordsListTableViewCell else {
            return // or fatalError() or whatever
        }
        let indexPath = tableView.indexPath(for: cell)
        let word = self.words?[indexPath!.row]
        vc.learningLanguage = word?.learningLanguage
        vc.knownLanguage = word?.knownLanguage
        vc.isEditMode = true
        vc.delegate = self
        vc.wordId = word?.id
        self.editIndex = indexPath!.row
        self.navigationController?.show(vc, sender: nil)
    }
    @IBAction func deleteBtnTouchUpInside(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? WordsListTableViewCell else {
            return // or fatalError() or whatever
        }
        guard let index = self.tableView.indexPath(for: cell) else { return }
        
        guard let words = self.words else { return }
        let wordToDelete = words[index.row]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        Word.deleteWord(wordId: wordToDelete.id, inContext: context)
        self.words?.remove(at: index.row)
        self.tableView.reloadData()
    }
}
//https://stackoverflow.com/questions/24103069/add-swipe-to-delete-uitableviewcell
extension WordsListViewController: NewWordViewControllerDelegate {
    func didSaveWord(sender: NewWordViewController) {
        
    }
    
    func didEditWord(sender: NewWordViewController){
        self.words![self.editIndex] = sender.newWord!
    }
}
