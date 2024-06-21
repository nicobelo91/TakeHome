//
//  DevelopmentTests.swift
//  TakeHomeTests
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

import CoreData
import XCTest
@testable import TakeHome

@MainActor
class DevelopmentTests: BaseTestCase {
    func testSampleDataCreationWorks() throws {
        try dataController.createSampleData()
        
        XCTAssertEqual(dataController.count(for: TenthCharacter.fetchRequest()), 5, "There should be 5 sample characters")
        XCTAssertEqual(dataController.count(for: WordCounter.fetchRequest()), 6, "There should be 6 sample words")
    }
    
}
