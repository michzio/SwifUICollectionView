//
//  EmptySupplementaryView.swift
//  SwiftUICollectionView
//
//  Created by Michal Ziobro on 02/05/2020.
//  Copyright © 2020 click5 Interactive. All rights reserved.
//

import UIKit

class EmptySupplementaryView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    func configure() {
        self.backgroundColor = .clear
    }
}
