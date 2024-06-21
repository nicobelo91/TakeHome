//
//  HomeViewModelTests.swift
//  TakeHomeTests
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

import XCTest
import CoreData
@testable import TakeHome

@MainActor
class HomeViewModelTests: BaseTestCase {

    func testCreatingLists() {
        let targetCount = 10
        
        for _ in 0..<targetCount {
            let character = TenthCharacter(context: managedObjectContext)
            
        }
        
        for _ in 0..<targetCount {
            let word = WordCounter(context: managedObjectContext)
        }
        
        XCTAssertEqual(dataController.count(for: TenthCharacter.fetchRequest()), targetCount)
        XCTAssertEqual(dataController.count(for: WordCounter.fetchRequest()), targetCount)
    }
    
    func testFetchWordCount() async throws {
        let sut = makeSUT()
        try await sut.t_fetchWordCount()

        XCTAssertFalse(sut.t_wordCount.isEmpty)

    }
    
    func testFetchEveryTenthCharacter() async throws {
        let sut = makeSUT()
        try await sut.t_fetchEveryTenthCharacter()

        XCTAssertFalse(sut.t_characters.isEmpty)

    }

    private func makeSUT() -> HomeView.ViewModel {
        return HomeView.ViewModel(dataController: dataController)
    }
}
