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

    static func addNewLanguageSet(name: String, depiction: String, code: String, isUnlocked: Bool, identifier: String, isUserMade: Bool, learningLanguage: String, knownLanguage: String, context: NSManagedObjectContext) {
        let newSet = NSEntityDescription.insertNewObject(forEntityName: "LanguageSet", into: context) as! LanguageSet
        
        newSet.name = name
        newSet.code = code
        newSet.isUnlocked = isUnlocked
        newSet.identifier = identifier
        newSet.depiction = depiction
        newSet.isUserMade = isUserMade
        newSet.learningLanguage = learningLanguage
        newSet.knownLanguage = knownLanguage
        
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
    
    static func editLanguageSet(newName: String, newDepiction: String, newIdentifier: String, newKnownLanguage: String, newLearningLanguage: String, forCode code:String, inContext context: NSManagedObjectContext) {
        
        let setToEdit = getLanguageSet(forCode: code, inContext: context)
        setToEdit?.setValue(newName, forKey: "name")
        setToEdit?.setValue(newDepiction, forKey: "depiction")
        setToEdit?.setValue(newIdentifier, forKey: "identifier")
        setToEdit?.setValue(newKnownLanguage, forKey: "knownLanguage")
        setToEdit?.setValue(newLearningLanguage, forKey: "learningLanguage")
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
    
    static func getAllLanguageSets(forKnownLanguage knownLanguage: String, inContext context: NSManagedObjectContext) -> [LanguageSet]? {
        let request: NSFetchRequest<LanguageSet> = NSFetchRequest()
        request .returnsObjectsAsFaults = false
        let entity = NSEntityDescription.entity(forEntityName: "LanguageSet", in: context)
        request.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "code", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "knownLanguage = %@", knownLanguage)
        request.predicate = predicate
        
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
    
    static func getAllLanguageSets(forKnownLanguage knownLanguage: String, forLearningLanguage learningLanguage: String, inContext context: NSManagedObjectContext) -> [LanguageSet]? {
        let request: NSFetchRequest<LanguageSet> = NSFetchRequest()
        request .returnsObjectsAsFaults = false
        let entity = NSEntityDescription.entity(forEntityName: "LanguageSet", in: context)
        request.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "code", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "knownLanguage = %@ AND learningLanguage = %@", knownLanguage, learningLanguage)
        request.predicate = predicate
        
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
    
    static func getUsedLanguageSets(inContext context: NSManagedObjectContext) -> [LanguageSet]? {
        let request: NSFetchRequest<LanguageSet> = NSFetchRequest()
        request .returnsObjectsAsFaults = false
        let entity = NSEntityDescription.entity(forEntityName: "LanguageSet", in: context)
        request.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "code", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "startedLearning = YES")
        request.predicate = predicate
        
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
    
    static func countLanguageSets(inContext context: NSManagedObjectContext) -> Int? {
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
            return results.count
        }
        return nil
    }
    
    static func getKnownLanguages(inContext context: NSManagedObjectContext) -> [(code: String, name: String)]? {
       
        if let sets = LanguageSet.getAllLanguageSets(inContext: context) {
            var knownLanguages = sets.map{
                $0.knownLanguage ?? ""
            }
            
            knownLanguages = Array(Set(knownLanguages))
            
            var returnArray = [(code: String, name: String)]()
            
            knownLanguages.forEach { (languageCode) in
                let locale = NSLocale(localeIdentifier: languageCode)
                let current = NSLocale.autoupdatingCurrent
                
                let currentLocale = NSLocale(localeIdentifier: current.identifier)
                
                if let countrName = currentLocale.displayName(forKey: NSLocale.Key.identifier, value: locale.localeIdentifier) {
                    returnArray.append((code: languageCode, name: countrName))
                }
            }
            return returnArray
        }
        return nil
    }
    
    static func getLearningLanguages(forSelectedKnownLanguage knownLanguageCode: String, inContext context: NSManagedObjectContext) -> [(code: String, name: String)]? {
        if let sets = LanguageSet.getAllLanguageSets(forKnownLanguage: knownLanguageCode, inContext: context) {
            var learningLanguages = sets.map{
                $0.learningLanguage ?? ""
            }
            
            learningLanguages = Array(Set(learningLanguages))
            
            var returnArray = [(code: String, name: String)]()
            
            learningLanguages.forEach { (languageCode) in
                let locale = NSLocale(localeIdentifier: languageCode)
                let current = NSLocale.current
                
                let currentLocale = NSLocale(localeIdentifier: current.languageCode!)
                
                if let countrName = currentLocale.displayName(forKey: NSLocale.Key.identifier, value: locale.localeIdentifier) {
                    returnArray.append((code: languageCode, name: countrName))
                }
            }
            return returnArray
        }
        return nil
    }
        
}
