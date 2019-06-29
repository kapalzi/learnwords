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
        word?.languageSet?.startedLearning = true
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
        word?.languageSet?.startedLearning = true
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
    
    static func getWordsNextIndex(inContext context: NSManagedObjectContext) -> Int16? {
        
        let request: NSFetchRequest<Word> = NSFetchRequest()
        request .returnsObjectsAsFaults = false
        let entity = NSEntityDescription.entity(forEntityName: "Word", in: context)
        request.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "goodCounter", ascending: false)
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
            return Int16(results.count + 1)
        }
        return nil
    }
    
    static func editWord(newKnownLanguage: String, newLearningLanguage: String, forId wordIndex: Int16, inContext context: NSManagedObjectContext) {
        
        let wordToEdit = self.getWord(forIndex: wordIndex, inContext: context)
        wordToEdit.setValue(newKnownLanguage, forKey: "knownLanguage")
        wordToEdit.setValue(newLearningLanguage, forKey: "learningLanguage")
    }
    
    static func deleteWord(wordId: Int16, inContext context: NSManagedObjectContext) {
        let wordToDelete = self.getWord(forIndex: wordId, inContext: context)
        
        context.delete(wordToDelete)
    }
}
