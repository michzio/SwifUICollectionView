//
//  CollectionViewController.swift
//  SwiftUICollectionView
//
//  Created by Michal Ziobro on 01/05/2020.
//  Copyright © 2020 click5 Interactive. All rights reserved.
//

import UIKit
import SwiftUI

protocol CollectionViewControllerDelegate: class {
    func collectionView(_ collectionView: UICollectionView, didSelectItem: Item, at indexPath: IndexPath)
}

class CollectionViewController: UIViewController {
    
    // MARK: - Injections
    var layout: UICollectionViewLayout! = nil
    var snapshot: NSDiffableDataSourceSnapshot<Section, Item>! = nil
    var content: ((_ indexPath: IndexPath, _ item: Item) -> AnyView)! = nil

    var supplementaryKinds: [String]! = nil
    var supplementaryContent: ((_ kind: String, _ indexPath: IndexPath, _ item: Item?) -> AnyView)? = nil
    weak var delegate: CollectionViewControllerDelegate? = nil
    
    // MARK: - Properties
    private(set) var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private let diffQueue = DispatchQueue.global(qos: .background)
    
    // MARK: - Views
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .red //.clear
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureDataSource()
        
        // load initial data
        reloadDataSource(animating: false)
    }
}

/*
// MARK: - Init
extension CollectionViewController {
    
      convenience init() {
          self.init(layout: UICollectionViewFlowLayout())
      }
      
      init(layout: UICollectionViewLayout) {
          self.layout = layout
          super.init(nibName: nil, bundle: nil)
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
*/

// MARK: - Setup
extension CollectionViewController {
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        registerCells()
        registerSupplementaryViews()
    
        collectionView.delegate = self
    }
    
    private func registerCells() {
        collectionView.register(HostingControllerCollectionViewCell<AnyView>.self, forCellWithReuseIdentifier: HostingControllerCollectionViewCell<AnyView>.reuseIdentifier)
        
        //collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
        
    }
    
    private func registerSupplementaryViews() {
        collectionView.register(BadgeSupplementaryView.self, forSupplementaryViewOfKind: "badge", withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier)
        collectionView.register(EmptySupplementaryView.self, forSupplementaryViewOfKind: "badge", withReuseIdentifier: EmptySupplementaryView.reuseIdentifier)
        
        supplementaryKinds.forEach { kind in
            collectionView.register(HostingControllerCollectionReusableView<AnyView>.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: HostingControllerCollectionReusableView<AnyView>.reuseIdentifier)
        }
    }
    
    private func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: cellProvider)
        
        dataSource.supplementaryViewProvider = supplementaryViewProvider
    }
}

// MARK: - Data Source
extension CollectionViewController {
    
    func reloadDataSource(animating: Bool = false) {
        
        diffQueue.async {
        //DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: animating)
        }
    }
}

// MARK: - Item Providers
extension CollectionViewController {
    
    private func cellProvider(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? {
        
        print("providing cell for \(indexPath)...")
    
        //return itemCellProvider(collectionView, indexPath, item)
        return contentCellProvider(collectionView, indexPath, item)
    }
    
    private func contentCellProvider(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ item: Item) -> UICollectionViewCell? {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HostingControllerCollectionViewCell<AnyView>.reuseIdentifier, for: indexPath) as? HostingControllerCollectionViewCell<AnyView> else {
            fatalError("Could not load cell")
        }
        
        cell.host(content(indexPath, item))
        cell.backgroundColor = .green
        
        return cell
    }
    
    private func itemCellProvider(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ item: Item) -> UICollectionViewCell? {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseIdentifier, for: indexPath) as? ItemCell else {
            fatalError("Could not load cell")
        }
        
        cell.label.text = "\(indexPath)"
        
        return cell
    }
    
    private func supplementaryViewProvider(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
    
        if kind == "badge" {
            return badgeViewProvider(collectionView, kind, indexPath)
        } else {
            return contentSupplementaryProvider(collectionView, kind, indexPath)
        }
    }
    
    private func contentSupplementaryProvider(_ collectionView: UICollectionView, _ kind: String, _ indexPath: IndexPath) -> UICollectionReusableView? {
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HostingControllerCollectionReusableView<AnyView>.reuseIdentifier, for: indexPath) as? HostingControllerCollectionReusableView<AnyView> else {
            fatalError("Could not load supplementary view")
        }
        
        let item = self.dataSource.itemIdentifier(for: indexPath)
        
        guard let content = self.supplementaryContent?(kind, indexPath, item) else {
            fatalError("Supplementary view content not provided for kind: \(kind), indexPath: \(indexPath). Please provide supplementaryContent closure parameter to CollectionView returning some View and provide kind in supplementaryKinds array parameter. Or remove this kind: \(kind) from layout definition.")
        }
        
        view.host(content)
        
        return view
    }
    
    private func badgeViewProvider(_ collectionView: UICollectionView, _ kind: String, _ indexPath: IndexPath) -> UICollectionReusableView? {
        
        if let item = self.dataSource.itemIdentifier(for: indexPath),
            item is HasBadgeCount,
            let badgeCount = item.badgeCount {
            
            guard let badgeView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier, for: indexPath) as? BadgeSupplementaryView else {
                fatalError("Cannot create badge supplementary")
            }
            
            badgeView.label.text = "\(badgeCount)"
            return badgeView
        } else {
            
            guard let emptyView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmptySupplementaryView.reuseIdentifier, for: indexPath) as? EmptySupplementaryView else {
                fatalError("Cannot create badge supplementary")
            }
            
            return emptyView
        }
    }
}

// MARK: - Delegate
extension CollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }

        print("Item selected: \(item)")
        
        delegate?.collectionView(collectionView, didSelectItem: item, at: indexPath)
    }
}
