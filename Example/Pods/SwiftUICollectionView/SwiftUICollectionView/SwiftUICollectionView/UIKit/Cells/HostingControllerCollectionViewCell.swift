//
//  HostingControllerCollectionViewCell.swift
//  SwiftUICollectionView
//
//  Created by Michal Ziobro on 01/05/2020.
//  Copyright © 2020 elector. All rights reserved.
//

import SwiftUI

class HostingControllerCollectionViewCell<Content: View> : UICollectionViewCell {
    
    var controller: UIHostingController<Content>?
    
    func host(_ view: Content, parent: UIViewController? = nil) {
        
        if let controller = controller {
            controller.rootView = view
            controller.view.layoutIfNeeded()
        } else {
            let controller = UIHostingController(rootView: view)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            controller.view.backgroundColor = .clear
            self.controller = controller
            
            // add child
            parent?.addChild(controller)
            
            // add subview
            contentView.addSubview(controller.view)
            
            // constraint subview
            NSLayoutConstraint.activate([
                controller.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                controller.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                controller.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
            
            // move to parent
            if let parent = parent {
                controller.didMove(toParent: parent)
            }
            
            controller.view.layoutIfNeeded()
        }
    }
}
