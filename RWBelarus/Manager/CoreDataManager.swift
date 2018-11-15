//
//  CoreDataManager.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/15/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static func shared() -> CoreDataManager {
        if self.sharedInstance == nil {
            self.sharedInstance = CoreDataManager()
        }
        return self.sharedInstance!
    }
    
    private static var sharedInstance: CoreDataManager?
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: "DataModel", withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let fileManager = FileManager.default
        let storeName = "DataModel.sqlite"
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    fileprivate func save(managedContext: NSManagedObjectContext) {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension CoreDataManager {
    
    func saveRouteWith(from: AutocompleteAPIElement, to: AutocompleteAPIElement) {
        let managedContext = CoreDataManager.shared().managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "RouteCoreData",
                                                in: managedContext)!
        
        let route = RouteCoreData(entity: entity, insertInto: managedContext)
        route.fromExp = from.exp
        route.valueFrom = from.value
        route.labelFrom = from.label
        
        route.labelTo = to.label
        route.toExp = to.exp
        route.valueTo = to.value
        
        if let from = route.labelFrom, let to = route.labelTo, let fromValue = route.valueFrom, let toValue = route.valueTo {
            route.fromTo = "\(from),\(to)"
            route.routeName = "\(fromValue) - \(toValue)"
        }
        
        self.save(managedContext: managedContext)
    }
    
    func loadRoute() -> [RouteCoreData] {
        let managedContext = CoreDataManager.shared().managedObjectContext
        let fetchRequest = NSFetchRequest<RouteCoreData>(entityName: "RouteCoreData")
        var fetchResult = [RouteCoreData]()
        do {
            fetchResult = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return fetchResult
    }
}
