//
//  PrimaryButton.swift
//  TakeHome
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

import SwiftUI

struct PrimaryButton: View {
    
    var text: String
    var color: Color
    var isDisabled: Bool
    var action: () -> Void
    
    init(_ text: String, color: Color = .blue, isDisabled: Bool, action: @escaping () -> Void) {
        self.text = text
        self.color = color
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: self.action) {
            ZStack {
                Capsule()
                    .frame(height: 48)
                    .foregroundColor(isDisabled ? .gray : color)
                Text(self.text)
                    .font(.body)
                    .foregroundColor(.white)
            }
        }
        
    }
}
