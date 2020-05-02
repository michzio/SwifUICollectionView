//
//  HostingControllerCollectionReusableView.swift
//  SwiftUICollectionView
//
//  Created by Michal Ziobro on 02/05/2020.
//  Copyright © 2020 click5 Interactive. All rights reserved.
//

import SwiftUI

class HostingControllerCollectionReusableView<Content: View>: UICollectionReusableView {
   
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
            self.addSubview(controller.view)
            
            // constraint subview
            NSLayoutConstraint.activate([
                controller.view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                controller.view.topAnchor.constraint(equalTo: self.topAnchor),
                controller.view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
            
            // move to parent
            if let parent = parent {
                controller.didMove(toParent: parent)
            }
            
            controller.view.layoutIfNeeded()
        }
    }
}

