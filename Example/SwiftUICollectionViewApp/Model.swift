//
//  Model.swift
//  SwiftUICollectionView
//
//  Created by Michal Ziobro on 01/05/2020.
//  Copyright © 2020 elector. All rights reserved.
//

import Foundation
import SwiftUICollectionView

enum Section: String, CaseIterable, Hashable {
    case feature
    case categories
}

class Item: Hashable {
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    let identifier = UUID()
}

extension Item {
    static let featureItems: [Item] = {
        (0..<10_000).map { Item(title: "Feature Item \($0)")}
    }()

    static let categoryItems: [Item] = {
        (10_000..<20_000).map { Item(title: "Category Item \($0)")}
    }()
}


extension Item: HasBadgeCount {
    
    var badgeCount: Int? {
        let count = Int.random(in: 0...10)
        if count % 2 == 0 {
            return count
        }
        return nil 
    }
}
