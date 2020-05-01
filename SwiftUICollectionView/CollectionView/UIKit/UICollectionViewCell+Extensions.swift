//
//  UICollectionViewCell+Extensions.swift
//  SwiftUICollectionView
//
//  Created by Michal Ziobro on 01/05/2020.
//  Copyright © 2020 click5 Interactive. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
    @objc class var reuseIdentifier : String {
        return String(describing: self)
    }
}
