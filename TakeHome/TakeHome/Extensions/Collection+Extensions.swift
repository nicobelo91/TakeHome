//
//  Collection+Extensions.swift
//  TakeHome
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

import Foundation

extension RangeReplaceableCollection {
    func every(from: Index? = nil, through: Index? = nil, nth: Int) -> Self {
        .init(stride(from: from, through: through, by: nth))
    }
}

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
