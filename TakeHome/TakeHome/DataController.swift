//
//  DataController.swift
//  TakeHome
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

import CoreData
import SwiftUI


/// An Environment singleton responsible for managing our CoreData stack, including handling saving
/// counting fetch requests, tracking awards, and dealing with sample data.
class DataController: ObservableObject {
    
    /// The lone CloudKit container used to store all our data.
    let container: NSPersistentCloudKitContainer
    
    
    /// Initializes a data controller, either in memory (for temporary use such as testing and previewing),
    /// or on permanent storage (for use in regular app runs).
    ///
    /// Defaults to permanent storage
    /// - Parameter inMemory: Whether to store this data in temporary memory or not.
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Database")
        
        // For testing and previewing purposes, we create a temporary
        // in memory database by writing to /dev/null so our data is
        // destroyed after the app finishes running.
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
            
            
        }
    }
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }
        
        return dataController
    }()
    
    /// Creates example projects and items to make testing easier.
    ///  - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData() throws {
        let viewContext = container.viewContext
        
        for i in 1...5 {
            let character = TenthCharacter(context: viewContext)
            character.text = "Character \(i)"
            character.value = Int64(i)
        }
        
        for j in 1...6 {
            let wordCounter = WordCounter(context: viewContext)
            wordCounter.text = "Word \(j)"
            wordCounter.count = Int64(j)
        }
        
        try viewContext.save()
    }
    
    /// Saves our CoreData context if there are changes. This silently ignores
    /// any errors caused by saving. This should be fine because our
    /// attributes are optional.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func deleteAll() {
        let viewContext = container.viewContext
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = TenthCharacter.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = WordCounter.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }
    
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
}
