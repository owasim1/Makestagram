//
//  MainTabBarController.swift
//  Makestagram
//
//  Created by Omar Wasim on 6/29/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import UIKit


class MainTabBarController: UITabBarController {
    
    let photoHelper = MGPhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoHelper.completionHandler = { image in
            PostService.create(for: image)
        }

        delegate = self
        tabBar.unselectedItemTintColor = .black
    }
    
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 2 {
            photoHelper.presentActionSheet(from: self)
            return false
        }
        
        return true
    }
}
