//
//  NavigationController.swift
//  AR-App
//
//  Created by Jack Burrows on 22/02/2023.
//
/*
import Foundation
import UIKit
import ARKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewController = UIViewController()
        self.setViewControllers([viewController], animated: false)
        
        let arButton = UIBarButtonItem(title: "AR", style: .plain, target: self, action: #selector(openARViewController))
        let menuButton = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(openMenuViewController))
        navigationItem.rightBarButtonItems = [arButton, menuButton]
    }
    
    @objc func openARViewController() {
        let arViewController = ARViewController()
        self.pushViewController(arViewController, animated: true)
    }
    
    @objc func openMenuViewController() {
        let menuViewController = MenuViewController()
        self.pushViewController(menuViewController, animated: true)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard let navigationController = self.navigationController else {
            return
        }
        navigationController.pushViewController(viewController, animated: animated)
    }
}
*/
