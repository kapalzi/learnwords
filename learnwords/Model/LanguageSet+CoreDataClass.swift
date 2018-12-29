//
//  LanguageSet+CoreDataClass.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 20/11/2018.
//  Copyright © 2018 kapala. All rights reserved.
//
//

import Foundation
import CoreData

@objc(LanguageSet)
public class LanguageSet: NSManagedObject {

    static func addNewLanguageSet(name: String, code: String, isUnlocked: Bool, identifier: String, context: NSManagedObjectContext) {
        let newSet = NSEntityDescription.insertNewObject(forEntityName: "LanguageSet", into: context) as! LanguageSet
        
        newSet.name = name
        newSet.code = code
        newSet.isUnlocked = isUnlocked
        newSet.identifier = identifier
        
    }
    
    static func setLanguageSetAsSelected(code: String, context: NSManagedObjectContext) {
        let set = LanguageSet.getLanguageSet(forCode: code, inContext: context)
        LanguageSet.unsetLanguageSet(context: context)
        set?.isSelected = true
    }
    
    private static func unsetLanguageSet(context: NSManagedObjectContext) {
        let request: NSFetchRequest<LanguageSet> = NSFetchRequest()
        request .returnsObjectsAsFaults = false
        let entity = NSEntityDescription.entity(forEntityName: "LanguageSet", in: context)
        request.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "code", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "isSelected = %@", NSNumber(booleanLiteral: true))
        request.predicate = predicate
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unresolved error %@, %@", fetchError, fetchError.userInfo)
            abort()
        }
        
        if let results = fetchedResultController.fetchedObjects, results.count == 1 {
            results.first?.isSelected = false
        }
        return
    }
    
     static func getSelectedSet(context: NSManagedObjectContext) -> LanguageSet{
        let request: NSFetchRequest<LanguageSet> = NSFetchRequest()
        request .returnsObjectsAsFaults = false
        let entity = NSEntityDescription.entity(forEntityName: "LanguageSet", in: context)
        request.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "code", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "isSelected = %@", NSNumber(booleanLiteral: true))
        request.predicate = predicate
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unresolved error %@, %@", fetchError, fetchError.userInfo)
            abort()
        }
        
        if let results = fetchedResultController.fetchedObjects, results.count == 1 {
            return results.first!
        }
        return getLanguageSet(forCode: "germanenglishtop1000", inContext: context)!
    }
    
    static func getLanguageSet(forCode code:String, inContext context: NSManagedObjectContext) -> LanguageSet? {
        let request: NSFetchRequest<LanguageSet> = NSFetchRequest()
        request .returnsObjectsAsFaults = false
        let entity = NSEntityDescription.entity(forEntityName: "LanguageSet", in: context)
        request.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "code", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "code = %@", code)
        request.predicate = predicate
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unresolved error %@, %@", fetchError, fetchError.userInfo)
            abort()
        }
        
        if let results = fetchedResultController.fetchedObjects, results.count == 1 {
            return results.first!
        }
        return nil
    }
    
    static func getAllLanguageSets(inContext context: NSManagedObjectContext) -> [LanguageSet]? {
        let request: NSFetchRequest<LanguageSet> = NSFetchRequest()
        request .returnsObjectsAsFaults = false
        let entity = NSEntityDescription.entity(forEntityName: "LanguageSet", in: context)
        request.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "code", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unresolved error %@, %@", fetchError, fetchError.userInfo)
            abort()
        }
        
        if let results = fetchedResultController.fetchedObjects{
            return results
        }
        return nil
    }
}
