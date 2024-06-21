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
    @State private var showDeleteAlert = false
    
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        LoadingView(viewModel.isLoading) {
            NavigationStack(path: $path) {
                VStack {
                    contentView
                    Spacer()
                    buttonsView
                }
                .navigationTitle(Constants.navigationTitle)
                .padding()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .characterList:
                        CharactersListView(characters: viewModel.characters)
                    case .wordCounterList:
                        WordCounterListView(words: viewModel.words)
                    }
                }
            }
        }
    }
    
    private var contentView: some View {
        VStack {
            ListPreviewView(
                title: Constants.charactersTitle,
                items: charactersToItems,
                viewMoreAction: { path.append(.characterList) }
            )
            ListPreviewView(
                title: Constants.wordsTitle,
                items: wordCounterToItems,
                viewMoreAction: { path.append(.wordCounterList) }
            )
        }
    }
    
    private var buttonsView: some View {
        VStack(spacing: 10) {
            PrimaryButton(Constants.buttonTitle, isDisabled: isButtonDisabled) {
                viewModel.getAboutContent()
            }
            .disabled(isButtonDisabled)
            
            Button(action: { showDeleteAlert = true }, label: {
                Text(Constants.deleteButtonTitle)
                    .tint(.red)
            })
            .alert(Constants.deleteButtonMessage, isPresented: $showDeleteAlert) {
                        Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) { viewModel.deleteAll()}
                    }
        }
    }
    
    private var isButtonDisabled: Bool {
        !viewModel.characters.isEmpty || !viewModel.words.isEmpty
    }
    /// Converts the array of viewModel.tenthCharacter into a list of items that will fit in ListPreviewView
    private var charactersToItems: [ListPreviewView.Item] {
        viewModel.characters.map { ListPreviewView.Item(title: $0.character, number: $0.order)}
    }
    
    /// Converts the array of viewModel.wordCounter into a list of items that will fit in ListPreviewView
    private var wordCounterToItems: [ListPreviewView.Item] {
        viewModel.words.map { ListPreviewView.Item(title: $0.word, number: "\($0.wordCount)")}
    }
}

extension HomeView {
    private enum Constants {
        static let navigationTitle = "Concurrent API Calls"
        static let charactersTitle = "Every10thCharacterRequest"
        static let wordsTitle = "WordCounterRequest"
        static let buttonTitle = "Fetch Data"
        static let deleteButtonTitle = "Delete All"
        static let deleteButtonMessage = "Are you sure you want to delete your data?"
    }
}
