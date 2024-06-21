//
//  WordCounter+CoreDataHelpers.swift
//  TakeHome
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

import Foundation

extension WordCounter {
    var word: String {
        text ?? "-"
    }
    
    var wordCount: Int {
        Int(count)
    }
}
