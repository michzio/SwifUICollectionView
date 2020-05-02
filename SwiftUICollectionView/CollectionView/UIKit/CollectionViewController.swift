//
//  CollectionViewController.swift
//  SwiftUICollectionView
//
//  Created by Michal Ziobro on 01/05/2020.
//  Copyright © 2020 click5 Interactive. All rights reserved.
//

import UIKit
import SwiftUI

class CollectionViewController: UIViewController {
    
    var layout: UICollectionViewLayout! = nil
    var snapshot: NSDiffableDataSourceSnapshot<Section, Item>! = nil
    var content: ((_ indexPath: IndexPath, _ item: Item) -> AnyView)! = nil
    
    lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = {
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: cellProvider)
        //dataSource.supplementaryViewProvider = supplementaryViewProvider
        return dataSource
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .red //.clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        
        // load initial data
        reloadDataSource()
    }
}

extension CollectionViewController {
    
    func reloadDataSource(animating: Bool = false) {

        print("reloading data source with snapshot -> \(snapshot.numberOfItems)")
        
        self.dataSource.apply(self.snapshot, animatingDifferences: animating) {
            print("applying snapshot completed!")
        }
    }
}

extension CollectionViewController {
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.register(HostingControllerCollectionViewCell<AnyView>.self, forCellWithReuseIdentifier: HostingControllerCollectionViewCell<AnyView>.reuseIdentifier)
        
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
        
        collectionView.delegate = self
        
        print("configured collection view")
    }
    
    private func cellProvider(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? {
        
        print("providing cell for \(indexPath)...")
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseIdentifier, for: indexPath) as? ItemCell else {
            fatalError("Could not load cell")
        }
        
        cell.label.text = "\(indexPath)"
        
        /*
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HostingControllerCollectionViewCell<AnyView>.reuseIdentifier, for: indexPath) as? HostingControllerCollectionViewCell<AnyView> else {
            fatalError("Could not load cell")
        }
        
        //cell.host(AnyView(Text(item.title)))
        cell.host(content(indexPath, item))
        cell.backgroundColor = .green
        */
        
        return cell
    }
    
    /* TODO
    private func supplementaryViewProvider(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        
        
    }*/
}

extension CollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        print("Item selected: \(item)")
    }
}
