//
//  SecondaryButton.swift
//  TakeHome
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

import SwiftUI

struct SecondaryButton: View {
    
    var text: String
    var color: Color
    var action: () -> Void
    
    init(_ text: String, color: Color = .blue, action: @escaping () -> Void) {
        self.text = text
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: self.action) {
            ZStack {
                Capsule()
                    .stroke()
                    .frame(height: 48)
                    .foregroundColor(color)
                Text(self.text)
                    .font(.body)
                    .foregroundColor(color)
            }
        }
        
    }
}
