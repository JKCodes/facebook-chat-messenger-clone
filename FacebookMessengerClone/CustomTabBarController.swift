//
//  CustomTabBarController.swift
//  FacebookFeedClone
//
//  Created by Joseph Kim on 3/23/17.
//  Copyright © 2017 Joseph Kim. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let friendVC = FriendsController(collectionViewLayout: layout)
        friendVC.navigationItem.title = "Recent"
        let friendsController = UINavigationController(rootViewController: friendVC)
        friendsController.title = "Recent"
        friendsController.tabBarItem.image = #imageLiteral(resourceName: "recent")
        
        viewControllers = [friendsController, createTemporaryController(title: "Calls", imageName: "calls"), createTemporaryController(title: "Groups", imageName: "groups"), createTemporaryController(title: "People", imageName: "people"), createTemporaryController(title: "Settings", imageName: "settings")]
    }
    
    private func createTemporaryController(title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
        let navController = UINavigationController(rootViewController: viewController)
        navController.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}
