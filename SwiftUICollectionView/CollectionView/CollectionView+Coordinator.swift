//
//  CollectionView+Coordinator.swift
//  SwiftUICollectionView
//
//  Created by Michal Ziobro on 01/05/2020.
//  Copyright © 2020 click5 Interactive. All rights reserved.
//

import SwiftUI

extension CollectionView {
    
    class Coordinator: NSObject, CollectionViewControllerDelegate {
        
        let parent: CollectionView
        
        init(_ parent: CollectionView) {
            self.parent = parent
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItem item: Item, at indexPath: IndexPath) {
            print("Did select item at \(indexPath)")
            
        }
    }
}
