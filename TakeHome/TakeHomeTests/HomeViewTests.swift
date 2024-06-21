//
//  HomeViewTests.swift
//  TakeHomeTests
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

@testable import TakeHome
import XCTest

@MainActor
final class HomeViewTests: XCTestCase {
    private var sut: HomeView!

    override func setUpWithError() throws {
        sut = makeSUT()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testViewBodyIsValid() {
        XCTAssertNotNil(sut.body)
    }

    private func makeSUT() -> HomeView {
        return HomeView(dataController: DataController())
    }

}
