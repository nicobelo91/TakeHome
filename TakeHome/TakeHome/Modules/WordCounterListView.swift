//
//  WordCounterListView.swift
//  TakeHome
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

import SwiftUI

struct WordCounterListView: View {
    let words: [WordCounter]
    var body: some View {
        Group {
            if words.isEmpty {
                Text("Oops, looks like there's no data...")
            } else {
                List(words) { word in
                    HStack {
                        Text(word.word)
                        Spacer()
                        Text("\(word.wordCount)")
                    }
                }
            }
        }
    }
}
