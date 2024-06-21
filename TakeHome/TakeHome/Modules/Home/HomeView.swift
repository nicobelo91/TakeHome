//
//  HomeView.swift
//  TakeHome
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

import SwiftUI

struct HomeView: View {
    enum Route {
        case characterList
        case wordCounterList
    }
    
    @EnvironmentObject var dataController: DataController
    @StateObject var viewModel: ViewModel
    @State private var path: [Route] = []
    
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        LoadingView(viewModel.isLoading) {
            NavigationStack(path: $path) {
                VStack {
                    ListPreviewView(
                        title: "Every10thCharacterRequest",
                        items: charactersToItems,
                        viewMoreAction: { path.append(.characterList) }
                    )
                    ListPreviewView(
                        title: "WordCounterRequest",
                        items: wordCounterToItems,
                        viewMoreAction: { path.append(.wordCounterList) }
                    )
                    Spacer()
                    PrimaryButton("Make Call") {
                        //viewModel.addSampleData()
                        viewModel.getAboutContent()
                    }
                    .disabled(!viewModel.tenthCharacter.isEmpty || !viewModel.wordCounter.isEmpty)
                    SecondaryButton("Delete Data", color: .red) {
                        viewModel.deleteAllData()
                    }
                }
                .navigationTitle("Concurrent API Calls")
                .padding()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .characterList:
                        CharactersListView(characters: viewModel.tenthCharacter)
                    case .wordCounterList:
                        WordCounterListView(words: viewModel.wordCounter)
                    }
                }
            }
        }
    }
    
    private var charactersToItems: [ListPreviewView.Item] {
        viewModel.tenthCharacter.map { ListPreviewView.Item(title: $0.character, number: $0.order)}
    }
    
    private var wordCounterToItems: [ListPreviewView.Item] {
        viewModel.wordCounter.map { ListPreviewView.Item(title: $0.word, number: "\($0.wordCount)")}
    }
}
