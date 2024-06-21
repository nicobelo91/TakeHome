//
//  ListPreviewView.swift
//  TakeHome
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

import SwiftUI

struct ListPreviewView: View {
    var title: String
    var items: [Item]
    var viewMoreAction: () -> Void
    var body: some View {
        VStack(spacing: 8) {
            header
            Divider()
            listContent
            Divider()
            viewMoreButton
        }
        .padding(.vertical, 8)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.white)
                .shadow(radius: 3)
        }

        .padding()
    }
    
    private var header: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var listContent: some View {
        Group {
            if !items.isEmpty {
                VStack {
                    ForEach(items.prefix(3)) { item in
                        ListPreviewRow(item: item)
                    }
                }
            } else {
                VStack {
                    Image(systemName: "nosign")
                        .imageScale(.large)
                        .foregroundStyle(.gray)
                    Text("No items were found")
                        .foregroundStyle(.gray)
                }
                .padding(.vertical)
            }

        }
    }
    
    private var viewMoreButton: some View {
        Button(action: viewMoreAction, label: {
            HStack {
               Spacer()
               Text("View more")
               Spacer()
             }
             .contentShape(Rectangle())
        })
    }
}

extension ListPreviewView {
    struct Item: Identifiable {
        var id = UUID()
        var title: String
        var number: String
    }
}
