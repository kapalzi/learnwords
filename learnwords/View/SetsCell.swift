//
//  SetsCell.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 30/12/2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit

class SetsCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var depictionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
