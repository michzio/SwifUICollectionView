//
//  SectionBackgroundDecorationView.swift
//  SwiftUICollectionView
//
//  Created by Michal Ziobro on 02/05/2020.
//  Copyright © 2020 elector. All rights reserved.
//

import UIKit

public class SectionBackgroundDecorationView: UICollectionReusableView {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension SectionBackgroundDecorationView {
    func configure() {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 12
    }
}
