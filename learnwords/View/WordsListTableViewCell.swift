//
//  WordsListTableViewCell.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 03/02/2019.
//  Copyright © 2019 kapala. All rights reserved.
//

import UIKit

class WordsListTableViewCell: UITableViewCell {

    @IBOutlet weak var leftCell: UILabel!
    @IBOutlet weak var rightCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
