//
//  LoadingView.swift
//  TakeHome
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

import SwiftUI

/// Custom View that shows a ProgressView on top of the content when `isLoading` is true
struct LoadingView<T>: View where T: View {
    var isLoading: Bool
    var backgroundColor: Color
    var content: () -> T
    
    init(_ isLoading: Bool, backgroundColor: Color = .black, @ViewBuilder content: @escaping () -> T) {
        self.isLoading = isLoading
        self.content = content
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        ZStack {
            content()
            if isLoading {
                backgroundColor
                    .opacity(0.25)
                    .ignoresSafeArea()
                ProgressView()
                    .font(.title2)
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .cornerRadius(10)
                
            }
        }
    }
}

