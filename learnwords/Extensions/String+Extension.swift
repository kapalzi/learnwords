//
//  String+Extension.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 31/03/2019.
//  Copyright © 2019 kapala. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
