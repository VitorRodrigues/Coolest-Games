//
//  GamesRepository.swift
//  coolergames
//
//  Created by Vitor Rodrigues on 2/15/18.
//  Copyright © 2018 Vitor Rodrigues. All rights reserved.
//

import UIKit
import CoreData

class GamesRepository: NSObject {
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "coolergames")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        self.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return self.persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    @discardableResult
    func saveContext(_ context: NSManagedObjectContext) -> Bool {
        if context.hasChanges {
            do {
                try context.save()
                print("Context saved for Database")
                return true
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        return false
    }
    
    func reset() {
        let context = backgroundContext
        guard let allGames = loadAllStoredGames(context: context) else { return }
        for game in allGames {
            context.delete(game)
        }
        saveContext(context)
    }
    
    // MARK: - Gaming related methods
    func storeAll(_ games: [Game], in context: NSManagedObjectContext) -> Bool {
        for game in games {
            let cdGame = gameEntity(with: game.identifier)
            cdGame.update(game)
        }
        return saveContext(context)
    }
    
    func store(_ game: Game, in context: NSManagedObjectContext) -> CDGame {
        let cdGame = gameEntity(with: game.identifier)
        cdGame.update(game)
        saveContext(context)
        return cdGame
    }
    
    /**
     Loads from Database or includes in it a new instance of `CDGame` objec
     */
    func gameEntity(with identifier: Int) -> CDGame {
        return loadGame(with: identifier) ?? NSEntityDescription.insertNewObject(forEntityName: "CDGame", into: context) as! CDGame
    }
    
    func loadGame(with identifier: Int) -> CDGame? {
        let request: NSFetchRequest<CDGame> = CDGame.fetchRequest()
        
        let predicate = NSPredicate(format: "identifier == %d", identifier)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            return results.first
        } catch let error as NSError {
            debugPrint("Error fetching: \(error)")
        }
        return nil
    }
    /**
     Returns a stored amount of games or `nil` of there's none
     */
    func loadStoredGames(limit: Int, offset: Int) -> [CDGame]? {
        let request: NSFetchRequest<CDGame> = CDGame.fetchRequest()
        
        let sortByPopularity = NSSortDescriptor(key: "popularity", ascending: false)
        request.sortDescriptors = [sortByPopularity]
        request.fetchLimit = limit
        request.fetchOffset = offset
        
        do {
            let results = try context.fetch(request)
            return results
        } catch let error as NSError {
            debugPrint("Error fetching: \(error)")
        }
        return nil
    }
    
    /**
     Returns a stored amount of games or `nil` of there's none
     */
    func loadAllStoredGames(context: NSManagedObjectContext) -> [CDGame]? {
        let request: NSFetchRequest<CDGame> = CDGame.fetchRequest()
        
        let sortByPopularity = NSSortDescriptor(key: "popularity", ascending: true)
        request.sortDescriptors = [sortByPopularity]
        
        do {
            let results = try context.fetch(request)
            return results
        } catch let error as NSError {
            debugPrint("Error fetching: \(error)")
        }
        return nil
    }
    
    
    
}
