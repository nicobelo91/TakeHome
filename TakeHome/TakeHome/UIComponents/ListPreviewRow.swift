//
//  ListPreviewRow.swift
//  TakeHome
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

import SwiftUI

struct ListPreviewRow: View {
    var item: ListPreviewView.Item
    var body: some View {
        HStack {
            Text(item.title)
            Spacer()
            Text(item.number)
        }
        .padding(.horizontal)
        
    }
}
