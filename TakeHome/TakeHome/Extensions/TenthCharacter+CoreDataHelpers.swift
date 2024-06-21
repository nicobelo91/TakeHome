//
//  TenthCharacter+CoreDataHelpers.swift
//  TakeHome
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

import Foundation

extension TenthCharacter {
    var character: String {
        text ?? "-"
    }
    
    var order: String {
        return "\(value)th"
    }
}
