//
//  WordsListViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 03/02/2019.
//  Copyright © 2019 kapala. All rights reserved.
//

import UIKit

class WordsListViewController: UITableViewController {
    
    var words: [(knownLanguage:String?, learningLanguage:String?)] = [(knownLanguage:String?, learningLanguage:String?)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        self.navigationController?.navigationBar.topItem?.title = "Words List"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
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
        
        cell.leftCell.text = words[indexPath.row].knownLanguage
        cell.rightCell.text = words[indexPath.row].learningLanguage
    }
    
}
//https://stackoverflow.com/questions/24103069/add-swipe-to-delete-uitableviewcell