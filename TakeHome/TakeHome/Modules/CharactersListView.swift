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
                Text("Oops, looks like there's no data...")
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
