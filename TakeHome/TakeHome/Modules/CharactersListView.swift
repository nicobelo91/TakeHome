//
//  CharactersListView.swift
//  TakeHome
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

import CoreData
import SwiftUI

struct CharactersListView: View {
    let characters: [TenthCharacter]
    var body: some View {
        Group {
            if characters.isEmpty {
                Text(Constants.emptyListMessage)
            } else {
                List(characters) { character in
                    HStack {
                        Text(character.character)
                        Spacer()
                        Text(character.order)
                    }
                }
            }
        }
    }
}

extension CharactersListView {
    private enum Constants {
        static let emptyListMessage = "Oops, looks like there's no data..."
    }
}
