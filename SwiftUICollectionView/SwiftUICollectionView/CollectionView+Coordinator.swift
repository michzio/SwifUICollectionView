//
//  CollectionView+Coordinator.swift
//  SwiftUICollectionView
//
//  Created by Michal Ziobro on 01/05/2020.
//  Copyright © 2020 elector. All rights reserved.
//

import SwiftUI

extension CollectionView {
    
    class Coordinator: NSObject {
        
        let parent: CollectionView
        
        init(_ parent: CollectionView) {
            self.parent = parent
        }
    }
}
