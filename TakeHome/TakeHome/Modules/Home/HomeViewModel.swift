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
        
        @Published var characters = [TenthCharacter]()
        @Published var words = [WordCounter]()
        @Published var isLoading = false
        
        let dataController: DataController
        
        init(dataController: DataController) {
            self.dataController = dataController
            
            // Construct a fetch request to show all characters
            let charactersRequest: NSFetchRequest<TenthCharacter> = TenthCharacter.fetchRequest()
            charactersRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TenthCharacter.value, ascending: true)]
            charactersController = NSFetchedResultsController(
                fetchRequest: charactersRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            // Construct a fetch request to show all words
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
                characters = charactersController.fetchedObjects ?? []
                words = counterController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch initial data")
            }
            
        }
        
        func deleteAll() {
            dataController.deleteAll()
        }
        
        /// Fetches the content from Compass's about page
        func getAboutContent() {
            isLoading = true
            Task {
                do {
                    let url = URL(string: "https://www.compass.com/about/")!
                    let (data, response) = try await URLSession.shared.data(from: url)
                    
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw MyNetworkingError.invalidServerResponse
                    }
                    
                    let urlContent = String(data: data, encoding: .utf8)!
                    
                    try await fetchEveryTenthCharacter(from: urlContent)
                    try await fetchWordCount(from: urlContent)
                    isLoading = false
                } catch {
                    print(error)
                }
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newCharacters = controller.fetchedObjects as? [TenthCharacter] {
                characters = newCharacters
            }
            if let newWords = controller.fetchedObjects as? [WordCounter] {
                words = newWords
            }
        }
        
        /// Fetches every tenth character in `text` and saves it as a TenthCharacter entity
        private func fetchEveryTenthCharacter(from text: String) async throws {
            let viewContext = dataController.container.viewContext
            
            // Remove any whitespace from the text before converting it into an array
            let array = Array(text.filter({!$0.isWhitespace}).replacingOccurrences(of: " ", with: ""))
            
            // Convert the array into a dictionary to save the character order
            // as well as the character itself
            let dictionary = array.indexedDictionary.sorted(by: { $0.key < $1.key})
            
            // Fetch every tenth item from the dictionary,
            // starting with the 10th item
            for (index, item) in dictionary.stride(from: 10, by: 10) {
                let character = TenthCharacter(context: viewContext)
                character.text = String(item)
                character.value = Int64(index)
                
                dataController.save()
            }
        }
        
        /// Fetches all words from `text` and saves it as a WordCounter  entity
        private func fetchWordCount(from text: String) async throws {
            let viewContext = dataController.container.viewContext
            
            // Remove any whitespace from the text before converting it into an array
            let words = text.split(whereSeparator: \.isWhitespace)
            
            let mappedItems = words.map { ($0, 1) }
            // Converts the array into a dictionary containing the number of times
            // each word is repeated
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
    
    var t_characters: [TenthCharacter] { characters }
    var t_wordCount: [WordCounter] { words }
}

/// String used for testing purposes
let customText: String = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
"""
