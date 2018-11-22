//
//  NewWordCell.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 30.03.2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class NewWordCell: UITableViewCell {
    
//    var titleLabel: UILabel!
//    var valueField: UITextField!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        valueField.borderStyle = UITextBorderStyle.none
        valueField.textAlignment = NSTextAlignment.right
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        valueField.font = titleLabel.font
    }
}
