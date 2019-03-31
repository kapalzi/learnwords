//
//  BaseSetViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 27/02/2019.
//  Copyright © 2019 kapala. All rights reserved.
//

import UIKit

class BaseSetViewController: UITableViewController {
    
    override func viewWillLayoutSubviews() {
        self.tableView.visibleCells.forEach {
            ($0 as! SetsCell).shadowView.dropShadow()
        }
    }
    
}
