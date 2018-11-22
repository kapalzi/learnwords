//
//  Word+CoreDataClass.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 20/11/2018.
//  Copyright © 2018 kapala. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Word)
public class Word: NSManagedObject {

    static func addNewWord(id: Int16, knownLanguage: String?, learningLanguage: String?, languageSetCode: String, context: NSManagedObjectContext) {
        
        guard let languageSet = LanguageSet.getLanguageSet(forCode: languageSetCode, inContext: context) else { return }
        
        let newWord = NSEntityDescription.insertNewObject(forEntityName: "Word", into: context) as! Word
        
        newWord.id = id
        newWord.badCounter = 0
        newWord.goodCounter = 0
        newWord.knownLanguage = knownLanguage
        newWord.learningLanguage = learningLanguage
        newWord.languageSet = languageSet
    }
    
    static func addGoodAnwer(wordId: Int16, context: NSManagedObjectContext) {
        let request: NSFetchRequest<Word> = NSFetchRequest()
        request .returnsObjectsAsFaults = false
        let entity = NSEntityDescription.entity(forEntityName: "Word", in: context)
        request.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "id = %d", wordId)
        request.predicate = predicate
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unresolved error %@, %@", fetchError, fetchError.userInfo)
            abort()
        }
        
         let word = fetchedResultController.fetchedObjects!.first
        word?.goodCounter = (word?.goodCounter)!+1
    }
    
    static func addBadAnwer(wordId: Int16, context: NSManagedObjectContext) {
        let request: NSFetchRequest<Word> = NSFetchRequest()
        request .returnsObjectsAsFaults = false
        let entity = NSEntityDescription.entity(forEntityName: "Word", in: context)
        request.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "id = %d", wordId)
        request.predicate = predicate
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unresolved error %@, %@", fetchError, fetchError.userInfo)
            abort()
        }
        
        let word = fetchedResultController.fetchedObjects!.first
        word?.badCounter = (word?.badCounter)!+1
    }

    static func getWordsForSelectedSet(inContext context: NSManagedObjectContext) -> [Word] {
        
        let set = LanguageSet.getSelectedSet(context: context)
        let request: NSFetchRequest<Word> = NSFetchRequest()
        request .returnsObjectsAsFaults = false
        let entity = NSEntityDescription.entity(forEntityName: "Word", in: context)
        request.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "languageSet = %@ AND goodCounter < %d", set, UserDefaults.standard.integer(forKey: "answersToMaster"))
        request.predicate = predicate
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unresolved error %@, %@", fetchError, fetchError.userInfo)
            abort()
        }
    
         return fetchedResultController.fetchedObjects!
        
    }
    
    static func getWords(ForSet set:LanguageSet, inContext context: NSManagedObjectContext) -> [Word] {
        
        let request: NSFetchRequest<Word> = NSFetchRequest()
        request .returnsObjectsAsFaults = false
        let entity = NSEntityDescription.entity(forEntityName: "Word", in: context)
        request.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "goodCounter", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "languageSet = %@", set)
        request.predicate = predicate
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unresolved error %@, %@", fetchError, fetchError.userInfo)
            abort()
        }
        
        return fetchedResultController.fetchedObjects!
        
    }
    
    static func getWord(forIndex index:Int16, inContext context: NSManagedObjectContext) -> Word {
        
        let request: NSFetchRequest<Word> = NSFetchRequest()
        request .returnsObjectsAsFaults = false
        let entity = NSEntityDescription.entity(forEntityName: "Word", in: context)
        request.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "goodCounter", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "id = %d", index)
        request.predicate = predicate
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unresolved error %@, %@", fetchError, fetchError.userInfo)
            abort()
        }
        
        return fetchedResultController.fetchedObjects!.first!
        
    }
}
