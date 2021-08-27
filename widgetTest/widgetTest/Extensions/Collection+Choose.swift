//
//  Collection+Choos.swift
//  widgetTest
//
//  Created by Felipe Nishino on 27/08/21.
//

import Foundation

/// Returns n random elements from the collection. Note that n needs to be less that collection.count
extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}
