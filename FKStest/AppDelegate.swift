//
//  AppDelegate.swift
//  FKStest
//
//  Created by Студия on 07.10.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let appCoordinator = AppCoordinator(navC: UINavigationController())

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.appCoordinator.start()
        
		return true
	}

}

