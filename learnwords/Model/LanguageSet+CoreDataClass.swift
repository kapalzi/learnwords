//
//  LanguageSet+CoreDataClass.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 03.10.2018.
//  Copyright © 2018 kapala. All rights reserved.
//
//

import Foundation
import CoreData

@objc(LanguageSet)
public class LanguageSet: NSManagedObject {

    static func getLanguageSets(context: NSManagedObjectContext) -> [LanguageSet]? {
        let request: NSFetchRequest<LanguageSet> = NSFetchRequest()
        request.returnsObjectsAsFaults = false
        let entity = NSEntityDescription.entity(forEntityName: "LanguageSet", in: context)
        return nil
    }
    
}
