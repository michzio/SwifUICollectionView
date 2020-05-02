//
//  BadgeSupplementaryView.swift
//  SwiftUICollectionView
//
//  Created by Michal Ziobro on 02/05/2020.
//  Copyright © 2020 click5 Interactive. All rights reserved.
//

import UIKit

protocol HasBadgeCount {
    var badgeCount: Int? { get }
}

class BadgeSupplementaryView: UICollectionReusableView {
    
    lazy var label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .black
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override var frame: CGRect {
        didSet {
            configureBorder()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            configureBorder()
        }
    }
}

extension BadgeSupplementaryView {
    
    func configure() {
        self.addSubview(label)
        self.backgroundColor = .green
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configureBorder() {
        let radius = bounds.width / 2.0
        layer.cornerRadius = radius
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
    }
}
