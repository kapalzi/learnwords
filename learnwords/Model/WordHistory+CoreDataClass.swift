//
//  WordHistory+CoreDataClass.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 20/03/2019.
//  Copyright © 2019 kapala. All rights reserved.
//
//

import Foundation
import CoreData

@objc(WordHistory)
public class WordHistory: NSManagedObject {

    private static func addNewWordHistory(context: NSManagedObjectContext) {
        let newWordHistory = NSEntityDescription.insertNewObject(forEntityName: "WordHistory", into: context) as! WordHistory
        newWordHistory.date = Calendar.current.startOfDay(for: Date())
        newWordHistory.mastered = 0
        newWordHistory.remembered = 0
    }
    
    static func getWordHistory(forDate date:Date, inContext context: NSManagedObjectContext) -> WordHistory? {
        
        let request: NSFetchRequest<WordHistory> = NSFetchRequest()
        request .returnsObjectsAsFaults = false
        let entity = NSEntityDescription.entity(forEntityName: "WordHistory", in: context)
        request.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "mastered", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "date = %@", date as NSDate)
        request.predicate = predicate
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unresolved error %@, %@", fetchError, fetchError.userInfo)
            abort()
        }
        
        return fetchedResultController.fetchedObjects!.first
    }
    
    static func addOneRememberedForToday(inContext context: NSManagedObjectContext) {
        if let wordHistory = self.getWordHistory(forDate: Calendar.current.startOfDay(for: Date()), inContext: context) {
            wordHistory.remembered = wordHistory.remembered + 1
        } else {
            self.addNewWordHistory(context: context)
            self.addOneRememberedForToday(inContext: context)
        }
    }
    
    static func addOneMasteredForToday(inContext context: NSManagedObjectContext) {
        if let wordHistory = self.getWordHistory(forDate: Calendar.current.startOfDay(for: Date()), inContext: context) {
            wordHistory.mastered = wordHistory.mastered + 1
        } else {
            self.addNewWordHistory(context: context)
            self.addOneMasteredForToday(inContext: context)
        }
    }
    
    static func getRememberedCount(forNumberOfDays numberOfDays: Int, inContext context: NSManagedObjectContext) -> [Double] {
        var counts = [Double]()
        var dates = [Date]()
        
        let startDate = Date()
        for i in 0...numberOfDays-1 {
            let nextDate = Calendar.current.date(byAdding: .day, value: -i, to: startDate)
            let comp: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: nextDate!)
            
            let truncated = Calendar.current.date(from: comp)!
            dates.append(truncated)
        }
        for date in dates.reversed() {
            if let wordHistory = WordHistory.getWordHistory(forDate: date, inContext: context){
                counts.append(Double(wordHistory.remembered))
            } else {
                counts.append(0)
            }
        }
        return counts
    }
    
}
