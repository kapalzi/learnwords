//
//  BaseTableViewCell.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 19/07/2019.
//  Copyright © 2019 kapala. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        self.selectedBackgroundView = backgroundView
        self.shadowView.dropShadow()
    }

}
