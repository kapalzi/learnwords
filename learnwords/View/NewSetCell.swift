//
//  NewSetCell.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 02/02/2019.
//  Copyright © 2019 kapala. All rights reserved.
//

import UIKit

class NewSetCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
