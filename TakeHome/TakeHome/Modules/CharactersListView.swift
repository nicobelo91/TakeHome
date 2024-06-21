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
        List(characters) { character in
            HStack {
                Text(character.character)
                Spacer()
                Text(character.order)
            }
        }
    }
}
