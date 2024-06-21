//
//  Collection+Extensions.swift
//  TakeHome
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

import Foundation

extension Collection {
    func stride(from: Index? = nil, through: Index? = nil, by: Int) -> AnySequence<Element> {
        var index = from ?? startIndex
        let endIndex = through ?? self.endIndex
        return AnySequence(AnyIterator {
            guard index < endIndex else { return nil }
            defer { index = self.index(index, offsetBy: by, limitedBy: endIndex) ?? endIndex }
            return self[index]
        })
    }
}

extension Collection {
    var indexedDictionary: [Int: Element] {
        return Dictionary(uniqueKeysWithValues: enumerated().map{($0,$1)})
    }
}
