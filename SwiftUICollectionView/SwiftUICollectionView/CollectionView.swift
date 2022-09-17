//
//  CollectionView.swift
//  SwiftUICollectionView
//
//  Created by Michal Ziobro on 01/05/2020.
//  Copyright © 2020 elector. All rights reserved.
//

import SwiftUI
import UIKit

public struct CollectionView<Section: Hashable, Item: Hashable>: UIViewControllerRepresentable {

    // MARK: - Properties
    private let layout: UICollectionViewLayout
    private let sections: [Section]
    private let items: [Section: [Item]]
    private let supplementaryKinds: [String]
    private let animateChanges: Bool?
    private let selectedItem: Binding<Item?>?
    
    // MARK: - Actions
    private let content: (_ indexPath: IndexPath, _ item: Item) -> AnyView
    private let supplementaryContent: ((_ kind: String, _ indexPath: IndexPath, _ section: Section?, _ item: Item?) -> AnyView)?

    private let snapshotProvider:(() -> NSDiffableDataSourceSnapshot<Section, Item>)?
    private let selectionAction: ((_ collectionView: UICollectionView, _ item: Item, _ indexPath: IndexPath) -> Void)?
   
    public init(
        layout: UICollectionViewLayout,
        sections: [Section],
        items: [Section: [Item]],
        supplementaryKinds: [String] = [],
        animateChanges: Bool? = nil,
        snapshotProvider: (() -> NSDiffableDataSourceSnapshot<Section, Item>)? = nil,
        selectedItem: Binding<Item?>? = nil,
        selectionAction: ((_ collectionView: UICollectionView, _ item: Item, _ indexPath: IndexPath) -> Void)? = nil,
        @ViewBuilder supplementaryContent: @escaping (_ kind: String, _ IndexPath: IndexPath, _ section: Section?, _ item: Item?) -> AnyView,
        @ViewBuilder content:  @escaping (_ indexPath: IndexPath, _ item: Item) -> AnyView
    ) {
        self.layout = layout
        
        self.sections = sections
        self.items = items
        self.snapshotProvider = snapshotProvider
        self.selectionAction = selectionAction
        self.animateChanges = animateChanges
        self.selectedItem = selectedItem
        
        self.supplementaryKinds = supplementaryKinds
        self.supplementaryContent = supplementaryContent
        
        self.content = content
    }

    public init(
        layout: UICollectionViewLayout,
        sections: [Section],
        items: [Section: [Item]],
        animateChanges: Bool? = nil,
        snapshotProvider: (() -> NSDiffableDataSourceSnapshot<Section, Item>)? = nil,
        selectedItem: Binding<Item?>? = nil,
        selectionAction: ((_ collectionView: UICollectionView, _ item: Item, _ indexPath: IndexPath) -> Void)? = nil,
        @ViewBuilder content:  @escaping (_ indexPath: IndexPath, _ item: Item) -> AnyView
    ) {
        self.layout = layout

        self.sections = sections
        self.items = items
        self.snapshotProvider = snapshotProvider
        self.selectionAction = selectionAction
        self.animateChanges = animateChanges
        self.selectedItem = selectedItem

        self.supplementaryKinds = []
        self.supplementaryContent = nil

        self.content = content
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIViewController(context: Context) -> CollectionViewController<Section, Item> {
        
        let controller = CollectionViewController<Section, Item>()
        controller.layout = layout
        controller.content = content
        controller.supplementaryContent = supplementaryContent
        controller.supplementaryKinds = supplementaryKinds
        
        controller.snapshot = snapshotForCurrentState()

        controller.onSelectItem = { collectionView, item, indexPath in
            selectedItem?.wrappedValue = item
            selectionAction?(collectionView, item, indexPath)
        }
        
        return controller
    }
    
    public func updateUIViewController(_ controller: CollectionViewController<Section, Item>, context: Context) {

        let animating = animateChanges ?? smallItemsCount()
        
        controller.snapshot = snapshotForCurrentState()
        controller.reloadDataSource(animating: animating)
    }
    
    private func smallItemsCount() -> Bool {
        items.reduce(0) { (res, items) in
            res + items.1.count
        } < 1000
    }
}

extension CollectionView {
    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Item> {

        if let snapshotProvider = snapshotProvider {
            return snapshotProvider()
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(items[section]!, toSection: section)
        }
        return snapshot
    }
}
