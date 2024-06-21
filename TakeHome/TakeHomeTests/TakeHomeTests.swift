//
//  TakeHomeTests.swift
//  TakeHomeTests
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

import CoreData
import XCTest
@testable import TakeHome

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
