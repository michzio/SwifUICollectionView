//
//  CollectionViewController.swift
//  SwiftUICollectionView
//
//  Created by Michal Ziobro on 01/05/2020.
//  Copyright © 2020 elector. All rights reserved.
//

import UIKit
import SwiftUI

public class CollectionViewController<Section, Item>: UIViewController, UICollectionViewDelegate where Section: Hashable, Item: Hashable {

    // MARK: - Injections
    var layout: UICollectionViewLayout!
    var snapshot: NSDiffableDataSourceSnapshot<Section, Item>!

    var supplementaryKinds: [String] = []
    var supplementaryContent: ((_ kind: String, _ indexPath: IndexPath, _ item: Item?) -> AnyView)?
    var content: ((_ indexPath: IndexPath, _ item: Item) -> AnyView)!

    var onSelectItem: ((_ collectionView: UICollectionView, _ item: Item, _ indexPath: IndexPath) -> Void)?

    // MARK: - Properties
    private(set) var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    // MARK: - Views
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    // MARK: - Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        configureDataSource()

        reloadDataSource(animating: false)
    }

    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }

        onSelectItem?(collectionView, item, indexPath)
    }
}

// MARK: - Setup
extension CollectionViewController {
    private func configureCollectionView() {
        view.addSubview(collectionView)

        registerCells()
        registerSupplementaryViews()

        collectionView.delegate = self
    }

    private func registerCells() {
        if #available(iOS 16, *) {
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.reuseIdentifier)
        } else {
            collectionView.register(HostingControllerCollectionViewCell<AnyView>.self, forCellWithReuseIdentifier: HostingControllerCollectionViewCell<AnyView>.reuseIdentifier)
        }
    }

    private func registerSupplementaryViews() {
        collectionView.register(BadgeSupplementaryView.self, forSupplementaryViewOfKind: "badge", withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier)
        collectionView.register(EmptySupplementaryView.self, forSupplementaryViewOfKind: "badge", withReuseIdentifier: EmptySupplementaryView.reuseIdentifier)

        supplementaryKinds.forEach { kind in
            collectionView.register(HostingControllerCollectionReusableView<AnyView>.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: HostingControllerCollectionReusableView<AnyView>.reuseIdentifier)
        }
    }
}

// MARK: - Data Source
extension CollectionViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: cellProvider)
        dataSource.supplementaryViewProvider = supplementaryViewProvider
    }

    func reloadDataSource(animating: Bool = true) {
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: animating)
        }
    }
}

// MARK: - Item Providers
extension CollectionViewController {
    private func cellProvider(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? {
        if #available(iOS 16, *) {
            return contentCellProvider(collectionView, indexPath, item)
        } else {
            return fallbackContentCellProvider(collectionView, indexPath, item)
        }
    }

    @available(iOS 16, *)
    private func contentCellProvider(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ item: Item) -> UICollectionViewCell? {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.reuseIdentifier, for: indexPath)
        cell.contentConfiguration = UIHostingConfiguration { [weak self] in
            self?.content(indexPath, item)
        }
        return cell
    }

    private func fallbackContentCellProvider(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ item: Item) -> UICollectionViewCell? {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HostingControllerCollectionViewCell<AnyView>.reuseIdentifier, for: indexPath) as? HostingControllerCollectionViewCell<AnyView> else {
            fatalError("Could not load cell")
        }

        cell.host(content(indexPath, item))
        return cell
    }

    /// This function is only for testing purposes
    private func itemCellProvider(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ item: Item) -> UICollectionViewCell? {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseIdentifier, for: indexPath) as? ItemCell else {
            fatalError("Cannot create new cell")
        }

        cell.label.text = "\(indexPath.item)"
        cell.contentView.backgroundColor = .systemBlue
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.label.textAlignment = .center
        cell.label.textColor = .white
        cell.label.font = UIFont.preferredFont(forTextStyle: .title1)

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

        let item = dataSource.itemIdentifier(for: indexPath)

        guard let content = supplementaryContent?(kind, indexPath, item) else {
            fatalError("Supplementary view content not provided for kind: \(kind), indexPath: \(indexPath). Please provide supplementaryContent closure parameter to CollectionView returning some View and provide kind in supplementaryKinds array parameter. Or remove this kind: \(kind) from layout definition.")
        }

        view.host(content)

        return view
    }

    private func badgeViewProvider(_ collectionView: UICollectionView, _ kind: String, _ indexPath: IndexPath) -> UICollectionReusableView? {

        if let item = dataSource.itemIdentifier(for: indexPath) as? HasBadgeCount,
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
