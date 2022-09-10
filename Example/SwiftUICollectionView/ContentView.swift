//
//  ContentView.swift
//  SwiftUICollectionView
//
//  Created by Michal Ziobro on 01/05/2020.
//  Copyright © 2020 elector. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var sections: [Section] = [.feature, .categories]
    
    var body: some View {
       
        ZStack {
            CollectionView(
                layout: createLayout(),
                sections: sections,
                items: [
                    .feature : Item.featureItems,
                    .categories : Item.categoryItems
                ],
                supplementaryKinds: [UICollectionView.elementKindSectionHeader, UICollectionView.elementKindSectionFooter],
                supplementaryContent: { kind, indexPath, item in
                    switch kind {
                    case UICollectionView.elementKindSectionHeader:
                        return AnyView(Text("Header").font(.system(size: indexPath.section == 0 ? 30 : 16)))
                    case UICollectionView.elementKindSectionFooter:
                        return AnyView(Text("Footer"))
                    default:
                        return AnyView(EmptyView())
                    }
                },
            content: { indexPath, item in
                let section = sections[indexPath.section]
                AnyView(
                    Text("\(section.rawValue) (\(indexPath.section), \(indexPath.row))")
                        .padding(16)
                        .foregroundColor(Color.white)
                        .background(section == .feature ? Color.green : Color.red)
                )
            })
            
            VStack {
                Spacer()
                Button(action: {
                    if sections.first == .categories {
                        sections = [.feature, .categories]
                    } else {
                        sections = [.categories, .feature]
                    }
                }) {
                    Text("Change!")
                }
                .padding(8)
                .background(Color.yellow)
            }
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        //createTwoColumnLayout()
        createTwoSectionLayout()
    }
    
    private func createTwoColumnLayout() -> UICollectionViewLayout {
    
        let section = createTwoColumnSection()
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createTwoSectionLayout() -> UICollectionViewLayout {
        let section1 = createHorizontalSection()
        let section2 = createTwoColumnSection(hasBadges: true)
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            
            switch sectionIndex {
            case 0:
                return section1
            case 1:
                return section2
            default:
                fatalError()
            }
            
        }
        
        //addDecorationItem(to: layout, section: section1)
        //addDecorationItem(to: layout, section: section2)
        
        return layout
    }
    
    private func createHorizontalSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        section.boundarySupplementaryItems = [createHeader(isPinned: true), createFooter(isPinned: true)]
        
        return section
    }
    
    private func createTwoColumnSection(hasBadges: Bool = false) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: hasBadges ? [createBadge()] : [])
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        section.boundarySupplementaryItems = [createHeader(isPinned: true), createFooter(isPinned: true)]
        
        return section
    }
    
    private func createBadge() -> NSCollectionLayoutSupplementaryItem {
        
        let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0.3, y: -0.3))
        
        let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20), heightDimension: .absolute(20))
        
        let badge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize, elementKind: "badge", containerAnchor: badgeAnchor)
        
        return badge
    }
    
    private func createHeader(isPinned: Bool = false) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        header.pinToVisibleBounds = isPinned
        header.zIndex = 2
        return header
    }
    
    private func createFooter(isPinned: Bool = false) -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(44))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        footer.pinToVisibleBounds = isPinned
        footer.zIndex = 2
        return footer
    }
    
    private func addDecorationItem(to layout: UICollectionViewCompositionalLayout, section: NSCollectionLayoutSection) {
        
        let decorationItem = NSCollectionLayoutDecorationItem.background(elementKind: "background")
        decorationItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        section.decorationItems = [decorationItem]
        
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: "background")
    }
}
