//
//  MainTabBarController.swift
//  BoxScan
//
//  Created by Jeremy Kim on 7/25/17.
//  Copyright © 2017 SimpleSwift. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    let photoHelper = MGPhotoHelper() 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        photoHelper.completionHandler = { image in
            PostService.create(for: image)
        }
        
        delegate = self
        tabBar.unselectedItemTintColor = .black
        */
    }
}

/*
extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            photoHelper.presentActionSheet(from: self)
            return false
        }
        
        return true
    }
}
*/
