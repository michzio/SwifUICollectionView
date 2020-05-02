//
//  ContentView.swift
//  SwiftUICollectionView
//
//  Created by Michal Ziobro on 01/05/2020.
//  Copyright © 2020 click5 Interactive. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var sections: [Section] = [.feature]
    
    var body: some View {
       
        CollectionView(layout: UICollectionView.generateCompositionalLayout(),
                       sections: self.sections,
                       items: [
                        .feature : Item.featureItems,
                        .categories : Item.categoryItems
                        ],
                       content: { indexPath, item in
            
                        AnyView(Text("\(self.sections.first!.rawValue) (\(indexPath.section), \(indexPath.row))"))
        })
        .onTapGesture {
            print("Tap gesture!")
            self.sections = [.categories]
        }
    }
}
