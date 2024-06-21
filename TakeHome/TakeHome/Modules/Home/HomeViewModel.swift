//
//  HomeViewModel.swift
//  TakeHome
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

import CoreData
import Foundation

enum MyNetworkingError: Error {
    case invalidServerResponse
}

extension HomeView {
    @MainActor
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let charactersController: NSFetchedResultsController<TenthCharacter>
        private let counterController: NSFetchedResultsController<WordCounter>
        
        @Published var tenthCharacter = [TenthCharacter]()
        @Published var wordCounter = [WordCounter]()
        @Published var isLoading = false
        
        let dataController: DataController
        
        init(dataController: DataController) {
            self.dataController = dataController
            
            // Construct a fetch request to show all open projects
            let charactersRequest: NSFetchRequest<TenthCharacter> = TenthCharacter.fetchRequest()
            charactersRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TenthCharacter.value, ascending: true)]
            charactersController = NSFetchedResultsController(
                fetchRequest: charactersRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            let counterRequest: NSFetchRequest<WordCounter> = WordCounter.fetchRequest()
            counterRequest.sortDescriptors = [NSSortDescriptor(keyPath: \WordCounter.count, ascending: false)]
            counterController = NSFetchedResultsController(
                fetchRequest: counterRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            super.init()
            charactersController.delegate = self
            counterController.delegate = self
            
            do {
                try charactersController.performFetch()
                try counterController.performFetch()
                tenthCharacter = charactersController.fetchedObjects ?? []
                wordCounter = counterController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch initial data")
            }
            
        }
        
        func getAboutContent() {
            isLoading = true
            Task {
                do {
                    let url = URL(string: "https://www.compass.com/about/")!
                    let (data, response) = try await URLSession.shared.data(from: url)
                    
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw MyNetworkingError.invalidServerResponse
                    }
                    
                    //let urlContent = String(data: data, encoding: .utf8)!
                    
                    try await fetchEveryTenthCharacter(from: customText)
                    try await fetchWordCount(from: customText)
                    isLoading = false
                } catch {
                    print(error)
                }
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newCharacters = controller.fetchedObjects as? [TenthCharacter] {
                tenthCharacter = newCharacters
            } else if let newWords = controller.fetchedObjects as? [WordCounter] {
                wordCounter = newWords
            }
        }
        
        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }
        
        func deleteAllData() {
            dataController.deleteAll()
        }
        
        
        private func fetchEveryTenthCharacter(from text: String) async throws {
            let viewContext = dataController.container.viewContext
            
            let array = Array(text.replacingOccurrences(of: " ", with: ""))
            
            let dictionary = array.indexedDictionary.sorted(by: { $0.key < $1.key})
            //let nth = array.every(from: 9, nth: 10)
            
            for (index, item) in dictionary.stride(from: 10, by: 10) {
                let character = TenthCharacter(context: viewContext)
                character.text = String(item)
                character.value = Int64(index)
                
                dataController.save()
            }
        }
        
        private func fetchWordCount(from text: String) async throws {
            let viewContext = dataController.container.viewContext
            
            let words = text.split(whereSeparator: \.isLetter.negation)
            
            let mappedItems = words.map { ($0, 1) }
            let counts = Dictionary(mappedItems, uniquingKeysWith: +)
            
            for (item, index) in counts {
                let wordCounter = WordCounter(context: viewContext)
                wordCounter.text = String(item)
                wordCounter.count = Int64(index)
                
                dataController.save()
            }
            
        }
    }
}

// MARK: - Unit Tests Helpers

extension HomeView.ViewModel {
    func t_getAboutContent() { getAboutContent() }
    func t_fetchEveryTenthCharacter() async throws { try await fetchEveryTenthCharacter(from: customText) }
    func t_fetchWordCount() async throws { try await fetchWordCount(from: customText) }
    
    var t_characters: [TenthCharacter] { tenthCharacter }
    var t_wordCount: [WordCounter] { wordCounter }
}

let customText: String = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
"""
