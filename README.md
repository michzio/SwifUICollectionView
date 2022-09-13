# SwifUICollectionView

Read my tutorial to learn more about SwiftUI CollectionView 

https://medium.com/@michaziobro_21492/uicollectionview-in-swiftui-reusable-component-with-uicollectionviewcompositionallayout-and-a26d4b64dd94


# Usage - Cocoapods 

```
pod 'SwifUICollectionView'
```

# Usage - Swift Package Manager

Once you have your Swift package set up, adding SwifUICollectionView as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```
dependencies: [
    .package(url: "https://github.com/michzio/SwifUICollectionView.git", .upToNextMajor(from: "0.0.9"))
]
```


# How to use 

```
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
                    ZStack {
                        section == .feature ? Color.green : Color.red

                        Text("\(section.rawValue) (\(indexPath.section), \(indexPath.row))")
                            .padding(16)
                            .foregroundColor(Color.white)
                    }
                )
            }
)
```
