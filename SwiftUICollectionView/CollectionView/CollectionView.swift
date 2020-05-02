//
//  CollectionView.swift
//  SwiftUICollectionView
//
//  Created by Michal Ziobro on 01/05/2020.
//  Copyright © 2020 click5 Interactive. All rights reserved.
//

import SwiftUI
import UIKit

struct CollectionView: UIViewControllerRepresentable {
    
    // MARK: - Properties
    let layout: UICollectionViewLayout
    let sections: [Section]
    let items: [Section: [Item]]
    let animateChanges: Bool?
    
    // MARK: - Actions
    let content: (_ indexPath: IndexPath, _ item: Item) -> AnyView
   
    init(layout: UICollectionViewLayout,
         sections: [Section],
         items: [Section: [Item]],
         animateChanges: Bool? = nil,
         @ViewBuilder content:  @escaping (_ indexPath: IndexPath, _ item: Item) -> AnyView) {
        self.layout = layout
        
        self.sections = sections
        self.items = items
        
        self.animateChanges = animateChanges
        
        self.content = content
    }
    
    func makeUIViewController(context: Context) -> CollectionViewController {
        
        let controller = CollectionViewController()
        controller.layout = layout
        controller.content = content
        controller.snapshot = snapshotForCurrentState()
        
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ controller: CollectionViewController, context: Context) {
       
        print("updating controller...")
        let animating = self.animateChanges ?? smallItemsCount()
        
        controller.snapshot = self.snapshotForCurrentState()
        controller.reloadDataSource(animating: animating)
    }
    
    func smallItemsCount() -> Bool {
        items.reduce(0) { (res, items) in
            res + items.1.count
        } < 1000
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension CollectionView {
    
    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Item> {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(items[section]!, toSection: section)
        }
        
        return snapshot
    }
}
