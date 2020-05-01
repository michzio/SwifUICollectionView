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
    
    let queue = DispatchQueue(label: "diffQueue")
    
    lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = {
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: cellProvider)
        return dataSource
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .red //.clear
        return collectionView
    }()
    
    var isLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        
        // load initial data
        reloadDataSource()
        
        isLoaded = true
    }
}

extension CollectionViewController {
    
    func reloadDataSource(animating: Bool = false) {
    
        dataSource.apply(snapshot, animatingDifferences: animating) {
            print("applying snapshot completed!")
        }
    }
}

extension CollectionViewController {
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.register(HostingControllerCollectionViewCell<AnyView>.self, forCellWithReuseIdentifier: HostingControllerCollectionViewCell<AnyView>.reuseIdentifier)
        
        collectionView.delegate = self
        
        print("configured collection view")
    }
    
    private func cellProvider(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? {
        
        print("providing cell for \(indexPath)...")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HostingControllerCollectionViewCell<AnyView>.reuseIdentifier, for: indexPath) as? HostingControllerCollectionViewCell<AnyView> else {
            fatalError("Could not load cell")
        }
        
        //cell.host(AnyView(Text(item.title)))
        cell.host(content(indexPath, item))
        
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        print("Item selected: \(item)")
    }
}
